// lib/widgets/task_filter_bar.dart
import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskFilterBar extends StatelessWidget {
  final TaskFilter currentFilter;
  final TaskSort currentSort;
  final Function(TaskFilter) onFilterChanged;
  final Function(TaskSort) onSortChanged;
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;
  final int overdueTasks;

  const TaskFilterBar({
    super.key,
    required this.currentFilter,
    required this.currentSort,
    required this.onFilterChanged,
    required this.onSortChanged,
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
    required this.overdueTasks,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  count: totalTasks,
                  isSelected: currentFilter == TaskFilter.all,
                  onTap: () => onFilterChanged(TaskFilter.all),
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Pending',
                  count: pendingTasks,
                  isSelected: currentFilter == TaskFilter.pending,
                  onTap: () => onFilterChanged(TaskFilter.pending),
                  theme: theme,
                  color: Colors.orange.shade400,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Completed',
                  count: completedTasks,
                  isSelected: currentFilter == TaskFilter.completed,
                  onTap: () => onFilterChanged(TaskFilter.completed),
                  theme: theme,
                  color: Colors.green.shade400,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Today',
                  isSelected: currentFilter == TaskFilter.today,
                  onTap: () => onFilterChanged(TaskFilter.today),
                  theme: theme,
                  icon: Icons.today,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Overdue',
                  count: overdueTasks,
                  isSelected: currentFilter == TaskFilter.overdue,
                  onTap: () => onFilterChanged(TaskFilter.overdue),
                  theme: theme,
                  color: Colors.red.shade400,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.sort,
                  size: 18,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: TaskSort.values.map((sort) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () => onSortChanged(sort),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: currentSort == sort
                                    ? theme.colorScheme.primary.withOpacity(0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: currentSort == sort
                                      ? theme.colorScheme.primary
                                      : theme.dividerColor,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                sort.displayName,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: currentSort == sort
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: currentSort == sort
                                      ? theme.colorScheme.primary
                                      : theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int? count;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;
  final Color? color;
  final IconData? icon;

  const _FilterChip({
    required this.label,
    this.count,
    required this.isSelected,
    required this.onTap,
    required this.theme,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? chipColor
              : chipColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? chipColor : chipColor.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : chipColor,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : chipColor,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.25)
                      : chipColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : chipColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}