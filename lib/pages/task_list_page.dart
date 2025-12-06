// lib/pages/tasks_list_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import 'task_edit_page.dart';
import '../theme/app_theme.dart';

class TasksListPage extends StatelessWidget {
  const TasksListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final theme = Theme.of(context);

    // This logic correctly uses the 'category' property from your model
    final workTasks = provider.tasks.where((task) => task.category == 'Work').toList();
    final personalTasks = provider.tasks.where((task) => task.category == 'Personal').toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Tasks'),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () { /* TODO: Implement Drawer or Menu */ },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.loadTasksFromDb(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Task',
        onPressed: () => _navigateToEditor(context),
        child: const Icon(Icons.add),
      ),
      body: _buildBody(context, provider, workTasks, personalTasks),
    );
  }

  // This is the main body of your page
  Widget _buildBody(BuildContext context, TaskProvider provider, List<Task> workTasks, List<Task> personalTasks) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        const SizedBox(height: 16),
        _DateHeader(),
        const SizedBox(height: 24),
        _ProgressHeader(tasks: provider.tasks),
        const SizedBox(height: 24),

        if (provider.isLoading)
          const Center(child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(),
          )),

        if (!provider.isLoading && provider.tasks.isEmpty)
          const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No tasks yet! Add one.', style: TextStyle(fontSize: 18)),
              )),

        if (!provider.isLoading && provider.tasks.isNotEmpty) ...[
          _CategoryHeader(title: 'Work'),
          const SizedBox(height: 12),
          if (workTasks.isNotEmpty)
            Column(
              children: workTasks.map((task) => TaskCard(task: task)).toList(),
            )
          else
            const _EmptyCategory(),
          
          const SizedBox(height: 24),

          _CategoryHeader(title: 'Personal'),
          const SizedBox(height: 12),
          if (personalTasks.isNotEmpty)
            Column(
              children: personalTasks.map((task) => TaskCard(task: task)).toList(),
            )
          else
            const _EmptyCategory(),
        ],

        const SizedBox(height: 80),
      ],
    );
  }

  // This is the function that opens the editor page
  void _navigateToEditor(BuildContext context, {Task? task}) async {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    final savedTask = await showModalBottomSheet<Task>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TaskEditPage(task: task),
    );
    if (savedTask != null) {
      if (task == null) {
        await provider.addTask(savedTask);
      } else {
        await provider.updateTask(savedTask);
      }
    }
  }
}


// =======================================================
//                ALL HELPER WIDGETS
// =======================================================

// --- The Task Card with the "Luxury" Colors ---
class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  Color _getIconBackgroundColor(String id) {
    final colors = [AppTheme.primaryLight, Colors.pink, Colors.orange, Colors.teal, AppTheme.secondaryLight];
    return colors[id.hashCode % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TaskProvider>();
    final theme = Theme.of(context);

    final completedColor = AppTheme.primaryLight;
    final pendingColor = theme.cardTheme.color;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        provider.deleteTask(task.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task deleted'), duration: Duration(seconds: 2)),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppTheme.errorColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: task.isCompleted ? completedColor : pendingColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (!task.isCompleted)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: null, // No navigation on tap
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: task.isCompleted ? Colors.white.withOpacity(0.3) : _getIconBackgroundColor(task.id),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.work_outline, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            color: task.isCompleted ? Colors.white : theme.textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.bold,
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            decorationColor: Colors.white,
                          ),
                        ),
                        if (task.dueDate != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Estimated time: 30 min', // Placeholder
                            style: TextStyle(
                              color: task.isCompleted ? Colors.white.withOpacity(0.8) : Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (!task.isCompleted)
                    IconButton(
                      icon: const Icon(Icons.check_box_outline_blank),
                      color: Colors.grey,
                      onPressed: () => provider.toggleTaskCompletion(task.id),
                      tooltip: 'Mark as Done',
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.check_box),
                      color: Colors.white,
                      onPressed: () => provider.toggleTaskCompletion(task.id),
                      tooltip: 'Mark as Not Done',
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- The Progress Header ---
class _ProgressHeader extends StatelessWidget {
  final List<Task> tasks;
  const _ProgressHeader({required this.tasks});

  @override
  Widget build(BuildContext context) {
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Progress', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tasks Completed', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
              Text('$completedTasks of $totalTasks', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.successColor),
            ),
          ),
        ],
      ),
    );
  }
}

// --- The Date Header ---
class _DateHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.chevron_left, color: Colors.grey),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Text('Dec 11th', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              Text('Monday', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.grey),
      ],
    );
  }
}

// --- The Category Header ---
class _CategoryHeader extends StatelessWidget {
  final String title;
  const _CategoryHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
      ],
    );
  }
}

// --- Placeholder for when a category is empty ---
class _EmptyCategory extends StatelessWidget {
  const _EmptyCategory();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Text(
        'No tasks in this category.',
        style: TextStyle(color: Colors.grey.shade500),
      ),
    );
  }
}