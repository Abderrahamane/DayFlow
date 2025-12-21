// lib/models/pomodoro_model.dart

enum PomodoroSessionType {
  work,
  shortBreak,
  longBreak;

  String get displayName {
    switch (this) {
      case PomodoroSessionType.work:
        return 'Work';
      case PomodoroSessionType.shortBreak:
        return 'Short Break';
      case PomodoroSessionType.longBreak:
        return 'Long Break';
    }
  }

  String get icon {
    switch (this) {
      case PomodoroSessionType.work:
        return '💼';
      case PomodoroSessionType.shortBreak:
        return '☕';
      case PomodoroSessionType.longBreak:
        return '🌴';
    }
  }

  int get defaultDurationMinutes {
    switch (this) {
      case PomodoroSessionType.work:
        return 25;
      case PomodoroSessionType.shortBreak:
        return 5;
      case PomodoroSessionType.longBreak:
        return 15;
    }
  }
}

class PomodoroSettings {
  final int workDuration; // in minutes
  final int shortBreakDuration;
  final int longBreakDuration;
  final int sessionsBeforeLongBreak;
  final bool autoStartBreaks;
  final bool autoStartWork;
  final bool soundEnabled;
  final bool vibrationEnabled;

  const PomodoroSettings({
    this.workDuration = 25,
    this.shortBreakDuration = 5,
    this.longBreakDuration = 15,
    this.sessionsBeforeLongBreak = 4,
    this.autoStartBreaks = false,
    this.autoStartWork = false,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
  });

  PomodoroSettings copyWith({
    int? workDuration,
    int? shortBreakDuration,
    int? longBreakDuration,
    int? sessionsBeforeLongBreak,
    bool? autoStartBreaks,
    bool? autoStartWork,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    return PomodoroSettings(
      workDuration: workDuration ?? this.workDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      sessionsBeforeLongBreak: sessionsBeforeLongBreak ?? this.sessionsBeforeLongBreak,
      autoStartBreaks: autoStartBreaks ?? this.autoStartBreaks,
      autoStartWork: autoStartWork ?? this.autoStartWork,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workDuration': workDuration,
      'shortBreakDuration': shortBreakDuration,
      'longBreakDuration': longBreakDuration,
      'sessionsBeforeLongBreak': sessionsBeforeLongBreak,
      'autoStartBreaks': autoStartBreaks,
      'autoStartWork': autoStartWork,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
    };
  }

  factory PomodoroSettings.fromJson(Map<String, dynamic> json) {
    return PomodoroSettings(
      workDuration: json['workDuration'] ?? 25,
      shortBreakDuration: json['shortBreakDuration'] ?? 5,
      longBreakDuration: json['longBreakDuration'] ?? 15,
      sessionsBeforeLongBreak: json['sessionsBeforeLongBreak'] ?? 4,
      autoStartBreaks: json['autoStartBreaks'] ?? false,
      autoStartWork: json['autoStartWork'] ?? false,
      soundEnabled: json['soundEnabled'] ?? true,
      vibrationEnabled: json['vibrationEnabled'] ?? true,
    );
  }
}

class PomodoroSession {
  final String id;
  final PomodoroSessionType type;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationMinutes;
  final bool completed;
  final String? linkedTaskId;
  final String? linkedTaskTitle;

  PomodoroSession({
    required this.id,
    required this.type,
    required this.startTime,
    this.endTime,
    required this.durationMinutes,
    this.completed = false,
    this.linkedTaskId,
    this.linkedTaskTitle,
  });

  int get actualDurationSeconds {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime).inSeconds;
  }

  PomodoroSession copyWith({
    String? id,
    PomodoroSessionType? type,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    bool? completed,
    String? linkedTaskId,
    String? linkedTaskTitle,
  }) {
    return PomodoroSession(
      id: id ?? this.id,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      completed: completed ?? this.completed,
      linkedTaskId: linkedTaskId ?? this.linkedTaskId,
      linkedTaskTitle: linkedTaskTitle ?? this.linkedTaskTitle,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'durationMinutes': durationMinutes,
      'completed': completed,
      'linkedTaskId': linkedTaskId,
      'linkedTaskTitle': linkedTaskTitle,
    };
  }

  factory PomodoroSession.fromJson(Map<String, dynamic> json) {
    return PomodoroSession(
      id: json['id'],
      type: PomodoroSessionType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => PomodoroSessionType.work,
      ),
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      durationMinutes: json['durationMinutes'] ?? 25,
      completed: json['completed'] ?? false,
      linkedTaskId: json['linkedTaskId'],
      linkedTaskTitle: json['linkedTaskTitle'],
    );
  }

  // Database serialization
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'type': type.index,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime?.millisecondsSinceEpoch,
      'durationMinutes': durationMinutes,
      'completed': completed ? 1 : 0,
      'linkedTaskId': linkedTaskId,
      'linkedTaskTitle': linkedTaskTitle,
    };
  }

  factory PomodoroSession.fromDatabase(Map<String, dynamic> row) {
    return PomodoroSession(
      id: row['id'] as String,
      type: PomodoroSessionType.values[row['type'] as int],
      startTime: DateTime.fromMillisecondsSinceEpoch(row['startTime'] as int),
      endTime: row['endTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(row['endTime'] as int)
          : null,
      durationMinutes: row['durationMinutes'] as int,
      completed: (row['completed'] as int) == 1,
      linkedTaskId: row['linkedTaskId'] as String?,
      linkedTaskTitle: row['linkedTaskTitle'] as String?,
    );
  }

  // Firestore serialization
  Map<String, dynamic> toFirestore() {
    return {
      'type': type.name,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'durationMinutes': durationMinutes,
      'completed': completed,
      'linkedTaskId': linkedTaskId,
      'linkedTaskTitle': linkedTaskTitle,
    };
  }

  factory PomodoroSession.fromFirestore(Map<String, dynamic> data, String docId) {
    return PomodoroSession(
      id: docId,
      type: PomodoroSessionType.values.firstWhere(
        (t) => t.name == data['type'],
        orElse: () => PomodoroSessionType.work,
      ),
      startTime: DateTime.parse(data['startTime']),
      endTime: data['endTime'] != null ? DateTime.parse(data['endTime']) : null,
      durationMinutes: data['durationMinutes'] ?? 25,
      completed: data['completed'] ?? false,
      linkedTaskId: data['linkedTaskId'],
      linkedTaskTitle: data['linkedTaskTitle'],
    );
  }
}

class PomodoroStats {
  final int totalWorkSessions;
  final int totalWorkMinutes;
  final int completedToday;
  final int currentStreak; // Consecutive days with at least one session
  final Map<DateTime, int> dailySessions; // Date -> count

  const PomodoroStats({
    this.totalWorkSessions = 0,
    this.totalWorkMinutes = 0,
    this.completedToday = 0,
    this.currentStreak = 0,
    this.dailySessions = const {},
  });

  PomodoroStats copyWith({
    int? totalWorkSessions,
    int? totalWorkMinutes,
    int? completedToday,
    int? currentStreak,
    Map<DateTime, int>? dailySessions,
  }) {
    return PomodoroStats(
      totalWorkSessions: totalWorkSessions ?? this.totalWorkSessions,
      totalWorkMinutes: totalWorkMinutes ?? this.totalWorkMinutes,
      completedToday: completedToday ?? this.completedToday,
      currentStreak: currentStreak ?? this.currentStreak,
      dailySessions: dailySessions ?? this.dailySessions,
    );
  }

  String get formattedTotalTime {
    final hours = totalWorkMinutes ~/ 60;
    final minutes = totalWorkMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}

