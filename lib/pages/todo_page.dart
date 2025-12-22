import 'package:dayflow/widgets/task_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/task/task_bloc.dart';
import '../blocs/navigation/navigation_cubit.dart';
import '../models/task_model.dart';
import '../models/recurrence_model.dart';
import '../utils/date_utils.dart';
import '../utils/routes.dart';
import '../utils/app_localizations.dart';
import '../widgets/quote_card.dart';
import '../widgets/task_card.dart';
import '../widgets/recurrence_picker_widget.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasks());

    // Check for navigation actions
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkNavigationAction();
    });
  }

  void _checkNavigationAction() {
    final navigationState = context.read<NavigationCubit>().state;
    if (navigationState.action == NavigationAction.openCreateTask) {
      final date = navigationState.data as DateTime?;
      // Clear the action so it doesn't trigger again
      context.read<NavigationCubit>().clearAction();

      // Open task sheet with pre-filled date if available
      if (date != null) {
        // Create a temporary task with the selected date
        final task = Task(
          id: '',
          title: '',
          dueDate: date,
          createdAt: DateTime.now(),
        );
        _openTaskSheet(task: task);
      } else {
        _openTaskSheet();
      }
    }
  }

  String _formattedHeaderDate() => formattedHeaderDate();

  void _openTaskSheet({Task? task}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TaskEditor(task: task),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            final tasks = state.visibleTasks;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          _formattedHeaderDate(),
                          style: theme.textTheme.labelLarge?.copyWith(
                            color:
                                theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Center(
                        child: Text(
                          l10n.todaysList,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TaskFilterBar(
                        currentFilter: state.filter,
                        currentSort: state.sort,
                        onFilterChanged: (filter) =>
                            context.read<TaskBloc>().add(ChangeTaskFilter(filter)),
                        onSortChanged: (sort) =>
                            context.read<TaskBloc>().add(ChangeTaskSort(sort)),
                        totalTasks: state.tasks.length,
                        completedTasks: state.completedCount,
                        pendingTasks: state.pendingCount,
                        overdueTasks: state.overdueCount,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: switch (state.status) {
                    TaskStatus.loading => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    TaskStatus.failure => Center(
                        child: Text(state.errorMessage ?? l10n.failedToLoadTasks),
                      ),
                    _ => tasks.isEmpty
                        ? const _EmptyTasks()
                        : ListView(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                            children: [
                              const SizedBox(height: 8),
                              ...tasks.map(
                                (task) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TaskCard(
                                    task: task,
                                    onTap: () => _openTaskSheet(task: task),
                                    onToggleComplete: () => context
                                        .read<TaskBloc>()
                                        .add(ToggleTaskCompletionEvent(task.id)),
                                    onDelete: () => context
                                        .read<TaskBloc>()
                                        .add(DeleteTaskEvent(task.id)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              const QuoteCard(),
                            ],
                          ),
                  },
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'pomodoro_fab',
            onPressed: () => Routes.navigateToPomodoro(context),
            backgroundColor: Colors.deepOrange,
            child: const Icon(Icons.timer, size: 20, color: Colors.white),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'templates_fab',
            onPressed: () => Routes.navigateToTemplates(context),
            backgroundColor: theme.colorScheme.secondary,
            child: const Icon(Icons.library_books, size: 20, color: Colors.white),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'add_task_fab',
            onPressed: _openTaskSheet,
            backgroundColor: primary,
            child: const Icon(Icons.add, size: 28, color: Colors.white),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _TaskEditor extends StatefulWidget {
  final Task? task;

  const _TaskEditor({required this.task});

  @override
  State<_TaskEditor> createState() => _TaskEditorState();
}

class _TaskEditorState extends State<_TaskEditor> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _tagsController;
  DateTime? _selectedDate;
  TaskPriority _priority = TaskPriority.medium;
  RecurrencePattern? _recurrence;
  bool _showRecurrence = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _tagsController = TextEditingController(
      text: widget.task?.tags?.join(', ') ?? '',
    );
    _selectedDate = widget.task?.dueDate;
    _priority = widget.task?.priority ?? TaskPriority.medium;
    _recurrence = widget.task?.recurrence;
    _showRecurrence = widget.task?.recurrence != null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 730)),
    );

    if (!mounted || date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate ?? now),
    );

    if (time != null) {
      setState(() {
        _selectedDate = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    final bloc = context.read<TaskBloc>();
    final tags = _tagsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final task = Task(
      id: widget.task?.id ?? '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      isCompleted: widget.task?.isCompleted ?? false,
      createdAt: widget.task?.createdAt ?? DateTime.now(),
      dueDate: _selectedDate,
      priority: _priority,
      tags: tags.isEmpty ? null : tags,
      subtasks: widget.task?.subtasks,
      recurrence: _recurrence,
      parentTaskId: widget.task?.parentTaskId,
    );

    bloc.add(AddOrUpdateTask(task));
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.task == null
            ? AppLocalizations.of(context).taskAdded
            : AppLocalizations.of(context).taskUpdated),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getPriorityLabel(BuildContext context, TaskPriority priority) {
    final l10n = AppLocalizations.of(context);
    switch (priority) {
      case TaskPriority.none:
        return l10n.priorityNone;
      case TaskPriority.low:
        return l10n.priorityLow;
      case TaskPriority.medium:
        return l10n.priorityMedium;
      case TaskPriority.high:
        return l10n.priorityHigh;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.task == null ? l10n.createNewTask : l10n.editTask,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: l10n.taskTitle,
                    prefixIcon: const Icon(Icons.task_alt),
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? l10n.required : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: l10n.description,
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _tagsController,
                  decoration: InputDecoration(
                    labelText: l10n.tagsHint,
                    prefixIcon: const Icon(Icons.sell_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickDateTime,
                        icon: const Icon(Icons.calendar_today_outlined),
                        label: Text(
                          _selectedDate == null
                              ? l10n.setDueDate
                              : formattedDateWithDay(_selectedDate!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<TaskPriority>(
                      value: _priority,
                      items: TaskPriority.values
                          .map(
                            (p) => DropdownMenuItem(
                              value: p,
                              child: Text(_getPriorityLabel(context, p)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _priority = value);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Recurrence section
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.repeat,
                    color: _recurrence?.isRecurring == true
                        ? theme.colorScheme.primary
                        : null,
                  ),
                  title: Text(
                    _recurrence?.isRecurring == true
                        ? _recurrence!.description
                        : l10n.addRecurrence,
                  ),
                  trailing: Icon(
                    _showRecurrence
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                  onTap: () => setState(() => _showRecurrence = !_showRecurrence),
                ),
                if (_showRecurrence) ...[
                  const SizedBox(height: 8),
                  RecurrencePickerWidget(
                    initialPattern: _recurrence,
                    onChanged: (pattern) => setState(() => _recurrence = pattern),
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveTask,
                    child: Text(widget.task == null ? l10n.addTask : l10n.updateTask),
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

class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: 60,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noTasksYet,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.createFirstTask,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
