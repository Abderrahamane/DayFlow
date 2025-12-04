// lib/pages/task_edit_page.dart - Simplified edit form
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/task/task_bloc.dart';
import '../models/task_model.dart';

class TaskEditPage extends StatefulWidget {
  final Task? task;

  const TaskEditPage({super.key, this.task});

  @override
  State<TaskEditPage> createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TaskPriority _selectedPriority;
  DateTime? _selectedDueDate;
  final List<String> _tags = [];
  final List<Subtask> _subtasks = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _selectedPriority = widget.task?.priority ?? TaskPriority.medium;
    _selectedDueDate = widget.task?.dueDate;
    if (widget.task?.tags != null) _tags.addAll(widget.task!.tags!);
    if (widget.task?.subtasks != null)
      _subtasks.addAll(widget.task!.subtasks!);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (date != null) setState(() => _selectedDueDate = date);
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    final task = Task(
      id: widget.task?.id ?? '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      isCompleted: widget.task?.isCompleted ?? false,
      createdAt: widget.task?.createdAt ?? DateTime.now(),
      dueDate: _selectedDueDate,
      priority: _selectedPriority,
      tags: _tags.isEmpty ? null : _tags,
      subtasks: _subtasks.isEmpty ? null : _subtasks,
    );

    context.read<TaskBloc>().add(AddOrUpdateTask(task));

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.task == null ? 'Task created' : 'Task updated'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSubtaskDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add subtask'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Subtask title',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _subtasks.add(Subtask(
                    id: 'st_${DateTime.now().millisecondsSinceEpoch}',
                    title: controller.text.trim(),
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showTagDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add tag'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Tag name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final tag = controller.text.trim();
              if (tag.isNotEmpty && !_tags.contains(tag)) {
                setState(() => _tags.add(tag));
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.dividerColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          widget.task == null ? 'New Task' : 'Edit Task',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Form
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Title
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          hintText: 'What needs to be done?',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                        ),
                        validator: (v) =>
                        v?.trim().isEmpty ?? true ? 'Required' : null,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(height: 16),
                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description (optional)',
                          hintText: 'Add more details...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                        ),
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(height: 24),
                      // Priority selector
                      Text(
                        'Priority',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: TaskPriority.values.map((priority) {
                          final isSelected = _selectedPriority == priority;
                          final color = priority == TaskPriority.high
                              ? Colors.red[400]!
                              : priority == TaskPriority.medium
                              ? Colors.orange[400]!
                              : Colors.blue[400]!;

                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: InkWell(
                                onTap: () =>
                                    setState(() => _selectedPriority = priority),
                                borderRadius: BorderRadius.circular(12),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? color
                                        : color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: color,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: Text(
                                    priority.displayName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color:
                                      isSelected ? Colors.white : color,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      // Due date
                      Text(
                        'Due Date',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: theme.dividerColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today_outlined,
                                  color: theme.colorScheme.primary),
                              const SizedBox(width: 12),
                              Text(
                                _selectedDueDate == null
                                    ? 'Set due date'
                                    : '${_selectedDueDate!.month}/${_selectedDueDate!.day}/${_selectedDueDate!.year}',
                                style: theme.textTheme.bodyLarge,
                              ),
                              const Spacer(),
                              if (_selectedDueDate != null)
                                IconButton(
                                  icon: const Icon(Icons.clear, size: 20),
                                  onPressed: () =>
                                      setState(() => _selectedDueDate = null),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Subtasks
                      Row(
                        children: [
                          Text(
                            'Subtasks',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: _showSubtaskDialog,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Add'),
                          ),
                        ],
                      ),
                      if (_subtasks.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        ..._subtasks.map((subtask) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color:
                              theme.colorScheme.primary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.drag_indicator, size: 20),
                                const SizedBox(width: 8),
                                Expanded(child: Text(subtask.title)),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 20),
                                  onPressed: () => setState(
                                          () => _subtasks.remove(subtask)),
                                ),
                              ],
                            ),
                          );
                        }),
                      ] else
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'No subtasks yet',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.5),
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      // Tags
                      Row(
                        children: [
                          Text(
                            'Tags',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: _showTagDialog,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Add'),
                          ),
                        ],
                      ),
                      if (_tags.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _tags.map((tag) {
                            return Chip(
                              label: Text('#$tag'),
                              onDeleted: () =>
                                  setState(() => _tags.remove(tag)),
                              deleteIcon: const Icon(Icons.close, size: 18),
                            );
                          }).toList(),
                        ),
                      ] else
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'No tags yet',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.5),
                            ),
                          ),
                        ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              // Save button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _saveTask,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        widget.task == null ? 'Create Task' : 'Save Changes',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}