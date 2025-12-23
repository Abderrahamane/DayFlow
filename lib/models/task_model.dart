// lib/models/task_model.dart
import 'recurrence_model.dart';

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
  final List<TaskAttachment>? attachments;
  final RecurrencePattern? recurrence;
  final String? parentTaskId; // For recurring task instances

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
    this.attachments,
    this.recurrence,
    this.parentTaskId,
  });

  bool get isRecurring => recurrence != null && recurrence!.isRecurring;

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
    List<TaskAttachment>? attachments,
    RecurrencePattern? recurrence,
    String? parentTaskId,
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
      attachments: attachments ?? this.attachments,
      recurrence: recurrence ?? this.recurrence,
      parentTaskId: parentTaskId ?? this.parentTaskId,
    );
  }

  /// Create next occurrence of this recurring task
  Task? createNextOccurrence(String newId) {
    if (!isRecurring || recurrence!.hasEnded) return null;

    final nextDueDate = recurrence!.getNextOccurrence(dueDate ?? DateTime.now());
    if (nextDueDate == null) return null;

    return Task(
      id: newId,
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
      dueDate: nextDueDate,
      priority: priority,
      tags: tags,
      subtasks: subtasks?.map((s) => s.copyWith(isCompleted: false)).toList(),
      recurrence: recurrence!.incrementOccurrence(),
      parentTaskId: parentTaskId ?? id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority.name,
      'tags': tags,
      'subtasks': subtasks?.map((s) => s.toJson()).toList(),
      'attachments': attachments?.map((a) => a.toJson()).toList(),
      'recurrence': recurrence?.toJson(),
      'parentTaskId': parentTaskId,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      priority: TaskPriority.values.firstWhere(
            (p) => p.name == json['priority'],
        orElse: () => TaskPriority.medium,
      ),
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      subtasks: json['subtasks'] != null
          ? (json['subtasks'] as List).map((s) => Subtask.fromJson(s)).toList()
          : null,
      attachments: json['attachments'] != null
          ? (json['attachments'] as List).map((a) => TaskAttachment.fromJson(a)).toList()
          : null,
      recurrence: json['recurrence'] != null
          ? RecurrencePattern.fromJson(json['recurrence'])
          : null,
      parentTaskId: json['parentTaskId'],
    );
  }

  // Firestore serialization
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority.name,
      'tags': tags,
      'subtasks': subtasks?.map((s) => s.toJson()).toList(),
      'attachments': attachments?.map((a) => a.toJson()).toList(),
      'recurrence': recurrence?.toJson(),
      'parentTaskId': parentTaskId,
    };
  }

  factory Task.fromFirestore(Map<String, dynamic> data, String docId) {
    return Task(
      id: docId,
      title: data['title'] ?? '',
      description: data['description'],
      isCompleted: data['isCompleted'] ?? false,
      createdAt: data['createdAt'] != null 
          ? DateTime.parse(data['createdAt']) 
          : DateTime.now(),
      dueDate: data['dueDate'] != null ? DateTime.parse(data['dueDate']) : null,
      priority: TaskPriority.values.firstWhere(
        (p) => p.name == data['priority'],
        orElse: () => TaskPriority.medium,
      ),
      tags: data['tags'] != null ? List<String>.from(data['tags']) : null,
      subtasks: data['subtasks'] != null
          ? (data['subtasks'] as List).map((s) => Subtask.fromJson(s)).toList()
          : null,
      attachments: data['attachments'] != null
          ? (data['attachments'] as List).map((a) => TaskAttachment.fromJson(a)).toList()
          : null,
      recurrence: data['recurrence'] != null
          ? RecurrencePattern.fromJson(data['recurrence'])
          : null,
      parentTaskId: data['parentTaskId'],
    );
  }

  int get completedSubtasks =>
      subtasks?.where((s) => s.isCompleted).length ?? 0;
  int get totalSubtasks => subtasks?.length ?? 0;
  bool get hasSubtasks => subtasks != null && subtasks!.isNotEmpty;
  bool get hasAttachments => attachments != null && attachments!.isNotEmpty;
  int get attachmentCount => attachments?.length ?? 0;

  int? get daysRemaining {
    if (dueDate == null) return null;
    final now = DateTime.now();
    final difference = dueDate!.difference(DateTime(now.year, now.month, now.day));
    return difference.inDays;
  }

  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return dueDate!.isBefore(DateTime.now());
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

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

enum TaskFilter {
  all,
  completed,
  pending,
  overdue,
  today;

  String get displayName {
    switch (this) {
      case TaskFilter.all:
        return 'All';
      case TaskFilter.completed:
        return 'Completed';
      case TaskFilter.pending:
        return 'Pending';
      case TaskFilter.overdue:
        return 'Overdue';
      case TaskFilter.today:
        return 'Today';
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
      case TaskSort.dateCreated:
        return 'Date Created';
      case TaskSort.dueDate:
        return 'Due Date';
      case TaskSort.priority:
        return 'Priority';
      case TaskSort.alphabetical:
        return 'Alphabetical';
    }
  }
}

/// Attachment type for task files
enum AttachmentType {
  image,
  document,
  other;

  String get displayName {
    switch (this) {
      case AttachmentType.image:
        return 'Image';
      case AttachmentType.document:
        return 'Document';
      case AttachmentType.other:
        return 'File';
    }
  }

  static AttachmentType fromMimeType(String mimeType) {
    if (mimeType.startsWith('image/')) return AttachmentType.image;
    if (mimeType.contains('pdf') ||
        mimeType.contains('document') ||
        mimeType.contains('text')) return AttachmentType.document;
    return AttachmentType.other;
  }
}

/// Task attachment model for files/images
class TaskAttachment {
  final String id;
  final String taskId;
  final String name;
  final String url;
  final AttachmentType type;
  final DateTime createdAt;

  TaskAttachment({
    required this.id,
    required this.taskId,
    required this.name,
    required this.url,
    required this.type,
    required this.createdAt,
  });

  TaskAttachment copyWith({
    String? id,
    String? taskId,
    String? name,
    String? url,
    AttachmentType? type,
    DateTime? createdAt,
  }) {
    return TaskAttachment(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      name: name ?? this.name,
      url: url ?? this.url,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskId': taskId,
      'name': name,
      'url': url,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TaskAttachment.fromJson(Map<String, dynamic> json) {
    return TaskAttachment(
      id: json['id'],
      taskId: json['taskId'],
      name: json['name'],
      url: json['url'],
      type: AttachmentType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => AttachmentType.other,
      ),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'taskId': taskId,
      'name': name,
      'url': url,
      'type': type.name,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory TaskAttachment.fromDatabase(Map<String, dynamic> row) {
    return TaskAttachment(
      id: row['id'] as String,
      taskId: row['taskId'] as String,
      name: row['name'] as String,
      url: row['url'] as String,
      type: AttachmentType.values.firstWhere(
        (t) => t.name == row['type'],
        orElse: () => AttachmentType.other,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(row['createdAt'] as int),
    );
  }
}

