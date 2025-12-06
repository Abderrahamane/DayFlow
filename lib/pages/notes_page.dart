// lib/pages/notes_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'; // <<< 1. IMPORT THE NEW PACKAGE
import '../models/note_model.dart';
import '../providers/note_provider.dart';
import '../widgets/note_item.dart';
import 'note_editor_page.dart';
import '../theme/app_theme.dart'; // Import your theme

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // <<< --- 2. THE FLOATING ACTION BUTTON IS STYLED LIKE THE DESIGN --- >>>
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToEditor(context),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // <<< --- 3. THE NEW CUSTOM HEADER --- >>>
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Notes', style: theme.textTheme.headlineLarge),
                  IconButton(
                    icon: Icon(Icons.search, color: theme.iconTheme.color),
                    onPressed: () { /* TODO: Implement search functionality */ },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // <<< --- END OF THE NEW HEADER --- >>>
              
              // <<< --- 4. THE BODY WITH THE STAGGERED GRID --- >>>
              Expanded(
                child: Consumer<NoteProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (provider.notes.isEmpty) {
                      return const Center(child: Text('No notes yet. Add one!'));
                    }

                    // This is the new grid layout widget
                    return MasonryGridView.count(
                      crossAxisCount: 2, // Two columns
                      mainAxisSpacing: 12, // Vertical space between cards
                      crossAxisSpacing: 12, // Horizontal space between cards
                      itemCount: provider.notes.length,
                      itemBuilder: (context, index) {
                        final note = provider.notes[index];
                        // We pass the note to our redesigned NoteItem
                        return GestureDetector(
                          onTap: () => _navigateToEditor(context, note: note),
                          child: NoteItem(note: note),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToEditor(BuildContext context, {Note? note}) async {
    final provider = Provider.of<NoteProvider>(context, listen: false);
    final returnedNote = await Navigator.push<Note>(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorPage(note: note),
      ),
    );

    if (returnedNote != null) {
      if (note != null) {
        await provider.updateNote(returnedNote);
      } else {
        await provider.addNote(returnedNote);
      }
    }
  }
}