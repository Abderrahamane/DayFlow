import 'package:flutter/material.dart';

import 'package:dayflow/utils/date_utils.dart';
import 'package:dayflow/widgets/task_card.dart';
import 'package:dayflow/widgets/quote_card.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final List<Map<String, dynamic>> _tasks = [
    {
      'title': 'Morning Routine',
      'time': '10:00 AM',
      'completed': false,
      'hasReminder': false
    },
    {
      'title': 'Project Meeting',
      'time': '12:00 PM',
      'completed': false,
      'hasReminder': false
    },
    {
      'title': 'Lunch Break',
      'time': '2:00 PM',
      'completed': true,
      'hasReminder': false
    },
  ];

  String _formattedHeaderDate() => formattedHeaderDate();

  void _toggleComplete(int index) {
    setState(() => _tasks[index]['completed'] = !_tasks[index]['completed']);
  }

  void _showAddTaskDialog({int? editIndex}) {
    final isEditing = editIndex != null;
    final titleController = TextEditingController(
      text: isEditing ? _tasks[editIndex]['title'] : '',
    );
    TimeOfDay? selectedTime;
    bool hasReminder = isEditing ? _tasks[editIndex]['hasReminder'] : false;

    // Parse existing time if editing
    if (isEditing && _tasks[editIndex]['time'] != 'No time set') {
      try {
        final timeParts = _tasks[editIndex]['time'].split(':');
        final hour = int.parse(timeParts[0]);
        final minutePart = timeParts[1].split(' ');
        final minute = int.parse(minutePart[0]);
        final period = minutePart[1];

        final hour24 = period == 'PM' && hour != 12
            ? hour + 12
            : (period == 'AM' && hour == 12 ? 0 : hour);

        selectedTime = TimeOfDay(hour: hour24, minute: minute);
      } catch (e) {
        // If parsing fails, leave selectedTime as null
      }
    }

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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEditing ? 'Edit Task' : 'Create New Task',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Task Title',
                        hintText: 'Enter task name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.task_alt),
                      ),
                      autofocus: true,
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
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
                            Icon(
                              Icons.access_time,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              selectedTime != null
                                  ? selectedTime!.format(context)
                                  : 'Select Time',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CheckboxListTile(
                        title: const Text('Set Reminder'),
                        subtitle: const Text('Get notified at task time'),
                        value: hasReminder,
                        onChanged: (value) {
                          setDialogState(() {
                            hasReminder = value ?? false;
                          });
                        },
                        secondary: Icon(
                          Icons.notifications_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            if (titleController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a task title'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              return;
                            }

                            final timeString = selectedTime != null
                                ? selectedTime!.format(context)
                                : 'No time set';

                            setState(() {
                              if (isEditing) {
                                _tasks[editIndex] = {
                                  'title': titleController.text.trim(),
                                  'time': timeString,
                                  'completed': _tasks[editIndex]['completed'],
                                  'hasReminder': hasReminder,
                                };
                              } else {
                                _tasks.add({
                                  'title': titleController.text.trim(),
                                  'time': timeString,
                                  'completed': false,
                                  'hasReminder': hasReminder,
                                });
                              }
                            });

                            Navigator.of(dialogContext).pop();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isEditing
                                      ? 'Task updated successfully!'
                                      : (hasReminder
                                          ? 'Task added with reminder!'
                                          : 'Task added successfully!'),
                                ),
                                duration: const Duration(seconds: 2),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(isEditing ? 'Update Task' : 'Add Task'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      _formattedHeaderDate(),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color:
                            theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      "Today's List",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                children: [
                  const SizedBox(height: 8),
                  ...List.generate(
                    _tasks.length,
                    (i) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TaskCard(
                        task: _tasks[i],
                        onTap: () => _showAddTaskDialog(editIndex: i),
                        onToggleComplete: () => _toggleComplete(i),
                        onDelete: () {
                          setState(() {
                            _tasks.removeAt(i);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Task deleted'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const QuoteCard(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: primary,
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
