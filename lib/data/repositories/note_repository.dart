import '../../models/note_model.dart';
import '../local/app_database.dart';

class NoteRepository {
  final AppDatabase _db;

  NoteRepository(this._db);

  Future<void> _ensureDb() async => _db.init();

  Future<List<Note>> fetchNotes() async {
    await _ensureDb();
    final result = _db.rawDb.select('SELECT * FROM notes ORDER BY isPinned DESC, updatedAt DESC, createdAt DESC');
    return result.map((row) => Note.fromDatabase(row)).toList();
  }

  Future<Note?> getNoteById(String id) async {
    await _ensureDb();
    final result = _db.rawDb.select('SELECT * FROM notes WHERE id = ?', [id]);
    if (result.isEmpty) return null;
    return Note.fromDatabase(result.first);
  }

  Future<List<Note>> getNotesByCategory(NoteCategory category) async {
    await _ensureDb();
    final result = _db.rawDb.select(
      'SELECT * FROM notes WHERE category = ? ORDER BY isPinned DESC, updatedAt DESC',
      [category.index],
    );
    return result.map((row) => Note.fromDatabase(row)).toList();
  }

  Future<List<Note>> getNotesByTag(String tag) async {
    await _ensureDb();
    final result = _db.rawDb.select(
      'SELECT * FROM notes WHERE tagsJson LIKE ? ORDER BY isPinned DESC, updatedAt DESC',
      ['%$tag%'],
    );
    return result.map((row) => Note.fromDatabase(row)).toList();
  }

  Future<void> upsertNote(Note note) async {
    await _ensureDb();
    final data = note.toDatabase();
    _db.rawDb.execute(
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

  Future<void> deleteNote(String id) async {
    await _ensureDb();
    _db.rawDb.execute('DELETE FROM notes WHERE id = ?', [id]);
  }

  Future<void> togglePin(String id) async {
    await _ensureDb();
    _db.rawDb.execute(
      'UPDATE notes SET isPinned = CASE WHEN isPinned = 1 THEN 0 ELSE 1 END, updatedAt = ? WHERE id = ?',
      [DateTime.now().millisecondsSinceEpoch, id],
    );
  }

  Future<void> updateNoteColor(String id, int? colorValue) async {
    await _ensureDb();
    _db.rawDb.execute(
      'UPDATE notes SET colorValue = ?, updatedAt = ? WHERE id = ?',
      [colorValue, DateTime.now().millisecondsSinceEpoch, id],
    );
  }

  Future<void> lockNote(String id, String? pin, bool useBiometric) async {
    await _ensureDb();
    _db.rawDb.execute(
      'UPDATE notes SET isLocked = 1, lockPin = ?, useBiometric = ?, updatedAt = ? WHERE id = ?',
      [pin, useBiometric ? 1 : 0, DateTime.now().millisecondsSinceEpoch, id],
    );
  }

  Future<void> unlockNote(String id) async {
    await _ensureDb();
    _db.rawDb.execute(
      'UPDATE notes SET isLocked = 0, lockPin = NULL, useBiometric = 0, updatedAt = ? WHERE id = ?',
      [DateTime.now().millisecondsSinceEpoch, id],
    );
  }

  Future<List<Note>> searchNotes(String query) async {
    await _ensureDb();
    final result = _db.rawDb.select(
      '''SELECT * FROM notes 
        WHERE title LIKE ? OR content LIKE ? OR tagsJson LIKE ?
        ORDER BY isPinned DESC, updatedAt DESC, createdAt DESC''',
      ['%$query%', '%$query%', '%$query%'],
    );
    return result.map((row) => Note.fromDatabase(row)).toList();
  }

  Future<List<Note>> getLockedNotes() async {
    await _ensureDb();
    final result = _db.rawDb.select(
      'SELECT * FROM notes WHERE isLocked = 1 ORDER BY updatedAt DESC',
    );
    return result.map((row) => Note.fromDatabase(row)).toList();
  }

  Future<List<Note>> getChecklistNotes() async {
    await _ensureDb();
    final result = _db.rawDb.select(
      'SELECT * FROM notes WHERE type = ? ORDER BY isPinned DESC, updatedAt DESC',
      [NoteType.checklist.index],
    );
    return result.map((row) => Note.fromDatabase(row)).toList();
  }
}

