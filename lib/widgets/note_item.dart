// lib/widgets/note_item.dart

import 'package:flutter/material.dart';
import '../models/note_model.dart';
import 'dart:math'; // To generate random heights for the staggered effect

class NoteItem extends StatelessWidget {
  final Note note;
  const NoteItem({super.key, required this.note});

  // <<< --- 1. A LIST OF BEAUTIFUL PASTEL COLORS FOR LIGHT MODE --- >>>
  static const List<Color> _lightColors = [
    Color(0xFFFADADD), // Light Pink
    Color(0xFFFFF4A3), // Light Yellow
    Color(0xFFD4E4F9), // Light Blue
    Color(0xFFD9F3E5), // Light Green
    Color(0xFFF1E1FF), // Light Purple
  ];
  
  // Helper to format the date like in the design
  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // <<< --- 2. PICK A COLOR BASED ON THE NOTE'S ID --- >>>
    // This ensures the color is always the same for the same note.
    final cardColor = _lightColors[note.id.hashCode % _lightColors.length];
    
    // Create a random height for the card to get the masonry effect
    final minHeight = 150.0;
    final maxHeight = 250.0;
    final randomHeight = minHeight + (note.content.length % (maxHeight - minHeight));

    return Card(
      // <<< --- 3. THE NEW CARD DESIGN --- >>>
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0, // The design is flat
      child: Container(
        constraints: BoxConstraints(minHeight: randomHeight), // Set the height
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes date to the bottom
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- The Title ---
            Text(
              note.title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Dark text for light cards
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24), // Space between title and date
            // --- The Date (aligned to the bottom right) ---
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                _formatDate(note.updatedAt ?? note.createdAt!),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.black.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}