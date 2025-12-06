import 'package:dayflow/models/reminder_model.dart';

abstract class ReminderState {}

class ReminderInitial extends ReminderState {}

class ReminderLoading extends ReminderState {}

class ReminderLoaded extends ReminderState {
  final List<ReminderModel> todayReminders;
  final List<ReminderModel> tomorrowReminders;
  final List<ReminderModel> upcomingReminders;

  ReminderLoaded({
    required this.todayReminders,
    required this.tomorrowReminders,
    required this.upcomingReminders,
  });

  // Get all reminders combined
  List<ReminderModel> get allReminders {
    return [...todayReminders, ...tomorrowReminders, ...upcomingReminders];
  }

  // Check if there are any reminders
  bool get hasReminders {
    return todayReminders.isNotEmpty ||
        tomorrowReminders.isNotEmpty ||
        upcomingReminders.isNotEmpty;
  }
}

class ReminderError extends ReminderState {
  final String message;

  ReminderError(this.message);
}