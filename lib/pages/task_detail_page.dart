// lib/pages/task_detail_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/tasks_provider.dart'; // <<< USING THE NEW LOCAL PROVIDER
import 'task_edit_page.dart';

class TaskDetailPage extends StatelessWidget {
  final String taskId;

  const TaskDetailPage({super.key, required this.taskId});

  // This is the function that handles navigation to the editor page
  // for when the user wants to EDIT the current task.
  void _navigateToEditor(BuildContext context, Task task) async {
    final provider = Provider.of<TaskProvider>(context, listen: false);

    final savedTask = await showModalBottomSheet<Task>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TaskEditPage(task: task),
    );

    if (savedTask != null) {
      await provider.updateTask(savedTask);
    }
  }
  
  // Your helper functions from the original file
  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red[400]!;
      case TaskPriority.medium:
        return Colors.orange[400]!;
      case TaskPriority.low:
        return Colors.blue[400]!;
      case TaskPriority.none:
        return Colors.grey[400]!;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showDeleteDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete task?'),
        content: const Text(
            'This task will be permanently deleted. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // Use read because we are in a callback
              context.read<TaskProvider>().deleteTask(task.id);
              Navigator.pop(dialogContext); // Close the dialog
              Navigator.pop(context); // Go back from the detail page
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
    // <<< --- THIS IS THE CORRECTED PART --- >>>
    // Use 'watch' to listen for changes to the task list
    final provider = context.watch<TaskProvider>();
    // Get the specific task from the provider's list using the taskId
    final task = provider.getTaskById(taskId);
    // --- END OF CORRECTION ---

    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Task Not Found')),
        body: const Center(child: Text('Task not found')),
      );
    }

    final priorityColor = _getPriorityColor(task.priority);

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
              // Call our navigation helper to open the edit page
              _navigateToEditor(context, task);
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
            // Header section
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
                        onTap: () => provider.toggleTaskCompletion(task.id),
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
                              ? const Icon(Icons.check, size: 18, color: Colors.white)
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
                                ? theme.textTheme.bodyMedium?.color?.withOpacity(0.5)
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Meta info chips
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
                    ],
                  ),
                ],
              ),
            ),
            // Content sections
            if (task.description != null && task.description!.isNotEmpty) ...[
              _Section(
                title: 'Description',
                icon: Icons.description_outlined,
                child: Text(
                  task.description!,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
              ),
            ],
            if (task.hasSubtasks) ...[
              _Section(
                title: 'Subtasks',
                icon: Icons.checklist_rounded,
                trailing:
                '${task.completedSubtasks}/${task.totalSubtasks}',
                child: Column(
                  children: task.subtasks!.map((subtask) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          // NOTE: Subtask completion logic would need to be added to the provider.
                          // This is a placeholder UI for now.
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[400]!),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(subtask.title)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
            if (task.tags != null && task.tags!.isNotEmpty) ...[
              _Section(
                title: 'Tags',
                icon: Icons.label_outline,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: task.tags!.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('#$tag'),
                    );
                  }).toList(),
                ),
              ),
            ],
            // Created date
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Created ${_formatDate(task.createdAt)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color:
                  theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? trailing;
  final Widget child;

  const _Section({
    required this.title,
    required this.icon,
    this.trailing,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              if (trailing != null) ...[
                const Spacer(),
                Text(
                  trailing!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
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
    final chipColor = color ?? theme.colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: chipColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: chipColor,
            ),
          ),
        ],
      ),
    );
  }
}