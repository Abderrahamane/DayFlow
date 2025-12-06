// lib/models/task_model.dart

import 'dart:convert';

class Task {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? dueDate;
  final TaskPriority priority;
  final List<String>? tags;
  final List<Subtask>? subtasks;

  // <<< --- THIS IS THE MISSING PROPERTY --- >>>
  final String category;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    required this.createdAt,
    this.dueDate,
    this.priority = TaskPriority.medium,
    this.tags,
    this.subtasks,
    // <<< ADDED TO THE CONSTRUCTOR (with a default 'Personal' value) >>>
    this.category = 'Personal',
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? dueDate,
    TaskPriority? priority,
    List<String>? tags,
    List<Subtask>? subtasks,
    // <<< ADDED TO THE 'copyWith' METHOD >>>
    String? category,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      subtasks: subtasks ?? this.subtasks,
      category: category ?? this.category,
    );
  }

  // --- GETTERS (These are all correct from your original file) ---
  int get completedSubtasks =>
      subtasks?.where((s) => s.isCompleted).length ?? 0;
  int get totalSubtasks => subtasks?.length ?? 0;
  bool get hasSubtasks => subtasks != null && subtasks!.isNotEmpty;

  int? get daysRemaining {
    if (dueDate == null) return null;
    final now = DateTime.now();
    final difference = dueDate!.difference(DateTime(now.year, now.month, now.day));
    return difference.inDays;
  }

  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return dueDate!.isBefore(today);
  }

  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }
}

class Subtask {
  final String id;
  final String title;
  final bool isCompleted;

  Subtask({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  Subtask copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return Subtask(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  // Used for saving subtasks as a JSON string in the database
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  // Used for loading subtasks from a JSON string from the database
  factory Subtask.fromJson(Map<String, dynamic> json) {
    return Subtask(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

enum TaskPriority {
  none,
  low,
  medium,
  high;

  String get displayName {
    switch (this) {
      case TaskPriority.none:
        return 'None';
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }
}

// These enums are not used in the local provider but are kept here
// as they are part of your model definition.
enum TaskFilter {
  all,
  completed,
  pending,
  overdue,
  today;

  String get displayName {
    switch (this) {
      case TaskFilter.all: return 'All';
      case TaskFilter.completed: return 'Completed';
      case TaskFilter.pending: return 'Pending';
      case TaskFilter.overdue: return 'Overdue';
      case TaskFilter.today: return 'Today';
    }
  }
}

enum TaskSort {
  dateCreated,
  dueDate,
  priority,
  alphabetical;

  String get displayName {
    switch (this) {
      case TaskSort.dateCreated: return 'Date Created';
      case TaskSort.dueDate: return 'Due Date';
      case TaskSort.priority: return 'Priority';
      case TaskSort.alphabetical: return 'Alphabetical';
    }
  }
}