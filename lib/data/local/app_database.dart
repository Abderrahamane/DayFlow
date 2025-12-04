import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

class AppDatabase {
  late final Database _db;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dir.path, 'dayflow.db');
    _db = sqlite3.open(dbPath);
    _createTables();
    _initialized = true;
  }

  Database get rawDb => _db;

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
        tagsJson TEXT
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
  }

  void close() {
    if (_initialized) {
      _db.dispose();
      _initialized = false;
    }
  }
}
