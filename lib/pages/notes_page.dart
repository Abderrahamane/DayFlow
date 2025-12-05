// lib/pages/notes_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../providers/note_provider.dart';
import '../widgets/note_item.dart'; // Your custom NoteItem
import 'note_editor_page.dart'; // Your editor page

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          // Add a refresh button for debugging
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // This lets you manually tell the provider to load from the DB again
              Provider.of<NoteProvider>(context, listen: false).loadNotes();
            },
          )
        ],
      ),

      // <<< --- THIS IS THE PART RESPONSIBLE FOR SHOWING THE NOTES --- >>>
      body: Consumer<NoteProvider>(
        builder: (context, provider, child) {
          // 1. First, check if it's loading.
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. If it's NOT loading and the list is empty, show the message.
          if (provider.notes.isEmpty) {
            return const Center(
              child: Text('No notes yet. Add one!'),
            );
          }

          // 3. If it's NOT loading and has notes, build the list.
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: provider.notes.length,
            itemBuilder: (context, index) {
              final note = provider.notes[index];
              return NoteItem(
                // Use your custom NoteItem widget here
                note: note,
                // onTap: () {
                //   _navigateToEditor(context, note: note);
                // },
              );
            },
          );
        },
      ),
      // --- END OF THE DISPLAY PART ---

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _navigateToEditor(context); // Go to editor to create a new note
        },
      ),
    );
  }

  void _navigateToEditor(BuildContext context, {Note? note}) async {
    final returnedNote = await Navigator.push<Note>(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorPage(note: note),
      ),
    );

    if (returnedNote != null) {
      // Use listen: false because we are in a function, not the build method.
      final provider = Provider.of<NoteProvider>(context, listen: false);
      if (note != null) {
        // We were editing an existing note
        await provider.updateNote(returnedNote);
      } else {
        // We were adding a new note
        await provider.addNote(returnedNote);
      }
    }
  }
}