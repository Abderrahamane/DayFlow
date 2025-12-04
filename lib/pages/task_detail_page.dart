import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/task/task_bloc.dart';
import '../models/task_model.dart';
import 'task_edit_page.dart';

class TaskDetailPage extends StatelessWidget {
  final String taskId;

  const TaskDetailPage({super.key, required this.taskId});


  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showDeleteDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete task?'),
        content: const Text(
            'This task will be permanently deleted. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        final task = state.tasks.firstWhere(
          (t) => t.id == taskId,
          orElse: () => Task(
            id: '',
            title: '',
            createdAt: DateTime.now(),
            priority: TaskPriority.medium,
          ),
        );

        if (task.id.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Task Not Found')),
            body: const Center(child: Text('Task not found')),
          );
        }

        final priorityColor = Colors.red;

        return Scaffold(
          backgroundColor: theme.brightness == Brightness.light
              ? Colors.grey[50]
              : theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => TaskEditPage(task: task),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _showDeleteDialog(context, task),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: theme.scaffoldBackgroundColor,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => context.read<TaskBloc>().add(
                                  ToggleTaskCompletionEvent(task.id),
                                ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: task.isCompleted
                                    ? theme.colorScheme.primary
                                    : Colors.transparent,
                                border: Border.all(
                                  color: task.isCompleted
                                      ? theme.colorScheme.primary
                                      : Colors.grey[400]!,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: task.isCompleted
                                  ? const Icon(
                                      Icons.check,
                                      size: 18,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              task.title,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.isCompleted
                                    ? theme.textTheme.bodyMedium?.color
                                        ?.withOpacity(0.5)
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _InfoChip(
                            icon: Icons.flag_outlined,
                            label: task.priority.displayName,
                            color: priorityColor,
                          ),
                          if (task.dueDate != null)
                            _InfoChip(
                              icon: Icons.calendar_today_outlined,
                              label: _formatDate(task.dueDate!),
                              color: task.isOverdue ? Colors.red : null,
                            ),
                          if (task.daysRemaining != null)
                            _InfoChip(
                              icon: task.isOverdue
                                  ? Icons.warning_amber_rounded
                                  : Icons.schedule_outlined,
                              label: task.isOverdue
                                  ? '${task.daysRemaining!.abs()}d overdue'
                                  : task.daysRemaining == 0
                                      ? 'Due today'
                                      : '${task.daysRemaining}d left',
                              color: task.isOverdue ? Colors.red : Colors.blue,
                            ),
                          if (task.tags != null && task.tags!.isNotEmpty)
                            _InfoChip(
                              icon: Icons.sell_outlined,
                              label: task.tags!.join(', '),
                              color: theme.colorScheme.primary.withOpacity(0.8),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (task.description != null) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          task.description!,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
                if (task.subtasks != null && task.subtasks!.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtasks',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${task.completedSubtasks}/${task.totalSubtasks} completed',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...task.subtasks!.map(
                    (subtask) => _SubtaskTile(
                      subtask: subtask,
                      onToggle: () => context.read<TaskBloc>().add(
                            ToggleSubtaskCompletionEvent(
                              taskId: task.id,
                              subtaskId: subtask.id,
                            ),
                          ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoChip({
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      avatar: Icon(icon, size: 16, color: color ?? theme.colorScheme.primary),
      label: Text(label),
      backgroundColor: (color ?? theme.colorScheme.primary).withOpacity(0.08),
      side: BorderSide(color: (color ?? theme.colorScheme.primary).withOpacity(0.4)),
    );
  }
}

class _SubtaskTile extends StatelessWidget {
  final Subtask subtask;
  final VoidCallback onToggle;

  const _SubtaskTile({required this.subtask, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Checkbox(
        value: subtask.isCompleted,
        onChanged: (_) => onToggle(),
        activeColor: theme.colorScheme.primary,
      ),
      title: Text(
        subtask.title,
        style: theme.textTheme.bodyLarge?.copyWith(
          decoration:
              subtask.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
    );
  }
}
