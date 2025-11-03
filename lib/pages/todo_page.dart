// lib/pages/todo_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';
import '../widgets/task_card.dart';
import '../widgets/task_filter_bar.dart';
import 'task_detail_page.dart';
import 'task_edit_page.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskService(),
      child: const _TodoPageContent(),
    );
  }
}

class _TodoPageContent extends StatelessWidget {
  const _TodoPageContent();

  void _showDeleteConfirmation(BuildContext context, Task task) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TaskService>().deleteTask(task.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Task deleted'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddEditTask(BuildContext context, {Task? task}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskEditPage(task: task),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskService = context.watch<TaskService>();
    final tasks = taskService.tasks;

    return Scaffold(
      body: Column(
        children: [
          TaskFilterBar(
            currentFilter: taskService.currentFilter,
            currentSort: taskService.currentSort,
            onFilterChanged: (filter) => taskService.setFilter(filter),
            onSortChanged: (sort) => taskService.setSort(sort),
            totalTasks: taskService.totalTasks,
            completedTasks: taskService.completedTasks,
            pendingTasks: taskService.pendingTasks,
            overdueTasks: taskService.overdueTasks,
          ),
          Expanded(
            child: tasks.isEmpty
                ? _EmptyState(
              filter: taskService.currentFilter,
              theme: theme,
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskCard(
                  task: task,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider.value(
                          value: taskService,
                          child: TaskDetailPage(taskId: task.id),
                        ),
                      ),
                    );
                  },
                  onToggle: () => taskService.toggleTaskCompletion(task.id),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditTask(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final TaskFilter filter;
  final ThemeData theme;

  const _EmptyState({
    required this.filter,
    required this.theme,
  });

  String _getEmptyMessage() {
    switch (filter) {
      case TaskFilter.completed:
        return 'No completed tasks yet';
      case TaskFilter.pending:
        return 'No pending tasks';
      case TaskFilter.overdue:
        return 'No overdue tasks';
      case TaskFilter.today:
        return 'No tasks due today';
      case TaskFilter.all:
        return 'No tasks yet';
    }
  }

  String _getEmptySubMessage() {
    switch (filter) {
      case TaskFilter.completed:
        return 'Complete some tasks to see them here';
      case TaskFilter.pending:
        return 'All tasks are completed!';
      case TaskFilter.overdue:
        return 'You\'re all caught up!';
      case TaskFilter.today:
        return 'No tasks scheduled for today';
      case TaskFilter.all:
        return 'Tap + to create your first task';
    }
  }

  IconData _getEmptyIcon() {
    switch (filter) {
      case TaskFilter.completed:
        return Icons.check_circle_outline;
      case TaskFilter.pending:
        return Icons.celebration_outlined;
      case TaskFilter.overdue:
        return Icons.thumb_up_outlined;
      case TaskFilter.today:
        return Icons.today_outlined;
      case TaskFilter.all:
        return Icons.task_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getEmptyIcon(),
              size: 60,
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _getEmptyMessage(),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getEmptySubMessage(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}