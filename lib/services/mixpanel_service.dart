import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:flutter/foundation.dart';

class MixpanelService {
  static Mixpanel? _mixpanel;
  static MixpanelService? _instance;

  MixpanelService._();

  static MixpanelService get instance {
    _instance ??= MixpanelService._();
    return _instance!;
  }

  static Future<void> init(String token) async {
    try {
      _mixpanel = await Mixpanel.init(
        token,
        trackAutomaticEvents: true,
      );
      debugPrint('✅ Mixpanel initialized successfully');
    } catch (e) {
      debugPrint('❌ Mixpanel init error: $e');
    }
  }

  // GENERIC TRACKING
  void trackEvent(String name, [Map<String, dynamic>? props]) {
    if (_mixpanel == null) return;

    try {
      _mixpanel!.track(name, properties: props);
    } catch (e) {
      debugPrint('❌ Error tracking event: $e');
    }
  }

  // USER IDENTIFICATION
  void identifyUser(String userId, Map<String, dynamic>? properties) {
    if (_mixpanel == null) return;

    try {
      _mixpanel!.identify(userId);
      if (properties != null) {
        properties.forEach((key, value) {
          _mixpanel!.getPeople().set(key, value);
        });
      }
    } catch (e) {
      debugPrint('❌ Identify error: $e');
    }
  }

  void reset() {
    if (_mixpanel == null) return;
    _mixpanel!.reset();
  }

  // TASKS ANALYTICS (based on tasks table)
  void trackTaskCreated({
    required String id,
    required String title,
    required int priority,
    required int createdAt,
    int? dueDate,
    List<String>? tags,
  }) {
    trackEvent("Task Created", {
      "task_id": id,
      "title": title,
      "priority": priority,
      "due_date": dueDate,
      "tags": tags,
      "created_at": createdAt,
    });
  }

  void trackTaskUpdated({
    required String id,
    required String field,
    required dynamic newValue,
  }) {
    trackEvent("Task Updated", {
      "task_id": id,
      "updated_field": field,
      "new_value": newValue,
    });
  }

  void trackTaskCompleted(String id, String title) {
    trackEvent("Task Completed", {
      "task_id": id,
      "title": title,
      "timestamp": DateTime.now().toIso8601String(),
    });
  }

  void trackTaskDeleted(String id) {
    trackEvent("Task Deleted", {
      "task_id": id,
    });
  }

  // SUBTASKS ANALYTICS
  void trackSubtaskCreated({
    required String id,
    required String taskId,
    required String title,
  }) {
    trackEvent("Subtask Created", {
      "subtask_id": id,
      "task_id": taskId,
      "title": title,
    });
  }

  void trackSubtaskCompleted(String id, String taskId) {
    trackEvent("Subtask Completed", {
      "subtask_id": id,
      "task_id": taskId,
    });
  }

  void trackSubtaskDeleted(String id, String taskId) {
    trackEvent("Subtask Deleted", {
      "subtask_id": id,
      "task_id": taskId,
    });
  }

  // HABITS ANALYTICS
  void trackHabitCreated({
    required String habitId,
    required String name,
    required int frequency,
    required int createdAt,
  }) {
    trackEvent("Habit Created", {
      "habit_id": habitId,
      "name": name,
      "frequency": frequency,
      "created_at": createdAt,
    });
  }

  void trackHabitUpdated({
    required String habitId,
    required String field,
    required dynamic newValue,
  }) {
    trackEvent("Habit Updated", {
      "habit_id": habitId,
      "field": field,
      "new_value": newValue,
    });
  }

  void trackHabitDeleted(String habitId) {
    trackEvent("Habit Deleted", {
      "habit_id": habitId,
    });
  }

  // HABIT COMPLETION ANALYTICS
  void trackHabitCompletion({
    required String habitId,
    required String dateKey,
    required bool isCompleted,
  }) {
    trackEvent("Habit Completion", {
      "habit_id": habitId,
      "date": dateKey,
      "completed": isCompleted,
    });
  }

  void trackHabitStreakUpdated({
    required String habitId,
    required int streak,
  }) {
    trackEvent("Habit Streak Updated", {
      "habit_id": habitId,
      "streak": streak,
    });
  }

  // REMINDERS ANALYTICS
  void trackReminderCreated({
    required int id,
    required String title,
    required String date,
    required String time,
  }) {
    trackEvent("Reminder Created", {
      "reminder_id": id,
      "title": title,
      "date": date,
      "time": time,
    });
  }

  void trackReminderUpdated({
    required int id,
    required String field,
    required dynamic value,
  }) {
    trackEvent("Reminder Updated", {
      "reminder_id": id,
      "field": field,
      "new_value": value,
    });
  }

  void trackReminderDeleted(int id) {
    trackEvent("Reminder Deleted", {
      "reminder_id": id,
    });
  }

  void trackReminderTriggered(int id) {
    trackEvent("Reminder Triggered", {
      "reminder_id": id,
      "timestamp": DateTime.now().toIso8601String(),
    });
  }

  void trackReminderSnoozed(int id, int minutes) {
    trackEvent("Reminder Snoozed", {
      "reminder_id": id,
      "snooze_minutes": minutes,
    });
  }

  // UI PAGE VIEWS
  void trackPageView(String pageName) {
    trackEvent("Page Viewed", {
      "page_name": pageName,
      "timestamp": DateTime.now().toIso8601String(),
    });
  }
}
