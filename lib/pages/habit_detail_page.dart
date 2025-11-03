// lib/pages/habit_detail_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit_model.dart';
import '../services/habit_service.dart';

class HabitDetailPage extends StatelessWidget {
  final String habitId;

  const HabitDetailPage({super.key, required this.habitId});

  Color _getFlutterColor(habit_model.Color color) {
    return Color(color.value);
  }

  void _showDeleteDialog(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete habit?'),
        content: const Text(
          'This habit and all its history will be permanently deleted. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<HabitService>().deleteHabit(habit.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final habitService = context.watch<HabitService>();
    final habit = habitService.getHabitById(habitId);

    if (habit == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Habit Not Found')),
        body: const Center(child: Text('Habit not found')),
      );
    }

    final habitColor = _getFlutterColor(habit.color);

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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Edit feature coming soon!'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteDialog(context, habit),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              color: theme.scaffoldBackgroundColor,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: habitColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        habit.icon,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (habit.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            habit.description!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Stats Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _StatBox(
                      icon: Icons.local_fire_department,
                      value: '${habit.currentStreak}',
                      label: 'Current Streak',
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatBox(
                      icon: Icons.emoji_events,
                      value: '${habit.longestStreak}',
                      label: 'Best Streak',
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _StatBox(
                      icon: Icons.check_circle,
                      value: '${habit.totalCompletions}',
                      label: 'Total Days',
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatBox(
                      icon: Icons.trending_up,
                      value: '${habit.getCompletionRate(30).toInt()}%',
                      label: '30-Day Rate',
                      color: habitColor,
                    ),
                  ),
                ],
              ),
            ),
            // Chart Placeholder
            _Section(
              title: 'Progress Chart',
              icon: Icons.bar_chart,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: habitColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.show_chart,
                        size: 48,
                        color: habitColor.withOpacity(0.3),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Chart visualization\ncoming with fl_chart',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Monthly Calendar View
            _Section(
              title: 'This Month',
              icon: Icons.calendar_month,
              child: _MonthlyCalendar(habit: habit, color: habitColor),
            ),
            // Linked Tasks
            if (habit.linkedTaskTags.isNotEmpty)
              _Section(
                title: 'Linked Task Tags',
                icon: Icons.link,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: habit.linkedTaskTags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: habitColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '#$tag',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: habitColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatBox({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _Section({
    required this.title,
    required this.icon,
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
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _MonthlyCalendar extends StatelessWidget {
  final Habit habit;
  final Color color;

  const _MonthlyCalendar({
    required this.habit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final startWeekday = firstDayOfMonth.weekday;

    return Column(
      children: [
        // Weekday headers
        Row(
          children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        // Calendar grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemCount: daysInMonth + startWeekday - 1,
          itemBuilder: (context, index) {
            if (index < startWeekday - 1) {
              return const SizedBox();
            }

            final day = index - startWeekday + 2;
            final date = DateTime(now.year, now.month, day);
            final dateKey = Habit._getDateKey(date);
            final isCompleted = habit.completionHistory[dateKey] ?? false;
            final isToday = day == now.day;

            return Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isCompleted
                    ? color.withOpacity(0.2)
                    : Colors.transparent,
                border: Border.all(
                  color: isToday ? color : Colors.transparent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: isCompleted
                    ? Icon(Icons.check, size: 16, color: color)
                    : Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}