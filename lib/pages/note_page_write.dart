import '/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '/models/note_model.dart'; // Using the specified import path

// Enum for page template types
enum PageTemplate { blank, lined, grid }

class NotePageWrite extends StatefulWidget {
  final Note? note;

  const NotePageWrite({super.key, this.note});

  @override
  State<NotePageWrite> createState() => _NotePageWriteState();
}

class _NotePageWriteState extends State<NotePageWrite>
    with SingleTickerProviderStateMixin {
  late TextEditingController titleController;
  late TextEditingController contentController;
  late FocusNode titleFocusNode;
  late AnimationController animationController;
  late Animation<double> titleScaleAnimation;

  // --- Custom Colors based on your requirements ---
  final Color _mainBackgroundColor = const Color.fromARGB(97, 251, 249, 244);
  final Color _cardBackgroundColor = const Color.fromARGB(111, 255, 255, 255);
  final Color _cardBorderColor = const Color.fromARGB(112, 240, 237, 229);

  late Color _selectedFontColor;
  late double _selectedFontSize;
  late PageTemplate _selectedTemplate;

  // <<< --- 1. STATE VARIABLE FOR PIN STATUS --- >>>
  late bool _isPinned;


  final Map<String, Color> _fontColorOptions = {
    'Black': Colors.black87,
    'White': Colors.white,
    'Primary': AppTheme.primaryLight,
    'Secondary': AppTheme.secondaryLight,
    'Grey': Colors.grey.shade600,
    'Accent': AppTheme.successColor,
  };

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.note?.title ?? '');
    contentController = TextEditingController(text: widget.note?.content ?? '');

    // <<< --- 2. INITIALIZE THE PIN STATUS --- >>>
    // It takes the note's current status, or defaults to false for a new note.
    _isPinned = widget.note?.isPinned ?? false;


    titleFocusNode = FocusNode();
    titleFocusNode.addListener(() {
      if (titleFocusNode.hasFocus) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    });

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    titleScaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedFontColor = Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black87;
        _selectedFontSize = 16.0;
        _selectedTemplate = PageTemplate.lined;
      });
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    titleFocusNode.dispose();
    animationController.dispose();
    super.dispose();
  }

  // All your dialog functions (_showColorPickerDialog, etc.) are perfect
  // and do not need any changes.
  // ... (All _show...Dialog methods are unchanged) ...

  // <<< --- 3. UPDATE THE SAVE FUNCTION --- >>>
  Future<Note?> _saveNoteContent() async {
    final now = DateTime.now();
    if (titleController.text.isEmpty && contentController.text.isEmpty) {
      return null;
    }
    if (widget.note != null) {
      // Update existing note
      return widget.note!.copyWith(
        title: titleController.text,
        content: contentController.text,
        updatedAt: now,
        isPinned: _isPinned,
      );
    } else {
      // Create new note
      final newNote = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleController.text,
        content: contentController.text,
        createdAt: now,
        updatedAt: now,
        isPinned: _isPinned, // Save the pin status
      );
      return newNote;
    }
  }

  Future<bool> _onBackPressed() async {
    final bool isTitleModified =
        (widget.note?.title ?? '') != titleController.text;
    final bool isContentModified =
        (widget.note?.content ?? '') != contentController.text;

    // Also check if the pin status has changed
    final bool isPinModified = (widget.note?.isPinned ?? false) != _isPinned;

    final bool hasUnsavedChanges = isTitleModified || isContentModified || isPinModified;

    if ((widget.note == null &&
        (titleController.text.isNotEmpty ||
            contentController.text.isNotEmpty)) ||
        (widget.note != null && hasUnsavedChanges)) {
      return await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) {
          final theme = Theme.of(dialogContext);
          return AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            title:
            Text('Save Changes?', style: theme.textTheme.titleLarge),
            content: Text('Do you want to save your changes before exiting?',
                style: theme.textTheme.bodyMedium),
            actions: <Widget>[
              TextButton(
                child: Text('Discard',
                    style: TextStyle(color: theme.colorScheme.error)),
                onPressed: () {
                  Navigator.of(dialogContext).pop(true);
                },
              ),
              TextButton(
                child: Text('Cancel',
                    style:
                    TextStyle(color: theme.colorScheme.onSurface)),
                onPressed: () {
                  Navigator.of(dialogContext).pop(false);
                },
              ),
              TextButton(
                child: Text('Save',
                    style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold)),
                onPressed: () async {
                  await _saveNoteContent();
                  Navigator.of(dialogContext).pop(true);
                },
              ),
            ],
          );
        },
      ) ??
          false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color lineBaseColor = _cardBackgroundColor.computeLuminance() > 0.5
        ? Colors.black.withOpacity(0.15)
        : Colors.white.withOpacity(0.15);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: _mainBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _onBackPressed()) {
                Navigator.of(context).pop();
              }
            },
            tooltip: 'Back',
          ),
          title: Text(
            widget.note == null ? "New Note" : "",
            style: theme.appBarTheme.titleTextStyle?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.appBarTheme.foregroundColor,
            ),
          ),
          iconTheme: theme.appBarTheme.iconTheme,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Note? savedNote = await _saveNoteContent();
            if (savedNote != null) {
              Navigator.pop(context, savedNote);
            } else {
              Navigator.pop(context);
            }
          },
          tooltip: 'Save Note',
          child: const Icon(Icons.save),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          color: _cardBackgroundColor,
          elevation: 8.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[

                // <<< --- 4. THE UPDATED PIN BUTTON --- >>>
                IconButton(
                  tooltip: 'Pin Note',
                  // The icon changes based on the _isPinned state
                  icon: Icon(
                    _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                    // The color also changes to give feedback
                    color: _isPinned ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  onPressed: () {
                    // This is the logic that toggles the boolean
                    setState(() {
                      _isPinned = !_isPinned;
                    });
                    // Optional: Show a message to the user
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_isPinned ? 'Note pinned.' : 'Note unpinned.'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                // --- END OF PIN BUTTON UPDATE ---

                IconButton(
                  icon: Icon(Icons.grid_on_outlined, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                  onPressed: _showPageTemplateDialog,
                  tooltip: 'Change Page Template',
                ),
                const SizedBox(width: 40),
                IconButton(
                  icon: Icon(Icons.format_size_outlined, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                  onPressed: _showFontSizePickerDialog,
                  tooltip: 'Change Font Size',
                ),
                IconButton(
                  icon: Icon(Icons.format_color_text, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                  onPressed: () => _showColorPickerDialog(
                    title: 'Choose Font Color',
                    options: _fontColorOptions,
                    currentColor: _selectedFontColor,
                    onSelectColor: (color) {
                      setState(() { _selectedFontColor = color; });
                    },
                  ),
                  tooltip: 'Change Font Color',
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Container(
            decoration: BoxDecoration(
              color: _cardBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _cardBorderColor.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomPaint(
                    painter: _selectedTemplate == PageTemplate.lined
                        ? LinedPaperPainter(
                      lineColor: lineBaseColor,
                      lineHeight: (_selectedFontSize * 1.5),
                    )
                        : _selectedTemplate == PageTemplate.grid
                        ? GridPaperPainter(
                      gridColor: lineBaseColor,
                      cellSize: (_selectedFontSize * 1.5),
                    )
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextField(
                        controller: titleController,
                        focusNode: titleFocusNode,
                        textAlignVertical: TextAlignVertical.top,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: _selectedFontSize + 4,
                          color: _selectedFontColor,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Title',
                          hintStyle: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: _selectedFontSize + 4,
                            color: _selectedFontColor.withOpacity(0.4),
                          ),
                          filled: false,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomPaint(
                    painter: _selectedTemplate == PageTemplate.lined
                        ? LinedPaperPainter(
                      lineColor: lineBaseColor,
                      lineHeight: (_selectedFontSize * 1.5),
                    )
                        : _selectedTemplate == PageTemplate.grid
                        ? GridPaperPainter(
                      gridColor: lineBaseColor,
                      cellSize: (_selectedFontSize * 1.5),
                    )
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextField(
                        controller: contentController,
                        textAlignVertical: TextAlignVertical.top,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: _selectedFontSize,
                          color: _selectedFontColor,
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: 'Write your note here...',
                          hintStyle: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: _selectedFontSize,
                            color: _selectedFontColor.withOpacity(0.4),
                          ),
                          filled: false,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- All your _show...Dialog methods and CustomPainters are here, unchanged ---

  void _showColorPickerDialog(
      {required String title,
        required Map<String, Color> options,
        required Color currentColor,
        required Function(Color) onSelectColor}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          final theme = Theme.of(context);
          return Container(
              decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20))),
              padding: const EdgeInsets.all(16),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(title,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: options.entries.map((entry) {
                      String colorName = entry.key;
                      Color color = entry.value;
                      return GestureDetector(
                          onTap: () {
                            onSelectColor(color);
                            Navigator.pop(context);
                          },
                          child: Column(children: [
                            Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: currentColor == color
                                            ? theme.colorScheme.primary
                                            : theme.dividerColor
                                            .withOpacity(0.5),
                                        width:
                                        currentColor == color ? 3.5 : 1.5),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2))
                                    ]),
                                child: currentColor == color
                                    ? Icon(Icons.check_circle_outline,
                                    color: color.computeLuminance() > 0.5
                                        ? Colors.black
                                        : Colors.white,
                                    size: 28)
                                    : null),
                            const SizedBox(height: 6),
                            Text(colorName,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.textTheme.bodySmall?.color
                                        ?.withOpacity(0.8)))
                          ]));
                    }).toList())
              ]));
        });
  }

  void _showFontSizePickerDialog() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          final theme = Theme.of(context);
          return Container(
              decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20))),
              padding: const EdgeInsets.all(16),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('Choose Font Size',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setModalState) {
                      return Column(children: [
                        Slider(
                            value: _selectedFontSize,
                            min: 12.0,
                            max: 24.0,
                            divisions: 12,
                            label: _selectedFontSize.round().toString(),
                            onChanged: (double value) {
                              setModalState(() {
                                _selectedFontSize = value;
                              });
                              setState(() {
                                _selectedFontSize = value;
                              });
                            },
                            activeColor: theme.colorScheme.primary,
                            inactiveColor:
                            theme.colorScheme.primary.withOpacity(0.3)),
                        Text('Current Size: ${_selectedFontSize.round()}',
                            style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: _selectedFontSize,
                                color: _selectedFontColor))
                      ]);
                    }),
                const SizedBox(height: 10)
              ]));
        });
  }

  void _showPageTemplateDialog() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          final theme = Theme.of(context);
          return Container(
              decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20))),
              padding: const EdgeInsets.all(16),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('Choose Page Template',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: PageTemplate.values.map((template) {
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTemplate = template;
                            });
                            Navigator.pop(context);
                          },
                          child: Column(children: [
                            Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                    color: theme.colorScheme.background,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: _selectedTemplate == template
                                            ? theme.colorScheme.primary
                                            : theme.dividerColor
                                            .withOpacity(0.5),
                                        width: _selectedTemplate == template
                                            ? 3.5
                                            : 1.5),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2))
                                    ]),
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      if (template == PageTemplate.lined)
                                        CustomPaint(
                                            size: Size.infinite,
                                            painter: LinedPaperPainter(
                                                lineColor: theme.dividerColor
                                                    .withOpacity(0.3),
                                                lineHeight: 20)),
                                      if (template == PageTemplate.grid)
                                        CustomPaint(
                                            size: Size.infinite,
                                            painter: GridPaperPainter(
                                                gridColor: theme.dividerColor
                                                    .withOpacity(0.3),
                                                cellSize: 20)),
                                      if (_selectedTemplate == template)
                                        Icon(Icons.check_circle,
                                            color: theme.colorScheme.primary,
                                            size: 36)
                                    ])),
                            const SizedBox(height: 6),
                            Text(template.name.capitalize(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.textTheme.bodySmall?.color
                                        ?.withOpacity(0.8)))
                          ]));
                    }).toList())
              ]));
        });
  }
}

class LinedPaperPainter extends CustomPainter {
  final Color lineColor;
  final double lineHeight;
  LinedPaperPainter({required this.lineColor, required this.lineHeight});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.0;
    for (double i = lineHeight; i < size.height; i += lineHeight) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant LinedPaperPainter oldDelegate) => false;
}

class GridPaperPainter extends CustomPainter {
  final Color gridColor;
  final double cellSize;
  GridPaperPainter({required this.gridColor, required this.cellSize});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 1.0;
    for (double i = cellSize; i < size.height; i += cellSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
    for (double i = cellSize; i < size.width; i += cellSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPaperPainter oldDelegate) => false;
}

extension StringCasingExtension on String {
  String capitalize() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
}