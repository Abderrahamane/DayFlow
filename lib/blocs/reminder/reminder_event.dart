import 'package:dayflow/models/reminder_model.dart';

abstract class ReminderEvent {}

class LoadReminders extends ReminderEvent {}

class RefreshReminders extends ReminderEvent {}

class AddReminder extends ReminderEvent {
  final ReminderModel reminder;

  AddReminder(this.reminder);
}

class UpdateReminder extends ReminderEvent {
  final ReminderModel reminder;

  UpdateReminder(this.reminder);
}

class DeleteReminder extends ReminderEvent {
  final int id;

  DeleteReminder(this.id);
}

class ToggleReminderActive extends ReminderEvent {
  final ReminderModel reminder;

  ToggleReminderActive(this.reminder);
}