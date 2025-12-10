import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

import '../blocs/note/note_bloc.dart';
import '../models/note_model.dart';

class NoteEditorPage extends StatefulWidget {
  final Note? note;

  const NoteEditorPage({super.key, this.note});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  final _uuid = const Uuid();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late NoteType _noteType;
  late Color? _selectedColor;
  late NoteCategory? _selectedCategory;
  late List<String> _tags;
  late List<ChecklistItem> _checklistItems;
  late List<NoteAttachment> _attachments;
  bool _isPinned = false;
  bool _hasChanges = false;
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;

  final _imagePicker = ImagePicker();
  final FocusNode _contentFocusNode = FocusNode();
  final TextEditingController _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final note = widget.note;
    _titleController = TextEditingController(text: note?.title ?? '');
    _contentController = TextEditingController(text: note?.content ?? '');
    _noteType = note?.type ?? NoteType.text;
    _selectedColor = note?.color;
    _selectedCategory = note?.category;
    _tags = List.from(note?.tags ?? []);
    _checklistItems = List.from(note?.checklistItems ?? []);
    _attachments = List.from(note?.attachments ?? []);
    _isPinned = note?.isPinned ?? false;

    _titleController.addListener(_markChanged);
    _contentController.addListener(_markChanged);
  }

  void _markChanged() {
    if (!_hasChanges) setState(() => _hasChanges = true);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  void _saveNote() {
    final note = Note(
      id: widget.note?.id ?? '',
      title: _titleController.text.trim().isEmpty
          ? 'Untitled'
          : _titleController.text.trim(),
      content: _contentController.text.trim(),
      createdAt: widget.note?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      color: _selectedColor,
      tags: _tags.isEmpty ? null : _tags,
      isPinned: _isPinned,
      type: _noteType,
      checklistItems: _checklistItems.isEmpty ? null : _checklistItems,
      attachments: _attachments.isEmpty ? null : _attachments,
      category: _selectedCategory,
      isLocked: widget.note?.isLocked ?? false,
      lockPin: widget.note?.lockPin,
      useBiometric: widget.note?.useBiometric ?? false,
    );

    context.read<NoteBloc>().add(AddOrUpdateNote(note));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.note == null ? 'Note created' : 'Note updated'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('You have unsaved changes. Discard them?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = _selectedColor ?? theme.scaffoldBackgroundColor;
    final textColor = NoteColors.getContrastText(bgColor);

    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () async {
              if (await _onWillPop()) Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                color: textColor,
              ),
              onPressed: () => setState(() {
                _isPinned = !_isPinned;
                _hasChanges = true;
              }),
            ),
            IconButton(
              icon: Icon(Icons.palette_outlined, color: textColor),
              onPressed: _showColorPicker,
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: textColor),
              onPressed: _showMoreOptions,
            ),
            TextButton(
              onPressed: _hasChanges ? _saveNote : null,
              child: Text(
                'Save',
                style: TextStyle(
                  color: _hasChanges ? textColor : textColor.withAlpha(128),
                ),
              ),
            ),
          ],
        ),
        body: Theme(
          data: theme.copyWith(
            inputDecorationTheme: InputDecorationTheme(
              filled: false,
              fillColor: Colors.transparent,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: textColor,
              selectionColor: textColor.withAlpha(77),
              selectionHandleColor: textColor,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category & Tags row
                      _CategoryTagsRow(
                        category: _selectedCategory,
                        tags: _tags,
                        textColor: textColor,
                        onCategoryTap: _showCategoryPicker,
                        onTagTap: _showTagEditor,
                      ),
                      const SizedBox(height: 16),

                      // Title
                      TextField(
                        controller: _titleController,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        cursorColor: textColor,
                        decoration: InputDecoration(
                          hintText: 'Title',
                          hintStyle: TextStyle(color: textColor.withAlpha(100)),
                        ),
                        maxLines: null,
                      ),

                    const SizedBox(height: 8),

                    // Content based on type
                    if (_noteType == NoteType.checklist)
                      _ChecklistEditor(
                        items: _checklistItems,
                        textColor: textColor,
                        onItemsChanged: (items) {
                          setState(() {
                            _checklistItems = items;
                            _hasChanges = true;
                          });
                        },
                      )
                      else
                        TextField(
                          controller: _contentController,
                          focusNode: _contentFocusNode,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: textColor,
                            fontWeight: _isBold ? FontWeight.bold : null,
                            fontStyle: _isItalic ? FontStyle.italic : null,
                            decoration: _isUnderline
                                ? TextDecoration.underline
                                : null,
                          ),
                          cursorColor: textColor,
                          decoration: InputDecoration(
                            hintText: 'Start writing...',
                            hintStyle: TextStyle(color: textColor.withAlpha(100)),
                          ),
                          maxLines: null,
                          minLines: 10,
                        ),

                    const SizedBox(height: 24),

                    // Attachments
                    if (_attachments.isNotEmpty)
                      _AttachmentsList(
                        attachments: _attachments,
                        textColor: textColor,
                        onRemove: (attachment) {
                          setState(() {
                            _attachments.remove(attachment);
                            _hasChanges = true;
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),

            // Bottom toolbar
            _EditorToolbar(
              noteType: _noteType,
              textColor: textColor,
              bgColor: bgColor,
              isBold: _isBold,
              isItalic: _isItalic,
              isUnderline: _isUnderline,
              onBoldTap: () => setState(() => _isBold = !_isBold),
              onItalicTap: () => setState(() => _isItalic = !_isItalic),
              onUnderlineTap: () =>
                  setState(() => _isUnderline = !_isUnderline),
              onAddImage: _addImage,
              onAddFile: _addFile,
              onAddCheckbox: _noteType == NoteType.text
                  ? () {
                      // Insert checkbox in content
                      final text = _contentController.text;
                      final selection = _contentController.selection;
                      final newText =
                          '${text.substring(0, selection.start)}☐ ${text.substring(selection.end)}';
                      _contentController.text = newText;
                      _contentController.selection = TextSelection.collapsed(
                        offset: selection.start + 3,
                      );
                    }
                  : null,
            ),
          ],
        ),
        ),
      ),
    );
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '🎨 Choose Background',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select a color that matches your mood',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 24),
            // Color grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: NoteColors.colors.length,
              itemBuilder: (context, index) {
                final color = NoteColors.colors[index];
                final isSelected = _selectedColor == color ||
                    (_selectedColor == null && color == const Color(0xFFFFFFFF));
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color == const Color(0xFFFFFFFF) ? null : color;
                      _hasChanges = true;
                    });
                    Navigator.pop(ctx);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        width: isSelected ? 3 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withAlpha(128),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            size: 24,
                            color: NoteColors.getContrastText(color),
                          )
                        : null,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Reset button
            Center(
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedColor = null;
                    _hasChanges = true;
                  });
                  Navigator.pop(ctx);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reset to default'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
              'Select Category',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text('None'),
                  selected: _selectedCategory == null,
                  onSelected: (_) {
                    setState(() {
                      _selectedCategory = null;
                      _hasChanges = true;
                    });
                    Navigator.pop(ctx);
                  },
                ),
                ...NoteCategory.values.map((category) {
                  return FilterChip(
                    label: Text('${category.icon} ${category.displayName}'),
                    selected: _selectedCategory == category,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = category;
                        _hasChanges = true;
                      });
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTagEditor() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Container(
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
                'Tags',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _tagController,
                      decoration: const InputDecoration(
                        hintText: 'Add tag...',
                        prefixText: '# ',
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty && !_tags.contains(value)) {
                          setState(() {
                            _tags.add(value);
                            _hasChanges = true;
                          });
                        }
                        _tagController.clear();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      final value = _tagController.text.trim();
                      if (value.isNotEmpty && !_tags.contains(value)) {
                        setState(() {
                          _tags.add(value);
                          _hasChanges = true;
                        });
                      }
                      _tagController.clear();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tags.map((tag) {
                  return Chip(
                    label: Text('#$tag'),
                    onDeleted: () {
                      setState(() {
                        _tags.remove(tag);
                        _hasChanges = true;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMoreOptions() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Delete note'),
              onTap: () {
                Navigator.pop(ctx);
                if (widget.note != null) {
                  context
                      .read<NoteBloc>()
                      .add(DeleteNoteEvent(widget.note!.id));
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Duplicate note'),
              onTap: () {
                Navigator.pop(ctx);
                _duplicateNote();
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(ctx);
                // TODO: Implement share
              },
            ),
          ],
        ),
      ),
    );
  }

  void _duplicateNote() {
    final note = Note(
      id: '',
      title: '${_titleController.text} (Copy)',
      content: _contentController.text,
      createdAt: DateTime.now(),
      color: _selectedColor,
      tags: _tags.isEmpty ? null : List.from(_tags),
      type: _noteType,
      checklistItems: _checklistItems.isEmpty
          ? null
          : _checklistItems.map((c) => c.copyWith(id: _uuid.v4())).toList(),
      attachments: _attachments.isEmpty ? null : List.from(_attachments),
      category: _selectedCategory,
    );

    context.read<NoteBloc>().add(AddOrUpdateNote(note));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note duplicated'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _addImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final pickedFile = await _imagePicker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length();

      final attachment = NoteAttachment(
        id: _uuid.v4(),
        noteId: widget.note?.id ?? '',
        name: pickedFile.name,
        url: pickedFile.path, // In production, upload to storage
        localPath: pickedFile.path,
        type: AttachmentType.image,
        sizeBytes: fileSize,
        createdAt: DateTime.now(),
      );

      setState(() {
        _attachments.add(attachment);
        _hasChanges = true;
      });
    }
  }

  Future<void> _addFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'xlsx', 'pptx'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final attachmentType = _getAttachmentType(file.extension ?? '');

      final attachment = NoteAttachment(
        id: _uuid.v4(),
        noteId: widget.note?.id ?? '',
        name: file.name,
        url: file.path ?? '',
        localPath: file.path,
        type: attachmentType,
        sizeBytes: file.size,
        createdAt: DateTime.now(),
      );

      setState(() {
        _attachments.add(attachment);
        _hasChanges = true;
      });
    }
  }

  AttachmentType _getAttachmentType(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return AttachmentType.pdf;
      case 'doc':
      case 'docx':
      case 'txt':
        return AttachmentType.document;
      default:
        return AttachmentType.other;
    }
  }
}

class _CategoryTagsRow extends StatelessWidget {
  final NoteCategory? category;
  final List<String> tags;
  final Color textColor;
  final VoidCallback onCategoryTap;
  final VoidCallback onTagTap;

  const _CategoryTagsRow({
    required this.category,
    required this.tags,
    required this.textColor,
    required this.onCategoryTap,
    required this.onTagTap,
  });

  @override
  Widget build(BuildContext context) {
    final chipBgColor = textColor.withAlpha(20);
    final borderColor = textColor.withAlpha(51);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // Category chip
        GestureDetector(
          onTap: onCategoryTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: chipBgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (category != null)
                  Text(category!.icon, style: const TextStyle(fontSize: 14))
                else
                  Icon(Icons.category_outlined, size: 16, color: textColor),
                const SizedBox(width: 6),
                Text(
                  category?.displayName ?? 'Add category',
                  style: TextStyle(color: textColor, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
        // Tags chip
        GestureDetector(
          onTap: onTagTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: chipBgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.tag, size: 16, color: textColor),
                const SizedBox(width: 6),
                Text(
                  tags.isEmpty ? 'Add tags' : tags.map((t) => '#$t').join(' '),
                  style: TextStyle(color: textColor, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ChecklistEditor extends StatefulWidget {
  final List<ChecklistItem> items;
  final Color textColor;
  final Function(List<ChecklistItem>) onItemsChanged;

  const _ChecklistEditor({
    required this.items,
    required this.textColor,
    required this.onItemsChanged,
  });

  @override
  State<_ChecklistEditor> createState() => _ChecklistEditorState();
}

class _ChecklistEditorState extends State<_ChecklistEditor> {
  final _uuid = const Uuid();
  final _newItemController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _newItemController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addItem(String text) {
    if (text.isEmpty) return;

    final newItem = ChecklistItem(
      id: _uuid.v4(),
      text: text,
      order: widget.items.length,
    );

    final updatedItems = [...widget.items, newItem];
    widget.onItemsChanged(updatedItems);
    _newItemController.clear();
    _focusNode.requestFocus();
  }

  void _toggleItem(ChecklistItem item) {
    final updatedItems = widget.items.map((i) {
      if (i.id == item.id) {
        return i.copyWith(isChecked: !i.isChecked);
      }
      return i;
    }).toList();

    // Sort: unchecked first, then checked
    updatedItems.sort((a, b) {
      if (a.isChecked && !b.isChecked) return 1;
      if (!a.isChecked && b.isChecked) return -1;
      return a.order.compareTo(b.order);
    });

    widget.onItemsChanged(updatedItems);
  }

  void _removeItem(ChecklistItem item) {
    final updatedItems = widget.items.where((i) => i.id != item.id).toList();
    widget.onItemsChanged(updatedItems);
  }

  void _updateItemText(ChecklistItem item, String text) {
    final updatedItems = widget.items.map((i) {
      if (i.id == item.id) {
        return i.copyWith(text: text);
      }
      return i;
    }).toList();
    widget.onItemsChanged(updatedItems);
  }

  @override
  Widget build(BuildContext context) {
    final uncheckedItems = widget.items.where((i) => !i.isChecked).toList();
    final checkedItems = widget.items.where((i) => i.isChecked).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Unchecked items
        ...uncheckedItems.map((item) => _ChecklistItemTile(
              item: item,
              textColor: widget.textColor,
              onToggle: () => _toggleItem(item),
              onDelete: () => _removeItem(item),
              onTextChanged: (text) => _updateItemText(item, text),
            )),

        // Add new item
        Row(
          children: [
            Icon(Icons.add, color: widget.textColor.withAlpha(128), size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _newItemController,
                focusNode: _focusNode,
                style: TextStyle(color: widget.textColor),
                cursorColor: widget.textColor,
                decoration: InputDecoration(
                  hintText: 'Add item',
                  hintStyle: TextStyle(color: widget.textColor.withAlpha(100)),
                  border: InputBorder.none,
                  filled: false,
                ),
                onSubmitted: _addItem,
              ),
            ),
          ],
        ),

        // Checked items (collapsed section)
        if (checkedItems.isNotEmpty) ...[
          Divider(height: 32, color: widget.textColor.withAlpha(51)),
          Text(
            '${checkedItems.length} completed',
            style: TextStyle(
              color: widget.textColor.withAlpha(128),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ...checkedItems.map((item) => _ChecklistItemTile(
                item: item,
                textColor: widget.textColor,
                onToggle: () => _toggleItem(item),
                onDelete: () => _removeItem(item),
                onTextChanged: (text) => _updateItemText(item, text),
              )),
        ],
      ],
    );
  }
}

class _ChecklistItemTile extends StatelessWidget {
  final ChecklistItem item;
  final Color textColor;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final Function(String) onTextChanged;

  const _ChecklistItemTile({
    required this.item,
    required this.textColor,
    required this.onToggle,
    required this.onDelete,
    required this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.red),
      ),
      onDismissed: (_) => onDelete(),
      child: Row(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Icon(
              item.isChecked
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: textColor.withAlpha(item.isChecked ? 128 : 255),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: TextEditingController(text: item.text),
              style: TextStyle(
                color: textColor.withAlpha(item.isChecked ? 128 : 255),
                decoration:
                    item.isChecked ? TextDecoration.lineThrough : null,
              ),
              cursorColor: textColor,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: false,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: onTextChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttachmentsList extends StatelessWidget {
  final List<NoteAttachment> attachments;
  final Color textColor;
  final Function(NoteAttachment) onRemove;

  const _AttachmentsList({
    required this.attachments,
    required this.textColor,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final images = attachments.where((a) => a.type == AttachmentType.image).toList();
    final files = attachments.where((a) => a.type != AttachmentType.image).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (images.isNotEmpty) ...[
          Text(
            'Images',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
                return Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: image.localPath != null
                            ? Image.file(
                                File(image.localPath!),
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 120,
                                height: 120,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.image),
                              ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 16,
                      child: GestureDetector(
                        onTap: () => onRemove(image),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (files.isNotEmpty) ...[
          Text(
            'Files',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
          ),
          const SizedBox(height: 8),
          ...files.map((file) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: textColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(file.type.icon, color: textColor),
                ),
                title: Text(file.name, style: TextStyle(color: textColor)),
                subtitle: Text(file.formattedSize, style: TextStyle(color: textColor.withAlpha(153))),
                trailing: IconButton(
                  icon: Icon(Icons.close, color: textColor.withAlpha(179)),
                  onPressed: () => onRemove(file),
                ),
              )),
        ],
      ],
    );
  }
}

class _EditorToolbar extends StatelessWidget {
  final NoteType noteType;
  final Color textColor;
  final Color bgColor;
  final bool isBold;
  final bool isItalic;
  final bool isUnderline;
  final VoidCallback onBoldTap;
  final VoidCallback onItalicTap;
  final VoidCallback onUnderlineTap;
  final VoidCallback onAddImage;
  final VoidCallback onAddFile;
  final VoidCallback? onAddCheckbox;

  const _EditorToolbar({
    required this.noteType,
    required this.textColor,
    required this.bgColor,
    required this.isBold,
    required this.isItalic,
    required this.isUnderline,
    required this.onBoldTap,
    required this.onItalicTap,
    required this.onUnderlineTap,
    required this.onAddImage,
    required this.onAddFile,
    required this.onAddCheckbox,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          top: BorderSide(color: textColor.withAlpha(26)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Format buttons (only for rich text)
            if (noteType == NoteType.richText || noteType == NoteType.text) ...[
              _ToolbarButton(
                icon: Icons.format_bold,
                isActive: isBold,
                color: textColor,
                onTap: onBoldTap,
              ),
              _ToolbarButton(
                icon: Icons.format_italic,
                isActive: isItalic,
                color: textColor,
                onTap: onItalicTap,
              ),
              _ToolbarButton(
                icon: Icons.format_underline,
                isActive: isUnderline,
                color: textColor,
                onTap: onUnderlineTap,
              ),
              const SizedBox(width: 8),
              Container(width: 1, height: 24, color: textColor.withAlpha(51)),
              const SizedBox(width: 8),
            ],

            // Checkbox (for text notes)
            if (onAddCheckbox != null)
              _ToolbarButton(
                icon: Icons.check_box_outlined,
                isActive: false,
                color: textColor,
                onTap: onAddCheckbox!,
              ),

            const Spacer(),

            // Attachment buttons
            _ToolbarButton(
              icon: Icons.image_outlined,
              isActive: false,
              color: textColor,
              onTap: onAddImage,
            ),
            _ToolbarButton(
              icon: Icons.attach_file,
              isActive: false,
              color: textColor,
              onTap: onAddFile,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final Color color;
  final VoidCallback onTap;

  const _ToolbarButton({
    required this.icon,
    required this.isActive,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? color.withAlpha(26) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isActive ? color : color.withAlpha(179),
          size: 22,
        ),
      ),
    );
  }
}

