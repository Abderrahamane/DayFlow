// lib/helpers/database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/note_model.dart';
import '../models/task_model.dart';
import 'dart:convert';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // --- Table for Notes ---
    await db.execute('''
      CREATE TABLE notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          content TEXT NOT NULL,
          isPinned INTEGER NOT NULL,
          createdAt TEXT NOT NULL,
          updatedAt TEXT,
          color INTEGER,
          tags TEXT
      )
      ''');

    // --- Table for Tasks ---
    await db.execute('''
      CREATE TABLE tasks(
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          description TEXT,
          isCompleted INTEGER NOT NULL,
          createdAt TEXT NOT NULL,
          dueDate TEXT,
          priority TEXT NOT NULL,
          tags TEXT,
          subtasks TEXT
      )
      ''');
  }

  // =======================================================
  //                NOTE FUNCTIONS
  // =======================================================
  Future<int> addNote(Note note) async {
    Database db = await instance.database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<Note>> getNotes() async {
    Database db = await instance.database;
    var notes = await db.query('notes', orderBy: 'createdAt DESC');
    return notes.map((c) => Note.fromMap(c)).toList();
  }

  Future<int> updateNote(Note note) async {
    Database db = await instance.database;
    return await db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    Database db = await instance.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  // =======================================================
  //                TASK FUNCTIONS
  // =======================================================

  Map<String, dynamic> _taskToMap(Task task) {
    return {
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'isCompleted': task.isCompleted ? 1 : 0,
      'createdAt': task.createdAt.toIso8601String(),
      'dueDate': task.dueDate?.toIso8601String(),
      'priority': task.priority.name,
      'tags': task.tags?.join(','),
      'subtasks': task.subtasks != null
          ? jsonEncode(task.subtasks!.map((s) => s.toJson()).toList())
          : null,
    };
  }

  Task _taskFromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      priority: TaskPriority.values.firstWhere((p) => p.name == map['priority'], orElse: () => TaskPriority.none),
      tags: map['tags'] != null ? (map['tags'] as String).split(',') : null,
      subtasks: map['subtasks'] != null
          ? (jsonDecode(map['subtasks']) as List).map((s) => Subtask.fromJson(s)).toList()
          : null,
    );
  }

  Future<void> addTask(Task task) async {
    Database db = await instance.database;
    await db.insert('tasks', _taskToMap(task),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getTasks() async {
    Database db = await instance.database;
    var taskMaps = await db.query('tasks', orderBy: 'createdAt DESC');
    return taskMaps.map((map) => _taskFromMap(map)).toList();
  }

  Future<void> updateTask(Task task) async {
    Database db = await instance.database;
    await db.update('tasks', _taskToMap(task), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> deleteTask(String id) async {
    Database db = await instance.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}