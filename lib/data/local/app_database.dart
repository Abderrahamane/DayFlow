
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

class AppDatabase {
  static const int _dbVersion = 2; // Increment this when schema changes
  late final Database _db;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dir.path, 'dayflow.db');
    _db = sqlite3.open(dbPath);
    _createTables();
    _runMigrations();
    _initialized = true;
  }

  Database get rawDb => _db;

  void _runMigrations() {
    // Check for missing columns and add them if needed
    _migrateNotesTable();
    _migrateTasksTable();
  }

  void _migrateNotesTable() {
    // Check if 'type' column exists in notes table
    try {
      final result = _db.select("PRAGMA table_info(notes)");
      final columnNames = result.map((row) => row['name'] as String).toList();

      // Add missing columns for notes table
      if (!columnNames.contains('type')) {
        _db.execute('ALTER TABLE notes ADD COLUMN type INTEGER NOT NULL DEFAULT 0');
      }
      if (!columnNames.contains('attachmentsJson')) {
        _db.execute('ALTER TABLE notes ADD COLUMN attachmentsJson TEXT');
      }
      if (!columnNames.contains('checklistJson')) {
        _db.execute('ALTER TABLE notes ADD COLUMN checklistJson TEXT');
      }
      if (!columnNames.contains('isLocked')) {
        _db.execute('ALTER TABLE notes ADD COLUMN isLocked INTEGER NOT NULL DEFAULT 0');
      }
      if (!columnNames.contains('lockPin')) {
        _db.execute('ALTER TABLE notes ADD COLUMN lockPin TEXT');
      }
      if (!columnNames.contains('useBiometric')) {
        _db.execute('ALTER TABLE notes ADD COLUMN useBiometric INTEGER NOT NULL DEFAULT 0');
      }
      if (!columnNames.contains('category')) {
        _db.execute('ALTER TABLE notes ADD COLUMN category INTEGER');
      }
    } catch (e) {
      // Table might not exist yet, which is fine
      print('Notes migration error (may be normal): $e');
    }
  }

  void _migrateTasksTable() {
    // Check if recurrence columns exist in tasks table
    try {
      final result = _db.select("PRAGMA table_info(tasks)");
      final columnNames = result.map((row) => row['name'] as String).toList();

      if (!columnNames.contains('recurrenceData')) {
        _db.execute('ALTER TABLE tasks ADD COLUMN recurrenceData TEXT');
      }
      if (!columnNames.contains('parentTaskId')) {
        _db.execute('ALTER TABLE tasks ADD COLUMN parentTaskId TEXT');
      }
    } catch (e) {
      print('Tasks migration error (may be normal): $e');
    }
  }

  void _createTables() {
    _db.execute('''
      CREATE TABLE IF NOT EXISTS tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        createdAt INTEGER NOT NULL,
        dueDate INTEGER,
        priority INTEGER NOT NULL DEFAULT 2,
        tagsJson TEXT,
        recurrenceData TEXT,
        parentTaskId TEXT
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS subtasks (
        id TEXT PRIMARY KEY,
        taskId TEXT NOT NULL,
        title TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY(taskId) REFERENCES tasks(id) ON DELETE CASCADE
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS habits (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        icon TEXT NOT NULL,
        frequency INTEGER NOT NULL DEFAULT 0,
        goalCount INTEGER NOT NULL DEFAULT 7,
        linkedTagsJson TEXT,
        createdAt INTEGER NOT NULL,
        colorValue INTEGER NOT NULL DEFAULT 0xff6366f1
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS habit_completions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        habitId TEXT NOT NULL,
        dateKey TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        UNIQUE(habitId, dateKey),
        FOREIGN KEY(habitId) REFERENCES habits(id) ON DELETE CASCADE
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        time TEXT NOT NULL,
        description TEXT,
        date TEXT NOT NULL,
        isActive INTEGER NOT NULL DEFAULT 1,
        createdAt INTEGER NOT NULL,
        source TEXT NOT NULL DEFAULT 'reminder'
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS notes (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER,
        colorValue INTEGER,
        tagsJson TEXT,
        isPinned INTEGER NOT NULL DEFAULT 0,
        type INTEGER NOT NULL DEFAULT 0,
        attachmentsJson TEXT,
        checklistJson TEXT,
        isLocked INTEGER NOT NULL DEFAULT 0,
        lockPin TEXT,
        useBiometric INTEGER NOT NULL DEFAULT 0,
        category INTEGER
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS task_attachments (
        id TEXT PRIMARY KEY,
        taskId TEXT NOT NULL,
        name TEXT NOT NULL,
        url TEXT NOT NULL,
        type TEXT NOT NULL,
        createdAt INTEGER NOT NULL,
        FOREIGN KEY(taskId) REFERENCES tasks(id) ON DELETE CASCADE
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS task_templates (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        taskTitle TEXT NOT NULL,
        taskDescription TEXT,
        priority INTEGER NOT NULL DEFAULT 2,
        tagsJson TEXT,
        subtasksJson TEXT,
        category TEXT,
        icon TEXT,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER,
        usageCount INTEGER NOT NULL DEFAULT 0,
        isShared INTEGER NOT NULL DEFAULT 0
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS pomodoro_sessions (
        id TEXT PRIMARY KEY,
        type INTEGER NOT NULL,
        startTime INTEGER NOT NULL,
        endTime INTEGER,
        durationMinutes INTEGER NOT NULL,
        completed INTEGER NOT NULL DEFAULT 0,
        linkedTaskId TEXT,
        linkedTaskTitle TEXT
      );
    ''');
  }

  void close() {
    if (_initialized) {
      _db.dispose();
      _initialized = false;
    }
  }
}
