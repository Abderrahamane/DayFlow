part of 'pomodoro_bloc.dart';

enum PomodoroStatus {
  initial,
  loading,
  idle,
  running,
  paused,
  completed,
  ringing,
}

class PomodoroState extends Equatable {
  final PomodoroStatus status;
  final PomodoroSession? currentSession;
  final int remainingSeconds;
  final int completedWorkSessions;
  final List<PomodoroSession> todaySessions;
  final List<PomodoroSession> sessionHistory;
  final PomodoroSettings settings;
  final PomodoroStats stats;
  final String? linkedTaskId;
  final String? linkedTaskTitle;

  const PomodoroState({
    this.status = PomodoroStatus.initial,
    this.currentSession,
    this.remainingSeconds = 0,
    this.completedWorkSessions = 0,
    this.todaySessions = const [],
    this.sessionHistory = const [],
    this.settings = const PomodoroSettings(),
    this.stats = const PomodoroStats(),
    this.linkedTaskId,
    this.linkedTaskTitle,
  });

  bool get isRunning => status == PomodoroStatus.running;
  bool get isPaused => status == PomodoroStatus.paused;
  bool get isRinging => status == PomodoroStatus.ringing;
  bool get isIdle => status == PomodoroStatus.idle || status == PomodoroStatus.initial;

  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get progress {
    if (currentSession == null || remainingSeconds == 0) return 0;
    final totalSeconds = currentSession!.durationMinutes * 60;
    return (totalSeconds - remainingSeconds) / totalSeconds;
  }

  int get todayWorkSessions =>
      todaySessions.where((s) => s.type == PomodoroSessionType.work && s.completed).length;

  int get todayTotalMinutes =>
      todaySessions
          .where((s) => s.type == PomodoroSessionType.work && s.completed)
          .fold(0, (sum, s) => sum + s.durationMinutes);

  PomodoroState copyWith({
    PomodoroStatus? status,
    PomodoroSession? currentSession,
    bool clearCurrentSession = false,
    int? remainingSeconds,
    int? completedWorkSessions,
    List<PomodoroSession>? todaySessions,
    List<PomodoroSession>? sessionHistory,
    PomodoroSettings? settings,
    PomodoroStats? stats,
    String? linkedTaskId,
    String? linkedTaskTitle,
    bool clearLinkedTask = false,
  }) {
    return PomodoroState(
      status: status ?? this.status,
      currentSession: clearCurrentSession ? null : (currentSession ?? this.currentSession),
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      completedWorkSessions: completedWorkSessions ?? this.completedWorkSessions,
      todaySessions: todaySessions ?? this.todaySessions,
      sessionHistory: sessionHistory ?? this.sessionHistory,
      settings: settings ?? this.settings,
      stats: stats ?? this.stats,
      linkedTaskId: clearLinkedTask ? null : (linkedTaskId ?? this.linkedTaskId),
      linkedTaskTitle: clearLinkedTask ? null : (linkedTaskTitle ?? this.linkedTaskTitle),
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentSession,
        remainingSeconds,
        completedWorkSessions,
        todaySessions,
        sessionHistory,
        settings,
        stats,
        linkedTaskId,
        linkedTaskTitle,
      ];
}
