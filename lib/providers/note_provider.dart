// lib/providers/note_provider.dart

import 'package:flutter/foundation.dart';
import '../helpers/database_helper.dart'; // Make sure this path is correct
import '../models/note_model.dart';     // Make sure this path is correct

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];
  bool isLoading = false;

  List<Note> get notes => _notes;

  NoteProvider() {
    // Load notes when the provider is first created
    loadNotes();
  }

  // <<< --- THIS IS THE PART RESPONSIBLE FOR LOADING --- >>>
  Future<void> loadNotes() async {
    isLoading = true;
    notifyListeners(); // Tell UI to show the loading circle

    try {
      // Try to get the notes from the database
      _notes = await DatabaseHelper.instance.getNotes();
      _sortNotes();
      
      print("Successfully loaded ${_notes.length} notes from the database.");

    } catch (e) {
      // If ANYTHING goes wrong, catch the error and print it
      print("!!!!!!!!!! ERROR LOADING NOTES !!!!!!!!!!");
      print(e);
      _notes = []; // Set notes to an empty list to be safe
    } finally {
      // This part ALWAYS runs, even if there was an error
      isLoading = false;
      notifyListeners(); // Tell UI to HIDE the loading circle
    }
  }
  // --- END OF THE LOADING PART ---

  Future<void> addNote(Note note) async {
    final newId = await DatabaseHelper.instance.addNote(note);
    final noteWithId = note.copyWith(id: newId);
    _notes.add(noteWithId);
    _sortNotes();
    notifyListeners();
  }

  Future<void> updateNote(Note note) async {
    await DatabaseHelper.instance.updateNote(note);
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
    }
    _sortNotes();
    notifyListeners();
  }

  Future<void> deleteNote(int id) async {
    await DatabaseHelper.instance.deleteNote(id);
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
  }
  
  void _sortNotes() {
    _notes.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      // Use updatedAt if available, otherwise createdAt
      final aTime = a.updatedAt ?? a.createdAt;
      final bTime = b.updatedAt ?? b.createdAt;
      return bTime.compareTo(aTime);
    });
  }
}