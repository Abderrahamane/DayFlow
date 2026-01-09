import 'package:dayflow/services/firestore_service.dart';
import 'package:dayflow/services/backend_api_service.dart';
import 'package:dayflow/services/sync_status_service.dart';
import 'package:flutter/material.dart';
import '../../models/note_model.dart';
import '../local/app_database.dart';

class NoteRepository {
  final AppDatabase _localDb;
  final FirestoreService _firestoreService;
  final BackendApiService? _api;

  // Sync status tracking
  final SyncStatusService _syncStatus = SyncStatusService();
  bool _isSyncing = false;
  DateTime? _lastSyncTime;

  NoteRepository(this._localDb, this._firestoreService,
      {BackendApiService? api})
      : _api = api;

  /// Check if backend API sync is available
  bool get _useBackend =>
      _api != null && _firestoreService.currentUserId != null;

  /// Check if Firestore sync is available (just needs logged in user)
  bool get _useFirestore => _firestoreService.currentUserId != null;

  Future<void> _ensureDb() async => _localDb.init();

  Future<void> _upsertNoteFirestore(Note note) async {
    final col = _firestoreService.notes;
    if (col == null) return;
    await col.doc(note.id).set(note.toFirestore());
  }

  Future<void> _deleteNoteFirestore(String id) async {
    final col = _firestoreService.notes;
    if (col == null) return;
    await col.doc(id).delete();
  }

  Future<void> _syncNotesFirestore(List<Note> notes) async {
    final col = _firestoreService.notes;
    if (col == null) return;
    for (final note in notes) {
      await col.doc(note.id).set(note.toFirestore());
    }
  }

  Future<void> _cacheNotesLocal(List<Note> notes) async {
    await _ensureDb();
    _localDb.rawDb.execute('DELETE FROM notes');
    for (final note in notes) {
      await _saveNoteLocal(note);
    }
  }

  Future<List<Note>> _fetchNotesLocal(
      {String? whereClause, List<Object?>? args}) async {
    await _ensureDb();
    final result = _localDb.rawDb.select(
        'SELECT * FROM notes ${whereClause ?? ''} ORDER BY isPinned DESC, updatedAt DESC, createdAt DESC',
        args ?? const []);
    return result.map((row) => Note.fromDatabase(row)).toList();
  }

  Future<void> _saveNoteLocal(Note note) async {
    await _ensureDb();
    final data = note.toDatabase();
    _localDb.rawDb.execute(
      '''INSERT OR REPLACE INTO notes 
          (id, title, content, createdAt, updatedAt, colorValue, tagsJson, isPinned,
           type, attachmentsJson, checklistJson, isLocked, lockPin, useBiometric, category) 
          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)''',
      [
        data['id'],
        data['title'],
        data['content'],
        data['createdAt'],
        data['updatedAt'],
        data['colorValue'],
        data['tagsJson'],
        data['isPinned'],
        data['type'],
        data['attachmentsJson'],
        data['checklistJson'],
        data['isLocked'],
        data['lockPin'],
        data['useBiometric'],
        data['category'],
      ],
    );
  }

  Future<void> _deleteNoteLocal(String id) async {
    await _ensureDb();
    _localDb.rawDb.execute('DELETE FROM notes WHERE id = ?', [id]);
  }

  Future<void> _togglePinLocal(String id) async {
    await _ensureDb();
    _localDb.rawDb.execute(
      'UPDATE notes SET isPinned = CASE WHEN isPinned = 1 THEN 0 ELSE 1 END, updatedAt = ? WHERE id = ?',
      [DateTime.now().millisecondsSinceEpoch, id],
    );
  }

  Future<void> _updateColorLocal(String id, int? colorValue) async {
    await _ensureDb();
    _localDb.rawDb.execute(
      'UPDATE notes SET colorValue = ?, updatedAt = ? WHERE id = ?',
      [colorValue, DateTime.now().millisecondsSinceEpoch, id],
    );
  }

  Future<void> _lockNoteLocal(String id, String? pin, bool useBiometric) async {
    await _ensureDb();
    _localDb.rawDb.execute(
      'UPDATE notes SET isLocked = 1, lockPin = ?, useBiometric = ?, updatedAt = ? WHERE id = ?',
      [pin, useBiometric ? 1 : 0, DateTime.now().millisecondsSinceEpoch, id],
    );
  }

  Future<void> _unlockNoteLocal(String id) async {
    await _ensureDb();
    _localDb.rawDb.execute(
      'UPDATE notes SET isLocked = 0, lockPin = NULL, useBiometric = 0, updatedAt = ? WHERE id = ?',
      [DateTime.now().millisecondsSinceEpoch, id],
    );
  }

  /// LOCAL-FIRST: Return local data immediately, sync in background
  Future<List<Note>> fetchNotes() async {
    print('📝 NoteRepository.fetchNotes() - LOCAL FIRST');

    final localNotes = await _fetchNotesLocal();
    print('📝 Got ${localNotes.length} notes from local DB');

    // Try to sync with backend in background (with debouncing)
    if (_useBackend && !_isSyncing) {
      final now = DateTime.now();
      if (_lastSyncTime == null ||
          now.difference(_lastSyncTime!).inSeconds > 5) {
        _syncNotesFromBackend();
      }
    }

    return localNotes;
  }

  Future<void> _syncNotesFromBackend() async {
    if (_isSyncing) return;

    _isSyncing = true;
    _lastSyncTime = DateTime.now();
    _syncStatus.startSync('notes');

    try {
      print('📝 Background sync: fetching notes...');
      final notes = await _api!.fetchNotes();
      await _cacheNotesLocal(notes);
      print('✅ Background sync: got ${notes.length} notes');
      _syncStatus.endSync('notes', success: true);
    } catch (e) {
      print('⚠️ Background notes sync failed: $e');
      _syncStatus.endSync('notes', success: false);
    } finally {
      _isSyncing = false;
    }
  }

  Future<Note?> getNoteById(String id) async {
    // Always check local first
    await _ensureDb();
    final result =
        _localDb.rawDb.select('SELECT * FROM notes WHERE id = ?', [id]);
    if (result.isNotEmpty) {
      return Note.fromDatabase(result.first);
    }
    return null;
  }

  Future<List<Note>> getNotesByCategory(NoteCategory category) async {
    print('📝 NoteRepository.getNotesByCategory() - LOCAL FIRST');
    return _fetchNotesLocal(
      whereClause: 'WHERE category = ?',
      args: [category.index],
    );
  }

  Future<List<Note>> getNotesByTag(String tag) async {
    print('📝 NoteRepository.getNotesByTag() - LOCAL FIRST');
    return _fetchNotesLocal(
      whereClause: 'WHERE tagsJson LIKE ?',
      args: ['%$tag%'],
    );
  }

  /// LOCAL-FIRST: Save locally immediately, sync in background
  Future<void> upsertNote(Note note) async {
    print('📝 NoteRepository.upsertNote() - LOCAL FIRST');

    await _saveNoteLocal(note);
    print('✅ Note saved to local DB: ${note.id}');

    // Sync to Firestore (works without backend API)
    if (_useFirestore) {
      _syncNoteToFirestore(note);
    }

    // Sync to backend API in background (optional)
    if (_useBackend) {
      _syncNoteToBackendApi(note);
    }
  }

  Future<void> _syncNoteToFirestore(Note note) async {
    try {
      await _upsertNoteFirestore(note);
      print('✅ Note synced to Firestore: ${note.id}');
    } catch (e) {
      print('⚠️ Firestore sync failed: $e');
    }
  }

  Future<void> _syncNoteToBackendApi(Note note) async {
    try {
      await _api!.saveNote(note);
      print('✅ Background: note synced to backend');
    } catch (e) {
      print('⚠️ Background note sync failed: $e');
    }
  }

  /// LOCAL-FIRST: Delete locally immediately, sync in background
  Future<void> deleteNote(String id) async {
    print('📝 NoteRepository.deleteNote() - LOCAL FIRST');

    await _deleteNoteLocal(id);
    print('✅ Note deleted from local DB');

    // Sync to Firestore (works without backend API)
    if (_useFirestore) {
      _deleteNoteFromFirestore(id);
    }

    // Sync to backend API in background (optional)
    if (_useBackend) {
      _deleteNoteFromBackendApi(id);
    }
  }

  Future<void> _deleteNoteFromFirestore(String id) async {
    try {
      await _deleteNoteFirestore(id);
      print('✅ Note deleted from Firestore: $id');
    } catch (e) {
      print('⚠️ Firestore delete failed: $e');
    }
  }

  Future<void> _deleteNoteFromBackendApi(String id) async {
    try {
      await _api!.deleteNote(id);
      print('✅ Background: note deleted from backend');
    } catch (e) {
      print('⚠️ Background delete failed: $e');
    }
  }

  /// LOCAL-FIRST: Toggle locally immediately, sync in background
  Future<void> togglePin(String id) async {
    print('📝 NoteRepository.togglePin() - LOCAL FIRST');

    await _togglePinLocal(id);
    print('✅ Note pin toggled in local DB');

    // Sync to Firestore (works without backend API)
    if (_useFirestore) {
      _syncPinToFirestore(id);
    }

    // Sync to backend API in background (optional)
    if (_useBackend) {
      _togglePinBackendApi(id);
    }
  }

  Future<void> _syncPinToFirestore(String id) async {
    try {
      final note = await getNoteById(id);
      if (note == null) return;
      await _upsertNoteFirestore(note);
      print('✅ Note pin synced to Firestore');
    } catch (e) {
      print('⚠️ Firestore sync failed: $e');
    }
  }

  Future<void> _togglePinBackendApi(String id) async {
    try {
      final updated = await _api!.toggleNotePin(id);
      await _saveNoteLocal(updated);
      print('✅ Background: pin toggle synced');
    } catch (e) {
      print('⚠️ Background pin toggle failed: $e');
    }
  }

  /// LOCAL-FIRST: Update color locally immediately, sync in background
  Future<void> updateNoteColor(String id, int? colorValue) async {
    print('📝 NoteRepository.updateNoteColor() - LOCAL FIRST');

    await _updateColorLocal(id, colorValue);
    print('✅ Note color updated in local DB');

    // Sync to Firestore (works without backend API)
    if (_useFirestore) {
      _syncColorToFirestore(id);
    }

    // Sync to backend API in background (optional)
    if (_useBackend) {
      _updateColorBackendApi(id, colorValue);
    }
  }

  Future<void> _syncColorToFirestore(String id) async {
    try {
      final existing = await getNoteById(id);
      if (existing == null) return;
      await _upsertNoteFirestore(existing);
      print('✅ Note color synced to Firestore');
    } catch (e) {
      print('⚠️ Firestore sync failed: $e');
    }
  }

  Future<void> _updateColorBackendApi(String id, int? colorValue) async {
    try {
      final existing = await getNoteById(id);
      if (existing == null) return;
      final updated = await _api!.saveNote(
        existing.copyWith(color: colorValue != null ? Color(colorValue) : null),
      );
      await _saveNoteLocal(updated);
      print('✅ Background: color update synced');
    } catch (e) {
      print('⚠️ Background color update failed: $e');
    }
  }

  /// LOCAL-FIRST: Lock locally immediately, sync in background
  Future<void> lockNote(String id, String? pin, bool useBiometric) async {
    print('📝 NoteRepository.lockNote() - LOCAL FIRST');

    await _lockNoteLocal(id, pin, useBiometric);
    print('✅ Note locked in local DB');

    // Sync to Firestore (works without backend API)
    if (_useFirestore) {
      _syncLockToFirestore(id);
    }

    // Sync to backend API in background (optional)
    if (_useBackend) {
      _lockNoteBackendApi(id, pin, useBiometric);
    }
  }

  Future<void> _syncLockToFirestore(String id) async {
    try {
      final note = await getNoteById(id);
      if (note == null) return;
      await _upsertNoteFirestore(note);
      print('✅ Note lock synced to Firestore');
    } catch (e) {
      print('⚠️ Firestore sync failed: $e');
    }
  }

  Future<void> _lockNoteBackendApi(
      String id, String? pin, bool useBiometric) async {
    try {
      final updated =
          await _api!.lockNote(id, lockPin: pin, useBiometric: useBiometric);
      await _saveNoteLocal(updated);
      print('✅ Background: note lock synced');
    } catch (e) {
      print('⚠️ Background lock sync failed: $e');
    }
  }

  /// LOCAL-FIRST: Unlock locally immediately, sync in background
  Future<void> unlockNote(String id) async {
    print('📝 NoteRepository.unlockNote() - LOCAL FIRST');

    await _unlockNoteLocal(id);
    print('✅ Note unlocked in local DB');

    // Sync to Firestore (works without backend API)
    if (_useFirestore) {
      _syncUnlockToFirestore(id);
    }

    // Sync to backend API in background (optional)
    if (_useBackend) {
      _unlockNoteBackendApi(id);
    }
  }

  Future<void> _syncUnlockToFirestore(String id) async {
    try {
      final note = await getNoteById(id);
      if (note == null) return;
      await _upsertNoteFirestore(note);
      print('✅ Note unlock synced to Firestore');
    } catch (e) {
      print('⚠️ Firestore sync failed: $e');
    }
  }

  Future<void> _unlockNoteBackendApi(String id) async {
    try {
      final updated = await _api!.unlockNote(id);
      await _saveNoteLocal(updated);
      print('✅ Background: note unlock synced');
    } catch (e) {
      print('⚠️ Background unlock sync failed: $e');
    }
  }

  Future<List<Note>> searchNotes(String query) async {
    if (_useBackend) {
      try {
        final notes = await _api!.fetchNotes();
        final lowerQuery = query.toLowerCase();
        return notes.where((note) {
          return note.title.toLowerCase().contains(lowerQuery) ||
              note.content.toLowerCase().contains(lowerQuery) ||
              (note.tags?.any((t) => t.toLowerCase().contains(lowerQuery)) ??
                  false);
        }).toList();
      } catch (e) {
        // fall through to local search
      }
    }

    await _ensureDb();
    final result = _localDb.rawDb.select(
      '''SELECT * FROM notes 
          WHERE title LIKE ? OR content LIKE ? OR tagsJson LIKE ?
          ORDER BY isPinned DESC, updatedAt DESC, createdAt DESC''',
      ['%$query%', '%$query%', '%$query%'],
    );
    return result.map((row) => Note.fromDatabase(row)).toList();
  }

  Future<List<Note>> getLockedNotes() async {
    if (_useBackend) {
      try {
        final notes = await _api!.fetchNotes();
        await _syncNotesFirestore(notes);
        return notes.where((n) => n.isLocked).toList();
      } catch (e) {
        return _fetchNotesLocal(
          whereClause: 'WHERE isLocked = 1',
        );
      }
    }

    return _fetchNotesLocal(
      whereClause: 'WHERE isLocked = 1',
    );
  }

  Future<List<Note>> getChecklistNotes() async {
    if (_useBackend) {
      try {
        final notes = await _api!.fetchNotes();
        await _syncNotesFirestore(notes);
        return notes.where((n) => n.type == NoteType.checklist).toList();
      } catch (e) {
        // fall through
      }
    }

    return _fetchNotesLocal(
      whereClause: 'WHERE type = ?',
      args: [NoteType.checklist.index],
    );
  }

  /// Sync all local notes to Firestore (for first-time sync when user logs in)
  /// This checks if data exists in Firestore before adding to avoid duplicates
  Future<void> syncLocalDataToFirestore() async {
    if (!_useFirestore) {
      print('⚠️ Cannot sync: user not logged in');
      return;
    }

    print('🔄 NoteRepository: Syncing local data to Firestore...');

    try {
      final localNotes = await _fetchNotesLocal();
      if (localNotes.isEmpty) {
        print('📝 No local notes to sync');
        return;
      }

      final col = _firestoreService.notes;
      if (col == null) return;

      // Get existing Firestore note IDs to avoid duplicates
      final existingDocs = await col.get();
      final existingIds = existingDocs.docs.map((doc) => doc.id).toSet();

      int syncedCount = 0;
      for (final note in localNotes) {
        if (!existingIds.contains(note.id)) {
          await _upsertNoteFirestore(note);
          syncedCount++;
        }
      }

      print(
          '✅ Synced $syncedCount new notes to Firestore (${localNotes.length - syncedCount} already existed)');
    } catch (e) {
      print('⚠️ Error syncing local notes to Firestore: $e');
    }
  }
}
