// lib/widgets/task_filter_bar.dart
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../utils/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getFilterLabel(context, currentFilter),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${l10n.sortedBy} ${_getSortLabel(context, currentSort)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: () => _showFilterSheet(context),
            icon: const Icon(Icons.tune),
            tooltip: l10n.filterAndSort,
          ),
        ],
      ),
    );
  }

  String _getFilterLabel(BuildContext context, TaskFilter filter) {
    final l10n = AppLocalizations.of(context);
    switch (filter) {
      case TaskFilter.all:
        return l10n.allTasks;
      case TaskFilter.pending:
        return l10n.pendingTasks;
      case TaskFilter.completed:
        return l10n.completedTasks;
      case TaskFilter.today:
        return l10n.todaysTasks;
      case TaskFilter.overdue:
        return l10n.overdueTasks;
    }
  }

  String _getSortLabel(BuildContext context, TaskSort sort) {
    final l10n = AppLocalizations.of(context);
    switch (sort) {
      case TaskSort.dateCreated:
        return l10n.sortDateCreated;
      case TaskSort.dueDate:
        return l10n.sortDueDate;
      case TaskSort.priority:
        return l10n.sortPriority;
      case TaskSort.alphabetical:
        return l10n.sortAlphabetical;
    }
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final theme = Theme.of(context);
        final l10n = AppLocalizations.of(context);
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.dividerColor.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.filterAndSort,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.filterBy,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _FilterChip(
                    label: l10n.allTasks,
                    count: totalTasks,
                    isSelected: currentFilter == TaskFilter.all,
                    onTap: () {
                      onFilterChanged(TaskFilter.all);
                      Navigator.pop(context);
                    },
                    theme: theme,
                  ),
                  _FilterChip(
                    label: l10n.pendingTasks,
                    count: pendingTasks,
                    isSelected: currentFilter == TaskFilter.pending,
                    onTap: () {
                      onFilterChanged(TaskFilter.pending);
                      Navigator.pop(context);
                    },
                    theme: theme,
                    color: Colors.orange.shade400,
                  ),
                  _FilterChip(
                    label: l10n.completedTasks,
                    count: completedTasks,
                    isSelected: currentFilter == TaskFilter.completed,
                    onTap: () {
                      onFilterChanged(TaskFilter.completed);
                      Navigator.pop(context);
                    },
                    theme: theme,
                    color: Colors.green.shade400,
                  ),
                  _FilterChip(
                    label: l10n.todaysTasks,
                    isSelected: currentFilter == TaskFilter.today,
                    onTap: () {
                      onFilterChanged(TaskFilter.today);
                      Navigator.pop(context);
                    },
                    theme: theme,
                    icon: Icons.today,
                  ),
                  _FilterChip(
                    label: l10n.overdueTasks,
                    count: overdueTasks,
                    isSelected: currentFilter == TaskFilter.overdue,
                    onTap: () {
                      onFilterChanged(TaskFilter.overdue);
                      Navigator.pop(context);
                    },
                    theme: theme,
                    color: Colors.red.shade400,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                l10n.sortBy,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: TaskSort.values.map((sort) {
                  return _FilterChip(
                    label: _getSortLabel(context, sort),
                    isSelected: currentSort == sort,
                    onTap: () {
                      onSortChanged(sort);
                      Navigator.pop(context);
                    },
                    theme: theme,
                    icon: Icons.sort,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
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
              : chipColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? chipColor : chipColor.withValues(alpha: 0.3),
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
                      ? Colors.white.withValues(alpha: 0.25)
                      : chipColor.withValues(alpha: 0.15),
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