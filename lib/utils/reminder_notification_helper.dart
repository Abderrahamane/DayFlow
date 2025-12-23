import 'package:dayflow/models/reminder_model.dart';
import 'package:dayflow/services/notification_servise.dart';
import 'package:flutter/material.dart';
import 'package:dayflow/data/repositories/notification_repository.dart';
import 'package:dayflow/models/notification_model.dart';
import 'package:uuid/uuid.dart';

class ReminderNotificationHelper {
  static final NotificationService _notificationService = NotificationService();

  /// Schedule a notification for a reminder
  static Future<void> scheduleReminderNotification(
      ReminderModel reminder, {NotificationRepository? notificationRepository}) async {
    debugPrint('📅 Attempting to schedule notification for: ${reminder.title}');
    
    // For task-based reminders (id == null), we need a unique notification ID
    // We'll use a hash of the title + date as the notification ID
    int notificationId;
    if (reminder.id == null) {
      // Generate a unique ID for task-based reminders
      // Using hashCode of title + date combination
      notificationId = '${reminder.title}_${reminder.date.toIso8601String()}'.hashCode.abs();
      debugPrint('📋 Task-based reminder, generated notification ID: $notificationId');
    } else {
      notificationId = reminder.id!;
    }

    if (!reminder.isActive) {
      debugPrint('⚠️ Reminder is not active, skipping notification');
      return;
    }

    if (!_notificationService.isInitialized) {
      debugPrint('❌ NotificationService not initialized!');
      return;
    }

    try {
      // Parse the time from reminder
      final scheduledDateTime = _parseReminderDateTime(reminder);

      // Check if the scheduled time is in the future
      if (scheduledDateTime.isBefore(DateTime.now())) {
        debugPrint('⚠️ Reminder time is in the past: ${reminder.title} at $scheduledDateTime');
        return;
      }

      // Schedule the notification
      await _notificationService.scheduleNotification(
        id: notificationId,
        title: reminder.title,
        body: reminder.description ?? 'Time for your reminder!',
        scheduledDate: scheduledDateTime,
        payload: reminder.id != null ? 'reminder_${reminder.id}' : 'task_reminder_$notificationId',
      );

      debugPrint('✅ Notification scheduled for ${reminder.title} at $scheduledDateTime');

      // Save to notification history if repository is provided
      if (notificationRepository != null) {
        await notificationRepository.saveNotification(AppNotification(
          id: 'reminder_history_$notificationId',
          title: reminder.title,
          body: reminder.description ?? 'Time for your reminder!',
          timestamp: scheduledDateTime,
        ));
      }
    } catch (e) {
      debugPrint('❌ Error scheduling notification: $e');
    }
  }

  /// Cancel a notification for a reminder
  static Future<void> cancelReminderNotification(int reminderId) async {
    try {
      await _notificationService.cancelNotification(reminderId);
      debugPrint('✅ Notification cancelled for reminder $reminderId');
    } catch (e) {
      debugPrint('❌ Error cancelling notification: $e');
    }
  }

  /// Cancel a notification for a task-based reminder using the reminder model
  static Future<void> cancelReminderNotificationByModel(ReminderModel reminder) async {
    try {
      int notificationId;
      if (reminder.id == null) {
        // Generate the same ID that was used for scheduling
        notificationId = '${reminder.title}_${reminder.date.toIso8601String()}'.hashCode.abs();
      } else {
        notificationId = reminder.id!;
      }
      
      await _notificationService.cancelNotification(notificationId);
      debugPrint('✅ Notification cancelled for ${reminder.title} (ID: $notificationId)');
    } catch (e) {
      debugPrint('❌ Error cancelling notification: $e');
    }
  }

  /// Parse reminder date and time into a DateTime object
  static DateTime _parseReminderDateTime(ReminderModel reminder) {
    // Parse the time string (format: "9:30 AM" or "2:15 PM")
    final timeParts = reminder.time.split(' ');
    final hourMinute = timeParts[0].split(':');
    int hour = int.parse(hourMinute[0]);
    final minute = int.parse(hourMinute[1]);

    // Handle AM/PM
    if (timeParts.length > 1) {
      final period = timeParts[1].toUpperCase();
      if (period == 'PM' && hour != 12) {
        hour += 12;
      } else if (period == 'AM' && hour == 12) {
        hour = 0;
      }
    }

    // Combine date and time
    final scheduledDateTime = DateTime(
      reminder.date.year,
      reminder.date.month,
      reminder.date.day,
      hour,
      minute,
    );

    debugPrint('🕐 Parsed time: ${reminder.time} -> $scheduledDateTime');
    return scheduledDateTime;
  }

  /// Check if a reminder should be scheduled (is in the future and active)
  static bool shouldScheduleReminder(ReminderModel reminder) {
    // Allow scheduling for both regular reminders and task-based reminders
    if (!reminder.isActive) {
      return false;
    }

    final scheduledDateTime = _parseReminderDateTime(reminder);
    return scheduledDateTime.isAfter(DateTime.now());
  }

  /// Reschedule all active reminders (useful after app restart)
  static Future<void> rescheduleAllReminders(
      List<ReminderModel> reminders, {NotificationRepository? notificationRepository}) async {
    debugPrint('🔄 Rescheduling ${reminders.length} reminders...');
    
    int scheduled = 0;
    for (final reminder in reminders) {
      if (shouldScheduleReminder(reminder)) {
        await scheduleReminderNotification(reminder, notificationRepository: notificationRepository);
        scheduled++;
      }
    }
    
    debugPrint('✅ Rescheduled $scheduled out of ${reminders.length} reminders');
  }

  /// Cancel all reminder notifications
  static Future<void> cancelAllReminderNotifications() async {
    await _notificationService.cancelAllNotifications();
    debugPrint('✅ All reminder notifications cancelled');
  }
}