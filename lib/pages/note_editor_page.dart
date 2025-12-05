// TODO Implement this library.// lib/pages/note_editor_page.dart

import 'package:flutter/material.dart';
import '../models/note_model.dart';

class NoteEditorPage extends StatefulWidget {
  final Note? note; // If a note is passed, we are editing. If null, we are adding.

  const NoteEditorPage({super.key, this.note});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isPinned = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      // If we are editing an existing note, fill in the fields.
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _isPinned = widget.note!.isPinned;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isEmpty && content.isEmpty) {
      // Don't save empty notes. Just go back.
      Navigator.pop(context);
      return;
    }
    
    // Create the final Note object to send back to the main page.
    final noteToSave = Note(
      id: widget.note?.id, // Keep the original ID if we are editing
      title: title,
      content: content,
      isPinned: _isPinned,
      createdAt: widget.note?.createdAt ?? DateTime.now(), // Keep original creation date
    );

    Navigator.pop(context, noteToSave);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          IconButton(
            tooltip: 'Pin Note',
            icon: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined),
            onPressed: () {
              setState(() {
                _isPinned = !_isPinned;
              });
            },
          ),
          IconButton(
            tooltip: 'Save Note',
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Start writing...',
                  border: InputBorder.none,
                ),
                maxLines: null, // Allows for multiline input
              ),
            ),
          ],
        ),
      ),
    );
  }
}