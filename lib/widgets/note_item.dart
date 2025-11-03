// Note display widget

import 'package:flutter/material.dart';
import '/models/note_model.dart';

class NoteItem extends StatelessWidget {

  final Note note;

  const NoteItem({
    super.key,
    required this.note
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteColor = note.color ?? theme.colorScheme.primary.withOpacity(0.1);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: note.color ?? theme.colorScheme.primary,
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: note.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with title and actions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pin indicator
                    if (note.isPinned) ...[
                      Icon(
                        Icons.push_pin,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                    ],

                    // Title
                    Expanded(
                      child: Text(
                        note.title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Menu button
                    if (note.onEdit != null || note.onDelete != null || note.onPin != null)
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: theme.textTheme.bodyMedium?.color
                              ?.withOpacity(0.5),
                          size: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onSelected: (value) {
                          if (value == 'pin' && note.onPin != null) {
                            note.onPin!();
                          } else if (value == 'edit' && note.onEdit != null) {
                            note.onEdit!();
                          } else if (value == 'delete' && note.onDelete != null) {
                            note.onDelete!();
                          }
                        },
                        itemBuilder: (context) => [
                          if (note.onPin != null)
                            PopupMenuItem(
                              value: 'pin',
                              child: Row(
                                children: [
                                  Icon(
                                    note.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(note.isPinned ? 'Unpin' : 'Pin'),
                                ],
                              ),
                            ),
                          if (note.onEdit != null)
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 20),
                                  SizedBox(width: 12),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                          if (note.onDelete != null)
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, size: 20, color: Colors.red),
                                  SizedBox(width: 12),
                                  Text('Delete', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                        ],
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                // Content preview
                Text(
                  note.content,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Footer with tags and date
                Row(
                  children: [
                    // Tags
                    if (note.tags != null && note.tags!.isNotEmpty)
                      Expanded(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: note.tags!.take(3).map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: noteColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '#$tag',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: note.color ?? theme.colorScheme.primary,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                    // Date
                    if (note.updatedAt != null || note.createdAt != null)
                      Text(
                        _formatDate(note.updatedAt ?? note.createdAt!),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodyMedium?.color
                              ?.withOpacity(0.5),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Compact Note Item for grid view
class NoteItemCompact extends StatelessWidget {
  final Note note ;


  NoteItemCompact({
    super.key, required this.note,

  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteColor = note.color ?? theme.colorScheme.primary.withOpacity(0.1);

    return Container(
      decoration: BoxDecoration(
        color: noteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: note.color ?? theme.colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: note.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    note.content,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodyMedium?.color
                          ?.withOpacity(0.7),
                    ),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}