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

  // Convert ReminderModel to Map for database
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

  // Create ReminderModel from Map
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

  // Create ReminderModel from TodoModel
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

  // Create a copy with updated fields
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

  // Check if reminder is for today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Check if reminder is for tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  // Get formatted day text
  String get dayText {
    if (isToday) return 'Today';
    if (isTomorrow) return 'Tomorrow';
    
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference < 7) {
      final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      return weekdays[date.weekday - 1];
    }
    
    return '${date.day}/${date.month}/${date.year}';
  }
}