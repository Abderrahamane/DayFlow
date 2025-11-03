// lib/widgets/habit_card.dart
import 'package:flutter/material.dart';
import '../models/habit_model.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onTap,
    required this.onToggle,
  });

  Color _getFlutterColor(habit_model.Color color) {
    return Color(color.value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final habitColor = _getFlutterColor(habit.color);
    final isCompleted = habit.isCompletedToday;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? habitColor.withOpacity(0.3)
              : theme.brightness == Brightness.light
              ? Colors.grey.shade200
              : Colors.grey.shade800,
          width: isCompleted ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: habitColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          habit.icon,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Title & Description
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            habit.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (habit.description != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              habit.description!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Checkbox
                    GestureDetector(
                      onTap: onToggle,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isCompleted ? habitColor : Colors.transparent,
                          border: Border.all(
                            color: isCompleted ? habitColor : Colors.grey.shade400,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: isCompleted
                            ? const Icon(
                          Icons.check,
                          size: 20,
                          color: Colors.white,
                        )
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Weekly Progress Dots
                Row(
                  children: [
                    Expanded(
                      child: _WeeklyProgress(
                        habit: habit,
                        color: habitColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Streak Badge
                    if (habit.currentStreak > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.local_fire_department,
                              size: 14,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${habit.currentStreak}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WeeklyProgress extends StatelessWidget {
  final Habit habit;
  final Color color;

  const _WeeklyProgress({
    required this.habit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return Row(
      children: List.generate(7, (index) {
        final date = startOfWeek.add(Duration(days: index));
        final dateKey = Habit._getDateKey(date);
        final isCompleted = habit.completionHistory[dateKey] ?? false;
        final isToday = date.day == now.day &&
            date.month == now.month &&
            date.year == now.year;

        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            height: 6,
            decoration: BoxDecoration(
              color: isCompleted
                  ? color
                  : color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(3),
              border: isToday
                  ? Border.all(color: color, width: 1)
                  : null,
            ),
          ),
        );
      }),
    );
  }
}