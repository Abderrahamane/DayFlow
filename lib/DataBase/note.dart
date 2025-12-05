import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/note_model.dart';
import 'dart:io';



class DataBaseHelper {
  // this is a private contructor , the onle call is insid eteh class itself 
  DataBaseHelper._privateConstructaor() ; 
  // the only way to access this priavte constructor is via this instance 
  static final DataBaseHelper instance = DataBaseHelper._privateConstructaor() ; 

  static Database? _dataBase ; 
  Future <Database> get database async => _dataBase ??= await _initDatabase() ; 

  Future <Database> _initDatabase() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory() ; 
    String path = join(documentDirectory.path , 'notes.db') ; 
    return await openDatabase(
      path , 
      version: 1 , 
      onCreate: _onCreate 
    ) ;
  }

  Future _onCreate(Database db , int version) async {
    await db.execute('''
      CREATE TABLE notes (
      id INTEGER PRIMARY KEY
      )
      '''
    ) ; 
  }

  Future<List<Note>> getNotes() async {
    Database db = await instance.database;

    var notesData = await db.query(
      'notes',
      orderBy: 'id DESC', // optional
    );

    List<Note> notesList = notesData.isNotEmpty ? 
      notesData.map( (c)=> Note.fromMap(c) ).toList() : [] ; 

    return notesList;
}

  // CRUD OPERATIONS 
  // CREATE 
  Future<int> add(Note note) async {
    Database db = await instance.database ;
    return await db.insert('notes' , note.toMap()) ; 
  }

  // REMOVE 
  Future<int> remove (Note note) async {
    Database db = await instance.database ; 
    return await db.delete('notes' , where : ' id = ?' , whereArgs: [note.id]) ; 
  }
  // HEDI IW ILL CALL IT LATER WHEN I FIX THE DELETE 

  
}