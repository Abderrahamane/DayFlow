import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task_model.dart';
import '../utils/app_localizations.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggleComplete;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggleComplete,
    required this.onDelete,
  });

  String _dueDateLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (task.dueDate == null) return l10n.noDueDate;
    final formatted = DateFormat('MMM d • h:mm a').format(task.dueDate!);
    if (task.isOverdue) {
      return '${l10n.overduePrefix}$formatted';
    }
    if (task.isDueToday) {
      return '${l10n.dueTodayPrefix}${DateFormat('h:mm a').format(task.dueDate!)}';
    }
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onToggleComplete,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: task.isCompleted
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  border: Border.all(
                    color: task.isCompleted
                        ? Colors.transparent
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.12),
                  ),
                ),
                child: task.isCompleted
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : const SizedBox.shrink(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: task.isCompleted
                                ? theme.textTheme.bodySmall?.color?.withOpacity(0.6)
                                : null,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (task.isRecurring)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            Icons.repeat,
                            size: 16,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      if (task.tags != null && task.tags!.isNotEmpty)
                        Icon(
                          Icons.sell_outlined,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _dueDateLabel(context),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              color: theme.iconTheme.color,
            ),
          ],
        ),
      ),
    );
  }
}