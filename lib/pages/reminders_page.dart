import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dayflow/blocs/reminder/reminder_bloc.dart';
import 'package:dayflow/blocs/reminder/reminder_event.dart';
import 'package:dayflow/blocs/reminder/reminder_state.dart';
import 'package:dayflow/widgets/add_reminder_dialog.dart';
import 'package:dayflow/widgets/reminder_day_section.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  @override
  void initState() {
    super.initState();
    context.read<ReminderBloc>().add(LoadReminders());
  }

  void _showAddReminderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: context.read<ReminderBloc>(),
          child: const AddReminderDialog(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddReminderDialog,
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<ReminderBloc, ReminderState>(
        builder: (context, state) {
          if (state is ReminderLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ReminderError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ReminderBloc>().add(LoadReminders());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ReminderLoaded) {
            if (!state.hasReminders) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Reminders',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add reminders or create tasks',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ReminderBloc>().add(RefreshReminders());
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  if (state.todayReminders.isNotEmpty) ...[
                    ReminderDaySection(
                      day: 'Today',
                      reminders: state.todayReminders,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (state.tomorrowReminders.isNotEmpty) ...[
                    ReminderDaySection(
                      day: 'Tomorrow',
                      reminders: state.tomorrowReminders,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (state.upcomingReminders.isNotEmpty) ...[
                    ReminderDaySection(
                      day: 'Upcoming',
                      reminders: state.upcomingReminders,
                    ),
                  ],
                ],
              ),
            );
          }

          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
    );
  }
}