import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repositories/pomodoro_repository.dart';
import '../../data/repositories/notification_repository.dart';
import '../../models/pomodoro_model.dart';
import '../../models/notification_model.dart';
import '../../services/notification_servise.dart';

part 'pomodoro_event.dart';
part 'pomodoro_state.dart';

class PomodoroBloc extends Bloc<PomodoroEvent, PomodoroState> {
  final PomodoroRepository _repository;
  final NotificationRepository _notificationRepository;
  final _uuid = const Uuid();
  Timer? _timer;

  PomodoroBloc(this._repository, this._notificationRepository)
      : super(const PomodoroState()) {
    on<LoadPomodoroData>(_onLoadData);
    on<StartSession>(_onStartSession);
    on<PauseSession>(_onPauseSession);
    on<ResumeSession>(_onResumeSession);
    on<StopSession>(_onStopSession);
    on<CompleteSession>(_onCompleteSession);
    on<ExtendSession>(_onExtendSession);
    on<SkipToNextSession>(_onSkipToNext);
    on<TimerTick>(_onTimerTick);
    on<UpdateSettings>(_onUpdateSettings);
    on<LinkTaskToSession>(_onLinkTask);
    on<ClearLinkedTask>(_onClearLinkedTask);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Future<void> _onLoadData(
    LoadPomodoroData event,
    Emitter<PomodoroState> emit,
  ) async {
    final isTimerActive = state.isRunning || state.isPaused;
    if (!isTimerActive) {
      emit(state.copyWith(status: PomodoroStatus.loading));
    }

    try {
      final sessions = await _repository.fetchTodaySessions();
      final stats = await _repository.calculateStats();
      final history = await _repository.fetchSessions();
      final settings = await _repository.getSettings();

      emit(state.copyWith(
        status: isTimerActive ? state.status : PomodoroStatus.idle,
        todaySessions: sessions,
        stats: stats,
        sessionHistory: history.take(50).toList(),
        settings: settings,
      ));
    } catch (e) {
      if (!isTimerActive) {
        emit(state.copyWith(status: PomodoroStatus.idle));
      }
    }
  }

  void _onStartSession(StartSession event, Emitter<PomodoroState> emit) {
    final sessionType = event.type ?? _getNextSessionType();
    final duration = _getDurationForType(sessionType);

    final session = PomodoroSession(
      id: _uuid.v4(),
      type: sessionType,
      startTime: DateTime.now(),
      durationMinutes: duration,
      linkedTaskId: state.linkedTaskId,
      linkedTaskTitle: state.linkedTaskTitle,
    );

    emit(state.copyWith(
      status: PomodoroStatus.running,
      currentSession: session,
      remainingSeconds: duration * 60,
    ));

    _startTimer();

    // Schedule a notification for when the session should end
    _scheduleSessionEndNotification(sessionType, duration);
  }

  /// Schedule a notification for when the Pomodoro session ends
  Future<void> _scheduleSessionEndNotification(
      PomodoroSessionType type, int durationMinutes) async {
    final notificationService = NotificationService();
    final scheduledTime =
        DateTime.now().add(Duration(minutes: durationMinutes));

    String title;
    String body;

    switch (type) {
      case PomodoroSessionType.work:
        title = 'Work Session Complete! 🎉';
        body = 'Great job! Time for a break.';
        break;
      case PomodoroSessionType.shortBreak:
        title = 'Break Over ☕';
        body = 'Ready to get back to work?';
        break;
      case PomodoroSessionType.longBreak:
        title = 'Long Break Over 🌴';
        body = "You're refreshed! Let's continue.";
        break;
    }

    try {
      const pomodoroNotificationId = 999999;
      await notificationService.scheduleNotification(
        id: pomodoroNotificationId,
        title: title,
        body: body,
        scheduledDate: scheduledTime,
        payload: 'pomodoro_session',
        usePomodoroChannel:
            true,
      );
      print('✅ Pomodoro notification scheduled for $scheduledTime');
    } catch (e) {
      print('❌ Failed to schedule Pomodoro notification: $e');
    }
  }

  /// Cancel the scheduled Pomodoro notification
  Future<void> _cancelScheduledPomodoroNotification() async {
    final notificationService = NotificationService();
    const pomodoroNotificationId = 999999;
    await notificationService.cancelNotification(pomodoroNotificationId);
    print('🚫 Scheduled Pomodoro notification cancelled');
  }

  void _onPauseSession(PauseSession event, Emitter<PomodoroState> emit) {
    _timer?.cancel();
    _cancelScheduledPomodoroNotification(); // Cancel the scheduled notification when paused
    emit(state.copyWith(status: PomodoroStatus.paused));
  }

  void _onResumeSession(ResumeSession event, Emitter<PomodoroState> emit) {
    emit(state.copyWith(status: PomodoroStatus.running));
    _startTimer();

    // Reschedule notification for the remaining time
    if (state.currentSession != null && state.remainingSeconds > 0) {
      _rescheduleNotificationForRemainingTime(
        state.currentSession!.type,
        state.remainingSeconds,
      );
    }
  }

  /// Reschedule notification for remaining seconds when resuming
  Future<void> _rescheduleNotificationForRemainingTime(
    PomodoroSessionType type,
    int remainingSeconds,
  ) async {
    final notificationService = NotificationService();
    final scheduledTime =
        DateTime.now().add(Duration(seconds: remainingSeconds));

    String title;
    String body;

    switch (type) {
      case PomodoroSessionType.work:
        title = 'Work Session Complete! 🎉';
        body = 'Great job! Time for a break.';
        break;
      case PomodoroSessionType.shortBreak:
        title = 'Break Over ☕';
        body = 'Ready to get back to work?';
        break;
      case PomodoroSessionType.longBreak:
        title = 'Long Break Over 🌴';
        body = "You're refreshed! Let's continue.";
        break;
    }

    try {
      const pomodoroNotificationId = 999999;

      await notificationService.scheduleNotification(
        id: pomodoroNotificationId,
        title: title,
        body: body,
        scheduledDate: scheduledTime,
        payload: 'pomodoro_session',
        usePomodoroChannel:
            true,
      );
      print(
          '✅ Pomodoro notification rescheduled for $scheduledTime (${remainingSeconds}s remaining)');
    } catch (e) {
      print('❌ Failed to reschedule Pomodoro notification: $e');
    }
  }

  Future<void> _onStopSession(
    StopSession event,
    Emitter<PomodoroState> emit,
  ) async {
    _timer?.cancel();
    _cancelScheduledPomodoroNotification(); // Cancel scheduled notification when stopped

    // Save incomplete session if it was a work session
    if (state.currentSession != null &&
        state.currentSession!.type == PomodoroSessionType.work) {
      final completedSession = state.currentSession!.copyWith(
        endTime: DateTime.now(),
        completed: false,
      );
      try {
        await _repository.saveSession(completedSession);
      } catch (e) {
        print('Failed to save session: $e');
      }
    }

    emit(state.copyWith(
      status: PomodoroStatus.idle,
      clearCurrentSession: true,
      remainingSeconds: 0,
    ));

    // Reload stats
    add(LoadPomodoroData());
  }

  Future<void> _onCompleteSession(
    CompleteSession event,
    Emitter<PomodoroState> emit,
  ) async {
    _timer?.cancel();

    if (state.currentSession == null) return;

    final completedSession = state.currentSession!.copyWith(
      endTime: DateTime.now(),
      completed: true,
    );

    try {
      await _repository.saveSession(completedSession);
    } catch (e) {
      print('Failed to save session: $e');
    }

    // Update completed sessions count
    final newCompletedCount = completedSession.type == PomodoroSessionType.work
        ? state.completedWorkSessions + 1
        : state.completedWorkSessions;

    final todaySessions = [completedSession, ...state.todaySessions];
    final sessionHistory = [completedSession, ...state.sessionHistory];

    // Update stats locally
    final newStats = state.stats.copyWith(
      totalWorkSessions: state.stats.totalWorkSessions +
          (completedSession.type == PomodoroSessionType.work ? 1 : 0),
      totalWorkMinutes: state.stats.totalWorkMinutes +
          (completedSession.type == PomodoroSessionType.work
              ? completedSession.durationMinutes
              : 0),
      completedToday: state.stats.completedToday +
          (completedSession.type == PomodoroSessionType.work ? 1 : 0),
    );

    final nextType = _getNextSessionTypeAfterComplete(
        completedSession.type, newCompletedCount);

    emit(state.copyWith(
      status: PomodoroStatus.completed,
      completedWorkSessions: newCompletedCount,
      todaySessions: todaySessions,
      sessionHistory: sessionHistory,
      stats: newStats,
      clearCurrentSession: true,
      remainingSeconds: 0,
    ));

    // Auto-start next session if enabled
    if (completedSession.type == PomodoroSessionType.work &&
        state.settings.autoStartBreaks) {
      add(StartSession(type: nextType));
    } else if (completedSession.type != PomodoroSessionType.work &&
        state.settings.autoStartWork) {
      add(StartSession(type: PomodoroSessionType.work));
    }

    add(LoadPomodoroData());
  }

  void _onSkipToNext(SkipToNextSession event, Emitter<PomodoroState> emit) {
    _timer?.cancel();
    emit(state.copyWith(
      status: PomodoroStatus.idle,
      clearCurrentSession: true,
      remainingSeconds: 0,
    ));
  }

  Future<void> _onTimerTick(
      TimerTick event, Emitter<PomodoroState> emit) async {
    if (state.remainingSeconds <= 1) {
      _timer?.cancel();

      _cancelScheduledPomodoroNotification();

      emit(state.copyWith(
        status: PomodoroStatus.ringing,
        remainingSeconds: 0,
      ));

      _showSessionCompleteNotification(
          state.currentSession?.type ?? PomodoroSessionType.work);
    } else {
      emit(state.copyWith(remainingSeconds: state.remainingSeconds - 1));
    }
  }

  void _onExtendSession(ExtendSession event, Emitter<PomodoroState> emit) {
    if (state.currentSession == null) return;

    final extendedDuration = state.currentSession!.durationMinutes + 5;
    final updatedSession = state.currentSession!.copyWith(
      durationMinutes: extendedDuration,
    );

    emit(state.copyWith(
      status: PomodoroStatus.running,
      currentSession: updatedSession,
      remainingSeconds: 5 * 60,
    ));

    _startTimer();
  }

  Future<void> _onUpdateSettings(
    UpdateSettings event,
    Emitter<PomodoroState> emit,
  ) async {
    await _repository.saveSettings(event.settings);
    emit(state.copyWith(settings: event.settings));
  }

  void _onLinkTask(LinkTaskToSession event, Emitter<PomodoroState> emit) {
    emit(state.copyWith(
      linkedTaskId: event.taskId,
      linkedTaskTitle: event.taskTitle,
    ));
  }

  void _onClearLinkedTask(ClearLinkedTask event, Emitter<PomodoroState> emit) {
    emit(state.copyWith(
      clearLinkedTask: true,
    ));
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(TimerTick());
    });
  }

  PomodoroSessionType _getNextSessionType() {
    if (state.currentSession?.type == PomodoroSessionType.work) {
      if ((state.completedWorkSessions + 1) %
              state.settings.sessionsBeforeLongBreak ==
          0) {
        return PomodoroSessionType.longBreak;
      }
      return PomodoroSessionType.shortBreak;
    }
    return PomodoroSessionType.work;
  }

  PomodoroSessionType _getNextSessionTypeAfterComplete(
      PomodoroSessionType completedType, int newCompletedCount) {
    if (completedType == PomodoroSessionType.work) {
      if (newCompletedCount % state.settings.sessionsBeforeLongBreak == 0) {
        return PomodoroSessionType.longBreak;
      }
      return PomodoroSessionType.shortBreak;
    }
    return PomodoroSessionType.work;
  }

  int _getDurationForType(PomodoroSessionType type) {
    switch (type) {
      case PomodoroSessionType.work:
        return state.settings.workDuration;
      case PomodoroSessionType.shortBreak:
        return state.settings.shortBreakDuration;
      case PomodoroSessionType.longBreak:
        return state.settings.longBreakDuration;
    }
  }

  Future<void> _showSessionCompleteNotification(
      PomodoroSessionType type) async {
    print('🍅 _showSessionCompleteNotification called for type: $type');

    final prefs = await SharedPreferences.getInstance();
    final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;

    if (!notificationsEnabled) {
      print('⚠️ Notifications disabled by user');
      return;
    }

    String title;
    String body;

    switch (type) {
      case PomodoroSessionType.work:
        title = 'Work Session Complete! 🎉';
        body = 'Great job! Time for a break.';
        break;
      case PomodoroSessionType.shortBreak:
        title = 'Break Over ☕';
        body = 'Ready to get back to work?';
        break;
      case PomodoroSessionType.longBreak:
        title = 'Long Break Over 🌴';
        body = "You're refreshed! Let's continue.";
        break;
    }

    print('🔔 Attempting to show Pomodoro notification...');
    try {
      final notificationService = NotificationService();
      print(
          '   NotificationService initialized: ${notificationService.isInitialized}');

      await notificationService.showPomodoroNotification(
        title: title,
        body: body,
      );
      print('✅ Pomodoro notification shown: $title');
    } catch (e, stack) {
      print('❌ Error showing Pomodoro notification: $e');
      print('   Stack: $stack');
    }

    _notificationRepository
        .saveNotification(AppNotification(
      id: _uuid.v4(),
      title: title,
      body: body,
      timestamp: DateTime.now(),
    ))
        .catchError((e) {
      print('❌ Error saving notification to history: $e');
    });
  }
}
