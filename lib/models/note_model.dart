// lib/models/note_model.dart

import 'package:flutter/material.dart';

class Note {
  final int? id;
  final String title;
  final String content;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime? updatedAt; // Add updatedAt back

  // <<< --- ADD THESE TWO LINES BACK --- >>>
  final Color? color;
  final List<String>? tags;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.isPinned,
    required this.createdAt,
    this.updatedAt,
    this.color, // Add to constructor
    this.tags,   // Add to constructor
  });

  Note copyWith({
    int? id,
    String? title,
    String? content,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
    Color? color,
    List<String>? tags,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      color: color ?? this.color,
      tags: tags ?? this.tags,
    );
  }

  // Convert a Note object into a Map for the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isPinned': isPinned ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'color': color?.value, // Store color as an integer
      'tags': tags?.join(','), // Store tags as a single comma-separated string
    };
  }

  // Extract a Note object from a Map.
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      isPinned: map['isPinned'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      color: map['color'] != null ? Color(map['color']) : null,
      tags: map['tags'] != null ? (map['tags'] as String).split(',') : null,
    );
  }
}