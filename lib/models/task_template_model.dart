// lib/models/task_template_model.dart
import 'task_model.dart';

class TaskTemplate {
  final String id;
  final String name;
  final String? description;
  final String taskTitle;
  final String? taskDescription;
  final TaskPriority priority;
  final List<String>? tags;
  final List<SubtaskTemplate>? subtasks;
  final String? category;
  final String? icon;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int usageCount;
  final bool isShared;

  TaskTemplate({
    required this.id,
    required this.name,
    this.description,
    required this.taskTitle,
    this.taskDescription,
    this.priority = TaskPriority.medium,
    this.tags,
    this.subtasks,
    this.category,
    this.icon,
    required this.createdAt,
    this.updatedAt,
    this.usageCount = 0,
    this.isShared = false,
  });

  TaskTemplate copyWith({
    String? id,
    String? name,
    String? description,
    String? taskTitle,
    String? taskDescription,
    TaskPriority? priority,
    List<String>? tags,
    List<SubtaskTemplate>? subtasks,
    String? category,
    String? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? usageCount,
    bool? isShared,
  }) {
    return TaskTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      taskTitle: taskTitle ?? this.taskTitle,
      taskDescription: taskDescription ?? this.taskDescription,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      subtasks: subtasks ?? this.subtasks,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      usageCount: usageCount ?? this.usageCount,
      isShared: isShared ?? this.isShared,
    );
  }

  /// Convert template to a Task (for quick creation)
  Task toTask({
    required String taskId,
    DateTime? dueDate,
  }) {
    return Task(
      id: taskId,
      title: taskTitle,
      description: taskDescription,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      priority: priority,
      tags: tags,
      subtasks: subtasks?.map((s) => Subtask(
        id: '${DateTime.now().millisecondsSinceEpoch}_${s.title.hashCode}',
        title: s.title,
        isCompleted: false,
      )).toList(),
    );
  }

  /// Create template from existing task
  factory TaskTemplate.fromTask({
    required String templateId,
    required String templateName,
    required Task task,
    String? description,
    String? category,
    String? icon,
  }) {
    return TaskTemplate(
      id: templateId,
      name: templateName,
      description: description,
      taskTitle: task.title,
      taskDescription: task.description,
      priority: task.priority,
      tags: task.tags,
      subtasks: task.subtasks?.map((s) => SubtaskTemplate(title: s.title)).toList(),
      category: category,
      icon: icon,
      createdAt: DateTime.now(),
      usageCount: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'taskTitle': taskTitle,
      'taskDescription': taskDescription,
      'priority': priority.name,
      'tags': tags,
      'subtasks': subtasks?.map((s) => s.toJson()).toList(),
      'category': category,
      'icon': icon,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'usageCount': usageCount,
      'isShared': isShared,
    };
  }

  factory TaskTemplate.fromJson(Map<String, dynamic> json) {
    return TaskTemplate(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'],
      taskTitle: json['taskTitle'] ?? '',
      taskDescription: json['taskDescription'],
      priority: TaskPriority.values.firstWhere(
        (p) => p.name == json['priority'],
        orElse: () => TaskPriority.medium,
      ),
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      subtasks: json['subtasks'] != null
          ? (json['subtasks'] as List)
              .map((s) => SubtaskTemplate.fromJson(s))
              .toList()
          : null,
      category: json['category'],
      icon: json['icon'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      usageCount: json['usageCount'] ?? 0,
      isShared: json['isShared'] ?? false,
    );
  }

  // Database serialization
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'taskTitle': taskTitle,
      'taskDescription': taskDescription,
      'priority': priority.index,
      'tagsJson': tags?.join(','),
      'subtasksJson': subtasks != null
          ? subtasks!.map((s) => s.title).join('|||')
          : null,
      'category': category,
      'icon': icon,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'usageCount': usageCount,
      'isShared': isShared ? 1 : 0,
    };
  }

  factory TaskTemplate.fromDatabase(Map<String, dynamic> row) {
    final tagsString = row['tagsJson'] as String?;
    final subtasksString = row['subtasksJson'] as String?;

    return TaskTemplate(
      id: row['id'] as String,
      name: row['name'] as String,
      description: row['description'] as String?,
      taskTitle: row['taskTitle'] as String,
      taskDescription: row['taskDescription'] as String?,
      priority: TaskPriority.values[row['priority'] as int],
      tags: tagsString != null && tagsString.isNotEmpty
          ? tagsString.split(',')
          : null,
      subtasks: subtasksString != null && subtasksString.isNotEmpty
          ? subtasksString
              .split('|||')
              .map((title) => SubtaskTemplate(title: title))
              .toList()
          : null,
      category: row['category'] as String?,
      icon: row['icon'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row['createdAt'] as int),
      updatedAt: row['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(row['updatedAt'] as int)
          : null,
      usageCount: row['usageCount'] as int? ?? 0,
      isShared: (row['isShared'] as int? ?? 0) == 1,
    );
  }
}

class SubtaskTemplate {
  final String title;

  SubtaskTemplate({required this.title});

  Map<String, dynamic> toJson() => {'title': title};

  factory SubtaskTemplate.fromJson(Map<String, dynamic> json) {
    return SubtaskTemplate(title: json['title'] ?? '');
  }
}

/// Predefined template categories
enum TemplateCategory {
  work,
  personal,
  health,
  shopping,
  project,
  meeting,
  other;

  String get displayName {
    switch (this) {
      case TemplateCategory.work:
        return 'Work';
      case TemplateCategory.personal:
        return 'Personal';
      case TemplateCategory.health:
        return 'Health';
      case TemplateCategory.shopping:
        return 'Shopping';
      case TemplateCategory.project:
        return 'Project';
      case TemplateCategory.meeting:
        return 'Meeting';
      case TemplateCategory.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case TemplateCategory.work:
        return '💼';
      case TemplateCategory.personal:
        return '👤';
      case TemplateCategory.health:
        return '🏃';
      case TemplateCategory.shopping:
        return '🛒';
      case TemplateCategory.project:
        return '📁';
      case TemplateCategory.meeting:
        return '📅';
      case TemplateCategory.other:
        return '📝';
    }
  }
}

