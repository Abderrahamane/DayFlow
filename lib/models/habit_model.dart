// lib/models/habit_model.dart
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String name;
  final String? description;
  final String icon; // emoji or icon name
  final HabitFrequency frequency;
  final int goalCount; // e.g., 5 times per week
  final List<String> linkedTaskTags; // Auto-complete from tasks with these tags
  final Map<String, bool> completionHistory; // date string -> completed
  final DateTime createdAt;
  final Color color;

  Habit({
    required this.id,
    required this.name,
    this.description,
    required this.icon,
    required this.frequency,
    required this.goalCount,
    this.linkedTaskTags = const [],
    Map<String, bool>? completionHistory,
    required this.createdAt,
    required this.color,
  }) : completionHistory = completionHistory ?? {};

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    HabitFrequency? frequency,
    int? goalCount,
    List<String>? linkedTaskTags,
    Map<String, bool>? completionHistory,
    DateTime? createdAt,
    Color? color,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      frequency: frequency ?? this.frequency,
      goalCount: goalCount ?? this.goalCount,
      linkedTaskTags: linkedTaskTags ?? this.linkedTaskTags,
      completionHistory: completionHistory ?? this.completionHistory,
      createdAt: createdAt ?? this.createdAt,
      color: color ?? this.color,
    );
  }

  // Check if completed today
  bool get isCompletedToday {
    final today = getDateKey(DateTime.now());
    return completionHistory[today] ?? false;
  }

  // Calculate current streak
  int get currentStreak {
    int streak = 0;
    DateTime date = DateTime.now();

    while (true) {
      final dateKey = getDateKey(date);
      if (completionHistory[dateKey] == true) {
        streak++;
        date = date.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  // Calculate longest streak
  int get longestStreak {
    if (completionHistory.isEmpty) return 0;

    final sortedDates = completionHistory.keys.toList()..sort();
    int maxStreak = 0;
    int currentStreak = 0;
    DateTime? lastDate;

    for (final dateKey in sortedDates) {
      if (completionHistory[dateKey] != true) continue;

      final date = DateTime.parse(dateKey);
      if (lastDate == null || date.difference(lastDate).inDays == 1) {
        currentStreak++;
        maxStreak = currentStreak > maxStreak ? currentStreak : maxStreak;
      } else {
        currentStreak = 1;
      }
      lastDate = date;
    }

    return maxStreak;
  }

  // Get completion rate for last N days
  double getCompletionRate(int days) {
    int completed = 0;
    final now = DateTime.now();

    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: i));
      final dateKey = getDateKey(date);
      if (completionHistory[dateKey] == true) {
        completed++;
      }
    }

    return days > 0 ? (completed / days) * 100 : 0;
  }

  // Get this week's progress
  int get thisWeekCompletions {
    int count = 0;
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      final dateKey = getDateKey(date);
      if (completionHistory[dateKey] == true) {
        count++;
      }
    }

    return count;
  }

  // Total completions all time
  int get totalCompletions {
    return completionHistory.values.where((completed) => completed).length;
  }

  // Helper to get date key
  static String getDateKey(DateTime date) => DateFormat('yyyy-MM-dd').format(date);


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'frequency': frequency.name,
      'goalCount': goalCount,
      'linkedTaskTags': linkedTaskTags,
      'completionHistory': completionHistory,
      'createdAt': createdAt.toIso8601String(),
      'color': color.value,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      frequency: HabitFrequency.values.firstWhere(
            (f) => f.name == json['frequency'],
        orElse: () => HabitFrequency.daily,
      ),
      goalCount: json['goalCount'],
      linkedTaskTags: List<String>.from(json['linkedTaskTags'] ?? []),
      completionHistory: Map<String, bool>.from(json['completionHistory'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      color: Color(json['color']),
    );
  }

  // Firestore serialization
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'icon': icon,
      'frequency': frequency.name,
      'goalCount': goalCount,
      'linkedTaskTags': linkedTaskTags,
      'completionHistory': completionHistory,
      'createdAt': createdAt.toIso8601String(),
      'colorValue': color.value,
    };
  }

  factory Habit.fromFirestore(Map<String, dynamic> data, String docId) {
    return Habit(
      id: docId,
      name: data['name'] ?? '',
      description: data['description'],
      icon: data['icon'] ?? '📝',
      frequency: HabitFrequency.values.firstWhere(
        (f) => f.name == data['frequency'],
        orElse: () => HabitFrequency.daily,
      ),
      goalCount: data['goalCount'] ?? 1,
      linkedTaskTags: data['linkedTaskTags'] != null
          ? List<String>.from(data['linkedTaskTags'])
          : [],
      completionHistory: data['completionHistory'] != null
          ? Map<String, bool>.from(data['completionHistory'])
          : {},
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
      color: Color(data['colorValue'] ?? 0xFF2196F3),
    );
  }
}

enum HabitFrequency {
  daily,
  weekly,
  custom;

  String get displayName {
    switch (this) {
      case HabitFrequency.daily:
        return 'Daily';
      case HabitFrequency.weekly:
        return 'Weekly';
      case HabitFrequency.custom:
        return 'Custom';
    }
  }
}
