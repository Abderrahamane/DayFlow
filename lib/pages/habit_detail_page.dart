import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/habit/habit_bloc.dart';
import '../models/habit_model.dart' as habit_model;

class HabitDetailPage extends StatelessWidget {
  final String habitId;

  const HabitDetailPage({super.key, required this.habitId});

  Color _getFlutterColor(Color color) {
    return Color(color.value);
  }

  void _showDeleteDialog(BuildContext context, habit_model.Habit habit) {
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
              context.read<HabitBloc>().add(DeleteHabitEvent(habit.id));
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
    return BlocBuilder<HabitBloc, HabitState>(
      builder: (context, state) {
        final habit = state.habits.firstWhere(
          (h) => h.id == habitId,
          orElse: () => habit_model.Habit(
            id: '',
            name: '',
            icon: '📝',
            frequency: habit_model.HabitFrequency.daily,
            goalCount: 7,
            createdAt: DateTime.now(),
            color: Colors.indigo,
          ),
        );

        if (habit.id.isEmpty) {
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
                                  color:
                                      theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent activity',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: habit.completionHistory.entries.take(14).map(
                          (entry) {
                            final completed = entry.value;
                            return Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: completed
                                    ? habitColor.withOpacity(0.2)
                                    : theme.cardColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: completed
                                      ? habitColor
                                      : theme.dividerColor,
                                ),
                              ),
                              child: Icon(
                                completed ? Icons.check : Icons.close,
                                color: completed
                                    ? habitColor
                                    : theme.textTheme.bodyMedium?.color,
                                size: 18,
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.brightness == Brightness.light
              ? Colors.grey.shade200
              : Colors.grey.shade800,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
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
