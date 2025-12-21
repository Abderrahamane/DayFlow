import 'package:dayflow/services/firestore_service.dart';
import '../../models/note_model.dart';
import '../local/app_database.dart';

class NoteRepository {
  final AppDatabase _localDb;
  final FirestoreService _firestoreService;

  NoteRepository(this._localDb, this._firestoreService);

  bool get _isRemote => _firestoreService.currentUserId != null;

  Future<void> _ensureDb() async => _localDb.init();

  Future<List<Note>> fetchNotes() async {
    if (_isRemote) {
      final collection = _firestoreService.notes;
      if (collection == null) return [];

      final snapshot = await collection.get();
      return snapshot.docs.map((doc) {
        return Note.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } else {
      await _ensureDb();
      final result = _localDb.rawDb.select('SELECT * FROM notes ORDER BY isPinned DESC, updatedAt DESC, createdAt DESC');
      return result.map((row) => Note.fromDatabase(row)).toList();
    }
  }

  Future<Note?> getNoteById(String id) async {
    if (_isRemote) {
      final collection = _firestoreService.notes;
      if (collection == null) return null;

      final doc = await collection.doc(id).get();
      if (!doc.exists) return null;
      return Note.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    } else {
      await _ensureDb();
      final result = _localDb.rawDb.select('SELECT * FROM notes WHERE id = ?', [id]);
      if (result.isEmpty) return null;
      return Note.fromDatabase(result.first);
    }
  }

  Future<List<Note>> getNotesByCategory(NoteCategory category) async {
    if (_isRemote) {
      final collection = _firestoreService.notes;
      if (collection == null) return [];

      final snapshot = await collection.where('category', isEqualTo: category.name).get();
      return snapshot.docs.map((doc) {
        return Note.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } else {
      await _ensureDb();
      final result = _localDb.rawDb.select(
        'SELECT * FROM notes WHERE category = ? ORDER BY isPinned DESC, updatedAt DESC',
        [category.index],
      );
      return result.map((row) => Note.fromDatabase(row)).toList();
    }
  }

  Future<List<Note>> getNotesByTag(String tag) async {
    if (_isRemote) {
      final collection = _firestoreService.notes;
      if (collection == null) return [];

      final snapshot = await collection.where('tags', arrayContains: tag).get();
      return snapshot.docs.map((doc) {
        return Note.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } else {
      await _ensureDb();
      final result = _localDb.rawDb.select(
        'SELECT * FROM notes WHERE tagsJson LIKE ? ORDER BY isPinned DESC, updatedAt DESC',
        ['%$tag%'],
      );
      return result.map((row) => Note.fromDatabase(row)).toList();
    }
  }

  Future<void> upsertNote(Note note) async {
    if (_isRemote) {
      final collection = _firestoreService.notes;
      if (collection == null) return;

      await collection.doc(note.id).set(note.toFirestore());
    } else {
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
  }

  Future<void> deleteNote(String id) async {
    if (_isRemote) {
      final collection = _firestoreService.notes;
      if (collection == null) return;

      await collection.doc(id).delete();
    } else {
      await _ensureDb();
      _localDb.rawDb.execute('DELETE FROM notes WHERE id = ?', [id]);
    }
  }

  Future<void> togglePin(String id) async {
    if (_isRemote) {
      final collection = _firestoreService.notes;
      if (collection == null) return;

      final docRef = collection.doc(id);
      final doc = await docRef.get();
      if (!doc.exists) return;

      final data = doc.data() as Map<String, dynamic>?;
      final current = data?['isPinned'] as bool? ?? false;
      await docRef.update({
        'isPinned': !current,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } else {
      await _ensureDb();
      _localDb.rawDb.execute(
        'UPDATE notes SET isPinned = CASE WHEN isPinned = 1 THEN 0 ELSE 1 END, updatedAt = ? WHERE id = ?',
        [DateTime.now().millisecondsSinceEpoch, id],
      );
    }
  }

  Future<void> updateNoteColor(String id, int? colorValue) async {
    if (_isRemote) {
      final collection = _firestoreService.notes;
      if (collection == null) return;

      await collection.doc(id).update({
        'colorValue': colorValue,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } else {
      await _ensureDb();
      _localDb.rawDb.execute(
        'UPDATE notes SET colorValue = ?, updatedAt = ? WHERE id = ?',
        [colorValue, DateTime.now().millisecondsSinceEpoch, id],
      );
    }
  }

  Future<void> lockNote(String id, String? pin, bool useBiometric) async {
    if (_isRemote) {
      final collection = _firestoreService.notes;
      if (collection == null) return;

      await collection.doc(id).update({
        'isLocked': true,
        'lockPin': pin,
        'useBiometric': useBiometric,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } else {
      await _ensureDb();
      _localDb.rawDb.execute(
        'UPDATE notes SET isLocked = 1, lockPin = ?, useBiometric = ?, updatedAt = ? WHERE id = ?',
        [pin, useBiometric ? 1 : 0, DateTime.now().millisecondsSinceEpoch, id],
      );
    }
  }

  Future<void> unlockNote(String id) async {
    if (_isRemote) {
      final collection = _firestoreService.notes;
      if (collection == null) return;

      await collection.doc(id).update({
        'isLocked': false,
        'lockPin': null,
        'useBiometric': false,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } else {
      await _ensureDb();
      _localDb.rawDb.execute(
        'UPDATE notes SET isLocked = 0, lockPin = NULL, useBiometric = 0, updatedAt = ? WHERE id = ?',
        [DateTime.now().millisecondsSinceEpoch, id],
      );
    }
  }

  Future<List<Note>> searchNotes(String query) async {
    if (_isRemote) {
      // Firestore doesn't support full text search natively.
      // We can do a basic prefix search on title or fetch all and filter (not efficient but okay for small datasets)
      // For now, let's fetch all and filter in memory as a simple solution
      final notes = await fetchNotes();
      final lowerQuery = query.toLowerCase();
      return notes.where((note) {
        return note.title.toLowerCase().contains(lowerQuery) ||
               note.content.toLowerCase().contains(lowerQuery) ||
               (note.tags?.any((t) => t.toLowerCase().contains(lowerQuery)) ?? false);
      }).toList();
    } else {
      await _ensureDb();
      final result = _localDb.rawDb.select(
        '''SELECT * FROM notes 
          WHERE title LIKE ? OR content LIKE ? OR tagsJson LIKE ?
          ORDER BY isPinned DESC, updatedAt DESC, createdAt DESC''',
        ['%$query%', '%$query%', '%$query%'],
      );
      return result.map((row) => Note.fromDatabase(row)).toList();
    }
  }

  Future<List<Note>> getLockedNotes() async {
    if (_isRemote) {
      final collection = _firestoreService.notes;
      if (collection == null) return [];

      final snapshot = await collection.where('isLocked', isEqualTo: true).get();
      return snapshot.docs.map((doc) {
        return Note.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } else {
      await _ensureDb();
      final result = _localDb.rawDb.select(
        'SELECT * FROM notes WHERE isLocked = 1 ORDER BY updatedAt DESC',
      );
      return result.map((row) => Note.fromDatabase(row)).toList();
    }
  }

  Future<List<Note>> getChecklistNotes() async {
    if (_isRemote) {
      final collection = _firestoreService.notes;
      if (collection == null) return [];

      final snapshot = await collection.where('type', isEqualTo: NoteType.checklist.name).get();
      return snapshot.docs.map((doc) {
        return Note.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } else {
      await _ensureDb();
      final result = _localDb.rawDb.select(
        'SELECT * FROM notes WHERE type = ? ORDER BY isPinned DESC, updatedAt DESC',
        [NoteType.checklist.index],
      );
      return result.map((row) => Note.fromDatabase(row)).toList();
    }
  }
}
