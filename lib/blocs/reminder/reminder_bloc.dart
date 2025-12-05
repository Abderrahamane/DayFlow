import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dayflow/blocs/reminder/reminder_event.dart';
import 'package:dayflow/blocs/reminder/reminder_state.dart';
import 'package:dayflow/data/repositories/reminder_repository.dart';
import 'package:dayflow/models/reminder_model.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final ReminderRepository repository;

  ReminderBloc(this.repository) : super(ReminderInitial()) {
    on<LoadReminders>(_onLoadReminders);
    on<RefreshReminders>(_onRefreshReminders);
    on<AddReminder>(_onAddReminder);
    on<UpdateReminder>(_onUpdateReminder);
    on<DeleteReminder>(_onDeleteReminder);
    on<ToggleReminderActive>(_onToggleReminderActive);
  }

  Future<void> _onLoadReminders(
    LoadReminders event,
    Emitter<ReminderState> emit,
  ) async {
    emit(ReminderLoading());
    try {
      final reminders = await repository.getAllReminders();
      emit(_groupRemindersByDate(reminders));
    } catch (e) {
      emit(ReminderError('Failed to load reminders: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshReminders(
    RefreshReminders event,
    Emitter<ReminderState> emit,
  ) async {
    try {
      final reminders = await repository.getAllReminders();
      emit(_groupRemindersByDate(reminders));
    } catch (e) {
      emit(ReminderError('Failed to refresh reminders: ${e.toString()}'));
    }
  }

  Future<void> _onAddReminder(
    AddReminder event,
    Emitter<ReminderState> emit,
    ) async {
      try {
        // Insert the reminder into the database
        await repository.insertReminder(event.reminder);

        // Fetch all reminders and emit updated state
        final reminders = await repository.getAllReminders();
        emit(_groupRemindersByDate(reminders));
    } catch (e) {
    emit(ReminderError('Failed to add reminder: ${e.toString()}'));
  }
}


  Future<void> _onUpdateReminder(
    UpdateReminder event,
    Emitter<ReminderState> emit,
  ) async {
    try {
      await repository.updateReminder(event.reminder);

      // No notification updates now

      final reminders = await repository.getAllReminders();
      emit(_groupRemindersByDate(reminders));
    } catch (e) {
      emit(ReminderError('Failed to update reminder: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteReminder(
    DeleteReminder event,
    Emitter<ReminderState> emit,
  ) async {
    try {
      await repository.deleteReminder(event.id);

      // No notification cancel

      final reminders = await repository.getAllReminders();
      emit(_groupRemindersByDate(reminders));
    } catch (e) {
      emit(ReminderError('Failed to delete reminder: ${e.toString()}'));
    }
  }

  Future<void> _onToggleReminderActive(
    ToggleReminderActive event,
    Emitter<ReminderState> emit,
  ) async {
    try {
      final updatedReminder = event.reminder.copyWith(
        isActive: !event.reminder.isActive,
      );

      await repository.updateReminder(updatedReminder);

      // No scheduling or canceling notifications

      final reminders = await repository.getAllReminders();
      emit(_groupRemindersByDate(reminders));
    } catch (e) {
      emit(ReminderError('Failed to toggle reminder: ${e.toString()}'));
    }
  }

  ReminderLoaded _groupRemindersByDate(List<ReminderModel> reminders) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final todayReminders = <ReminderModel>[];
    final tomorrowReminders = <ReminderModel>[];
    final upcomingReminders = <ReminderModel>[];

    for (final reminder in reminders) {
      final reminderDate = DateTime(
        reminder.date.year,
        reminder.date.month,
        reminder.date.day,
      );

      if (reminderDate == today) {
        todayReminders.add(reminder);
      } else if (reminderDate == tomorrow) {
        tomorrowReminders.add(reminder);
      } else if (reminderDate.isAfter(tomorrow)) {
        upcomingReminders.add(reminder);
      }
    }

    todayReminders.sort((a, b) => a.time.compareTo(b.time));
    tomorrowReminders.sort((a, b) => a.time.compareTo(b.time));
    upcomingReminders.sort((a, b) => a.date.compareTo(b.date));

    return ReminderLoaded(
      todayReminders: todayReminders,
      tomorrowReminders: tomorrowReminders,
      upcomingReminders: upcomingReminders,
    );
  }
}
