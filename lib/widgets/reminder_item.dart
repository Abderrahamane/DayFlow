import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dayflow/blocs/reminder/reminder_bloc.dart';
import 'package:dayflow/blocs/reminder/reminder_event.dart';
import 'package:dayflow/models/reminder_model.dart';
import 'package:dayflow/utils/app_localizations.dart';

class ReminderItem extends StatelessWidget {
  final ReminderModel reminder;

  const ReminderItem({
    super.key,
    required this.reminder,
  });

  void _toggleActive(BuildContext context) {
    if (reminder.id != null) {
      context.read<ReminderBloc>().add(
            ToggleReminderActive(reminder),
          );
    }
  }

  void _showOptionsBottomSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final canEdit = reminder.id != null;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext sheetContext) {
        return BlocProvider.value(
          value: context.read<ReminderBloc>(),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                if (!canEdit) ...[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.grey.shade600),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.reminderInfoTaskLocked,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],

                if (canEdit) ...[
                  ListTile(
                    leading: const Icon(Icons.edit, color: Colors.blue),
                    title: Text(l10n.reminderEnterTitle),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _showEditDialog(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      reminder.isActive
                          ? Icons.notifications_off
                          : Icons.notifications_active,
                      color: Colors.orange,
                    ),
                    title: Text(
                      reminder.isActive
                          ? l10n.disableReminder
                          : l10n.enableReminder,
                    ),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _toggleActive(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: Text(l10n.deleteReminder),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _showDeleteConfirmation(context);
                    },
                  ),
                ] else ...[
                  ListTile(
                    leading: const Icon(Icons.close, color: Colors.grey),
                    title: Text(l10n.close),
                    onTap: () => Navigator.pop(sheetContext),
                  ),
                ],
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTime12Hour(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void _showEditDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final titleController = TextEditingController(text: reminder.title);
    final descriptionController =
        TextEditingController(text: reminder.description ?? '');
    TimeOfDay? selectedTime = _parseTimeOfDay(reminder.time);
    DateTime selectedDate = reminder.date;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                constraints: const BoxConstraints(maxWidth: 400),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.editReminder,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),

                      // Title
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: l10n.reminderTitle,
                          hintText: l10n.reminderEnterTitle,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.title),
                        ),
                        autofocus: true,
                      ),
                      const SizedBox(height: 16),

                      // Description
                      TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: l10n.reminderDescriptionOptional,
                          hintText: l10n.reminderEnterDescription,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.description),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),

                      // Date picker
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (date != null) {
                            setDialogState(() {
                              selectedDate = date;
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  color:
                                      Theme.of(context).colorScheme.primary),
                              const SizedBox(width: 12),
                              Text(
                                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Time picker
                      InkWell(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: selectedTime ?? TimeOfDay.now(),
                          );
                          if (time != null) {
                            setDialogState(() {
                              selectedTime = time;
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time,
                                  color:
                                      Theme.of(context).colorScheme.primary),
                              const SizedBox(width: 12),
                              Text(
                                selectedTime != null
                                    ? _formatTime12Hour(selectedTime!)
                                    : l10n.reminderSelectTime,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(),
                            child: Text(l10n.cancel),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              if (titleController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        l10n.reminderErrorTitleRequired),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                                return;
                              }

                              if (selectedTime == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text(l10n.reminderErrorTimeRequired),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                                return;
                              }

                              final updatedReminder = ReminderModel(
                                id: reminder.id,
                                title: titleController.text.trim(),
                                time: _formatTime12Hour(selectedTime!),
                                description:
                                    descriptionController.text.trim(),
                                date: selectedDate,
                                isActive: reminder.isActive,
                              );

                              context.read<ReminderBloc>().add(
                                    UpdateReminder(updatedReminder),
                                  );

                              Navigator.of(dialogContext).pop();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.reminderUpdated),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primary,
                                ),
                              );
                            },
                            child: Text(l10n.update),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(l10n.reminderDeleted),
          content: Text(
            '${l10n.reminderDeleteConfirmation} "${reminder.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (reminder.id != null) {
                  context.read<ReminderBloc>().add(
                        DeleteReminder(reminder.id!),
                      );
                  Navigator.of(dialogContext).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.reminderDeleted),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }

  TimeOfDay? _parseTimeOfDay(String timeString) {
    try {
      final parts = timeString.split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      if (parts.length > 1) {
        final period = parts[1].toUpperCase();
        if (period == 'PM' && hour != 12) {
          hour += 12;
        } else if (period == 'AM' && hour == 12) {
          hour = 0;
        }
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeData = _parseTime(reminder.time);

    return InkWell(
      onTap: () => _showOptionsBottomSheet(context),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimeDisplay(context, timeData),
            const SizedBox(width: 16),
            Expanded(
              child: _buildReminderContent(context),
            ),
            _buildToggleButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeDisplay(
      BuildContext context, Map<String, String> timeData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          timeData['time']!,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        if (timeData['period']!.isNotEmpty)
          Text(
            timeData['period']!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
      ],
    );
  }

  Widget _buildReminderContent(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                reminder.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),

            // “Task” label
            if (reminder.id == null) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.task_alt,
                      size: 12,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.task,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),

        if (reminder.description != null &&
            reminder.description!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            reminder.description!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildToggleButton(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (reminder.id == null) {
      return const SizedBox(width: 48);
    }

    return IconButton(
      icon: Icon(
        reminder.isActive
            ? Icons.notifications_active
            : Icons.notifications_off,
        color: reminder.isActive
            ? Theme.of(context).colorScheme.primary
            : Colors.grey,
      ),
      onPressed: () => _toggleActive(context),
      tooltip:
          reminder.isActive ? l10n.disableReminder : l10n.enableReminder,
    );
  }

  Map<String, String> _parseTime(String time) {
    String displayTime = time;
    String period = '';

    try {
      final parts = time.split(' ');
      if (parts.length == 2) {
        displayTime = parts[0];
        period = parts[1];
      }
    } catch (_) {}

    return {
      'time': displayTime,
      'period': period,
    };
  }
}
