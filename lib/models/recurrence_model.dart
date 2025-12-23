// lib/models/recurrence_model.dart

enum RecurrenceType {
  none,
  daily,
  weekly,
  monthly,
  custom;

  String get displayName {
    switch (this) {
      case RecurrenceType.none:
        return 'No Repeat';
      case RecurrenceType.daily:
        return 'Daily';
      case RecurrenceType.weekly:
        return 'Weekly';
      case RecurrenceType.monthly:
        return 'Monthly';
      case RecurrenceType.custom:
        return 'Custom';
    }
  }

  String get icon {
    switch (this) {
      case RecurrenceType.none:
        return '⏹️';
      case RecurrenceType.daily:
        return '📅';
      case RecurrenceType.weekly:
        return '📆';
      case RecurrenceType.monthly:
        return '🗓️';
      case RecurrenceType.custom:
        return '⚙️';
    }
  }
}

class RecurrencePattern {
  final RecurrenceType type;
  final int interval; // Every X days/weeks/months
  final List<int>? daysOfWeek; // 1-7 (Monday-Sunday) for weekly
  final int? dayOfMonth; // 1-31 for monthly
  final DateTime? endDate; // Optional end date
  final int? maxOccurrences; // Optional max number of occurrences
  final int completedOccurrences; // Track completed count

  const RecurrencePattern({
    this.type = RecurrenceType.none,
    this.interval = 1,
    this.daysOfWeek,
    this.dayOfMonth,
    this.endDate,
    this.maxOccurrences,
    this.completedOccurrences = 0,
  });

  bool get isRecurring => type != RecurrenceType.none;

  bool get hasEnded {
    if (endDate != null && DateTime.now().isAfter(endDate!)) {
      return true;
    }
    if (maxOccurrences != null && completedOccurrences >= maxOccurrences!) {
      return true;
    }
    return false;
  }

  /// Calculate the next occurrence date from a given date
  DateTime? getNextOccurrence(DateTime fromDate) {
    if (hasEnded) return null;

    switch (type) {
      case RecurrenceType.none:
        return null;

      case RecurrenceType.daily:
        return fromDate.add(Duration(days: interval));

      case RecurrenceType.weekly:
        if (daysOfWeek == null || daysOfWeek!.isEmpty) {
          return fromDate.add(Duration(days: 7 * interval));
        }
        // Find next day of week
        DateTime next = fromDate.add(const Duration(days: 1));
        for (int i = 0; i < 7 * interval; i++) {
          if (daysOfWeek!.contains(next.weekday)) {
            return next;
          }
          next = next.add(const Duration(days: 1));
        }
        return next;

      case RecurrenceType.monthly:
        int targetDay = dayOfMonth ?? fromDate.day;
        DateTime next = DateTime(
          fromDate.year,
          fromDate.month + interval,
          1,
        );
        // Handle months with fewer days
        int lastDayOfMonth = DateTime(next.year, next.month + 1, 0).day;
        int actualDay = targetDay > lastDayOfMonth ? lastDayOfMonth : targetDay;
        return DateTime(next.year, next.month, actualDay);

      case RecurrenceType.custom:
        return fromDate.add(Duration(days: interval));
    }
  }

  RecurrencePattern copyWith({
    RecurrenceType? type,
    int? interval,
    List<int>? daysOfWeek,
    int? dayOfMonth,
    DateTime? endDate,
    int? maxOccurrences,
    int? completedOccurrences,
  }) {
    return RecurrencePattern(
      type: type ?? this.type,
      interval: interval ?? this.interval,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      endDate: endDate ?? this.endDate,
      maxOccurrences: maxOccurrences ?? this.maxOccurrences,
      completedOccurrences: completedOccurrences ?? this.completedOccurrences,
    );
  }

  RecurrencePattern incrementOccurrence() {
    return copyWith(completedOccurrences: completedOccurrences + 1);
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'interval': interval,
      'daysOfWeek': daysOfWeek,
      'dayOfMonth': dayOfMonth,
      'endDate': endDate?.toIso8601String(),
      'maxOccurrences': maxOccurrences,
      'completedOccurrences': completedOccurrences,
    };
  }

  factory RecurrencePattern.fromJson(Map<String, dynamic> json) {
    return RecurrencePattern(
      type: RecurrenceType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => RecurrenceType.none,
      ),
      interval: json['interval'] ?? 1,
      daysOfWeek: json['daysOfWeek'] != null
          ? List<int>.from(json['daysOfWeek'])
          : null,
      dayOfMonth: json['dayOfMonth'],
      endDate:
          json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      maxOccurrences: json['maxOccurrences'],
      completedOccurrences: json['completedOccurrences'] ?? 0,
    );
  }

  // Database serialization
  String toDatabase() {
    final parts = <String>[
      type.name,
      interval.toString(),
      daysOfWeek?.join(',') ?? '',
      dayOfMonth?.toString() ?? '',
      endDate?.millisecondsSinceEpoch.toString() ?? '',
      maxOccurrences?.toString() ?? '',
      completedOccurrences.toString(),
    ];
    return parts.join('|');
  }

  factory RecurrencePattern.fromDatabase(String data) {
    if (data.isEmpty) return const RecurrencePattern();

    final parts = data.split('|');
    if (parts.length < 7) return const RecurrencePattern();

    return RecurrencePattern(
      type: RecurrenceType.values.firstWhere(
        (t) => t.name == parts[0],
        orElse: () => RecurrenceType.none,
      ),
      interval: int.tryParse(parts[1]) ?? 1,
      daysOfWeek: parts[2].isNotEmpty
          ? parts[2].split(',').map((s) => int.parse(s)).toList()
          : null,
      dayOfMonth: parts[3].isNotEmpty ? int.tryParse(parts[3]) : null,
      endDate: parts[4].isNotEmpty
          ? DateTime.fromMillisecondsSinceEpoch(int.parse(parts[4]))
          : null,
      maxOccurrences: parts[5].isNotEmpty ? int.tryParse(parts[5]) : null,
      completedOccurrences: int.tryParse(parts[6]) ?? 0,
    );
  }

  /// Get human-readable description
  String get description {
    switch (type) {
      case RecurrenceType.none:
        return 'Does not repeat';
      case RecurrenceType.daily:
        if (interval == 1) return 'Repeats daily';
        return 'Repeats every $interval days';
      case RecurrenceType.weekly:
        if (daysOfWeek != null && daysOfWeek!.isNotEmpty) {
          final dayNames = daysOfWeek!.map(_getDayName).join(', ');
          return 'Repeats weekly on $dayNames';
        }
        if (interval == 1) return 'Repeats weekly';
        return 'Repeats every $interval weeks';
      case RecurrenceType.monthly:
        if (interval == 1) return 'Repeats monthly';
        return 'Repeats every $interval months';
      case RecurrenceType.custom:
        return 'Custom: every $interval days';
    }
  }

  String _getDayName(int day) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[day - 1];
  }
}

