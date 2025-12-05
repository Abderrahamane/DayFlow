import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/note_model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'notes.db');
    return await openDatabase(
      path,
      version: 1, // If you change the schema, you must increment the version.
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // <<< --- UPDATE THE TABLE SCHEMA --- >>>
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
  }

  // The rest of the functions work automatically because they use the
  // updated toMap() and fromMap() methods from the Note model.
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
}