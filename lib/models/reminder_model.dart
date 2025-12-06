import 'package:flutter/material.dart';
import 'package:dayflow/utils/app_localizations.dart';

class ReminderModel {
  final int? id;
  final String title;
  final String time;
  final String? description;
  final DateTime date;
  final bool isActive;

  ReminderModel({
    this.id,
    required this.title,
    required this.time,
    this.description,
    required this.date,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'time': time,
      'description': description,
      'date': date.toIso8601String(),
      'isActive': isActive ? 1 : 0,
    };
  }

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      time: map['time'] as String,
      description: map['description'] as String?,
      date: DateTime.parse(map['date'] as String),
      isActive: (map['isActive'] as int) == 1,
    );
  }

  factory ReminderModel.fromTodo(Map<String, dynamic> todo) {
    return ReminderModel(
      id: todo['id'] as int?,
      title: todo['title'] as String,
      time: todo['time'] as String,
      description: null,
      date: DateTime.parse(todo['date'] as String),
      isActive: (todo['hasRemainder'] as int) == 1,
    );
  }

  ReminderModel copyWith({
    int? id,
    String? title,
    String? time,
    String? description,
    DateTime? date,
    bool? isActive,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      description: description ?? this.description,
      date: date ?? this.date,
      isActive: isActive ?? this.isActive,
    );
  }

  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  ///Localized day text
  String dayTextLocalized(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (isToday) return l10n.remindersToday;
    if (isTomorrow) return l10n.remindersTomorrow;

    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference < 7) {
      final List<String> weekdays = [
        l10n.weekdayMonday,
        l10n.weekdayTuesday,
        l10n.weekdayWednesday,
        l10n.weekdayThursday,
        l10n.weekdayFriday,
        l10n.weekdaySaturday,
        l10n.weekdaySunday,
      ];

      return weekdays[date.weekday - 1];
    }

    // Localized fallback date
    return '${date.day}/${date.month}/${date.year}';
  }
}
