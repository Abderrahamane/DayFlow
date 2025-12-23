import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/task_model.dart';
import '../services/attachment_service.dart';
import '../theme/app_theme.dart';

class TaskAttachmentsWidget extends StatefulWidget {
  final List<TaskAttachment> attachments;
  final String taskId;
  final Function(List<TaskAttachment>) onAttachmentsChanged;
  final bool isEditable;

  const TaskAttachmentsWidget({
    super.key,
    required this.attachments,
    required this.taskId,
    required this.onAttachmentsChanged,
    this.isEditable = true,
  });

  @override
  State<TaskAttachmentsWidget> createState() => _TaskAttachmentsWidgetState();
}

class _TaskAttachmentsWidgetState extends State<TaskAttachmentsWidget> {
  bool _isUploading = false;
  String? _uploadProgress;

  Future<void> _showAttachmentOptions() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Attachment',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _AttachmentOption(
              icon: Icons.camera_alt,
              label: 'Take Photo',
              subtitle: 'Use camera to capture image',
              color: AppTheme.primaryLight,
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            _AttachmentOption(
              icon: Icons.photo_library,
              label: 'Choose from Gallery',
              subtitle: 'Select image from gallery',
              color: AppTheme.successColor,
              onTap: () => Navigator.pop(context, 'gallery'),
            ),
            _AttachmentOption(
              icon: Icons.attach_file,
              label: 'Attach Document',
              subtitle: 'PDF, DOC, XLS, etc.',
              color: const Color(0xFFF59E0B),
              onTap: () => Navigator.pop(context, 'document'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (result != null) {
      await _handleAttachmentSelection(result);
    }
  }

  Future<void> _handleAttachmentSelection(String type) async {
    File? file;

    switch (type) {
      case 'camera':
        file = await AttachmentService.pickImageFromCamera();
        break;
      case 'gallery':
        file = await AttachmentService.pickImageFromGallery();
        break;
      case 'document':
        file = await AttachmentService.pickDocument();
        break;
    }

    if (file != null) {
      await _uploadFile(file);
    }
  }

  Future<void> _uploadFile(File file) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showError('Please sign in to upload attachments');
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 'Uploading...';
    });

    try {
      final attachment = await AttachmentService.uploadAttachment(
        file: file,
        taskId: widget.taskId,
        userId: user.uid,
      );

      if (attachment != null) {
        final updatedAttachments = [...widget.attachments, attachment];
        widget.onAttachmentsChanged(updatedAttachments);
        _showSuccess('Attachment uploaded successfully');
      } else {
        _showError('Failed to upload attachment');
      }
    } catch (e) {
      _showError('Error uploading: $e');
    } finally {
      setState(() {
        _isUploading = false;
        _uploadProgress = null;
      });
    }
  }

  Future<void> _deleteAttachment(TaskAttachment attachment) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Attachment'),
        content: Text('Are you sure you want to delete "${attachment.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await AttachmentService.deleteAttachment(attachment);
      if (success) {
        final updatedAttachments = widget.attachments
            .where((a) => a.id != attachment.id)
            .toList();
        widget.onAttachmentsChanged(updatedAttachments);
        _showSuccess('Attachment deleted');
      } else {
        _showError('Failed to delete attachment');
      }
    }
  }

  void _viewAttachment(TaskAttachment attachment) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            attachment.name,
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  if (attachment.type == AttachmentType.image)
                    Flexible(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16),
                        ),
                        child: Image.network(
                          attachment.url,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Padding(
                              padding: EdgeInsets.all(40),
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Padding(
                              padding: EdgeInsets.all(40),
                              child: Icon(Icons.error_outline, size: 48),
                            );
                          },
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(
                            _getFileIcon(attachment.type),
                            size: 64,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            attachment.name,
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            attachment.type.displayName,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFileIcon(AttachmentType type) {
    switch (type) {
      case AttachmentType.image:
        return Icons.image;
      case AttachmentType.document:
        return Icons.description;
      case AttachmentType.other:
        return Icons.insert_drive_file;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Icon(
              Icons.attach_file,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Attachments',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            if (widget.attachments.isNotEmpty)
              Text(
                '${widget.attachments.length}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Upload progress
        if (_isUploading)
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Text(_uploadProgress ?? 'Uploading...'),
              ],
            ),
          ),

        // Attachments grid
        if (widget.attachments.isNotEmpty)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: widget.attachments.length,
            itemBuilder: (context, index) {
              final attachment = widget.attachments[index];
              return _AttachmentTile(
                attachment: attachment,
                onTap: () => _viewAttachment(attachment),
                onDelete: widget.isEditable
                    ? () => _deleteAttachment(attachment)
                    : null,
              );
            },
          ),

        // Add button
        if (widget.isEditable && !_isUploading)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: InkWell(
              onTap: _showAttachmentOptions,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.3),
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Add Attachment',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _AttachmentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(label),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  final TaskAttachment attachment;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const _AttachmentTile({
    required this.attachment,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.dividerColor.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Content
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: attachment.type == AttachmentType.image
                  ? Image.network(
                      attachment.url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.broken_image,
                            color: theme.colorScheme.error,
                          ),
                        );
                      },
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          attachment.type == AttachmentType.document
                              ? Icons.description
                              : Icons.insert_drive_file,
                          size: 32,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            attachment.name,
                            style: theme.textTheme.labelSmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
            ),

            // Delete button
            if (onDelete != null)
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

