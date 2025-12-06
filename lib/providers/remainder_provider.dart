//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:dayflow/blocs/remainder/remainder_state.dart';
//import 'package:dayflow/models/remainder_model.dart';
//import 'package:dayflow/data/local/app_database.dart';

//class ReminderCubit extends Cubit<ReminderState> {
//  final DatabaseHelper _databaseHelper;

//  ReminderCubit(this._databaseHelper) : super(ReminderInitial());

  // Load all reminders (from todos with hasRemainder = true)
//  Future<void> loadReminders() async {
//    try {
//      emit(ReminderLoading());

//      // Get reminders from todos table
//      final todayReminders = await _databaseHelper.getTodayReminders();
//      final tomorrowReminders = await _databaseHelper.getTomorrowReminders();
//      final upcomingReminders = await _databaseHelper.getUpcomingReminders();

//      // Filter out today and tomorrow from upcoming
//      final filteredUpcoming = upcomingReminders.where((reminder) {
//        return !reminder.isToday && !reminder.isTomorrow;
//      }).toList();

//      emit(ReminderLoaded(
//        todayReminders: todayReminders,
//        tomorrowReminders: tomorrowReminders,
//        upcomingReminders: filteredUpcoming,
//      ));
//    } catch (e) {
//      emit(ReminderError('Failed to load reminders: $e'));
//    }
//  }

  // Add a standalone reminder
//  Future<void> addReminder(ReminderModel reminder) async {
//    try {
//      await _databaseHelper.insertReminder(reminder);
//      await loadReminders();
//    } catch (e) {
//      emit(ReminderError('Failed to add reminder: $e'));
//    }
//  }

  // Update reminder
//  Future<void> updateReminder(ReminderModel reminder) async {
//    try {
//      await _databaseHelper.updateReminder(reminder);
//      await loadReminders();
//    } catch (e) {
//      emit(ReminderError('Failed to update reminder: $e'));
//    }
//  }

  // Toggle reminder active state
//  Future<void> toggleReminderActive(ReminderModel reminder) async {
//    try {
//      final updatedReminder = reminder.copyWith(isActive: !reminder.isActive);
//      await _databaseHelper.updateReminder(updatedReminder);
//      await loadReminders();
//    } catch (e) {
//      emit(ReminderError('Failed to toggle reminder: $e'));
//    }
//  }

  // Delete reminder
//  Future<void> deleteReminder(ReminderModel reminder) async {
//    try {
//     if (reminder.id != null) {
//        await _databaseHelper.deleteReminder(reminder.id!);
//        await loadReminders();
//      }
//    } catch (e) {
//      emit(ReminderError('Failed to delete reminder: $e'));
//    }
//  }

  // Get current reminders
//  ReminderLoaded? getCurrentReminders() {
//    if (state is ReminderLoaded) {
//      return state as ReminderLoaded;
//    }
//    return null;
//  }

  // Refresh reminders (useful when returning from todo page)
//  Future<void> refresh() async {
//    await loadReminders();
//  }
//}