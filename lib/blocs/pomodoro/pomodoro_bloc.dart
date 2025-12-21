import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

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

  PomodoroBloc(this._repository, this._notificationRepository) : super(const PomodoroState()) {
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
    // Don't change status if timer is running
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
        sessionHistory: history.take(50).toList(), // Last 50 sessions
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
  }

  void _onPauseSession(PauseSession event, Emitter<PomodoroState> emit) {
    _timer?.cancel();
    emit(state.copyWith(status: PomodoroStatus.paused));
  }

  void _onResumeSession(ResumeSession event, Emitter<PomodoroState> emit) {
    emit(state.copyWith(status: PomodoroStatus.running));
    _startTimer();
  }

  Future<void> _onStopSession(
    StopSession event,
    Emitter<PomodoroState> emit,
  ) async {
    _timer?.cancel();

    // Save incomplete session if it was a work session
    if (state.currentSession != null &&
        state.currentSession!.type == PomodoroSessionType.work) {
      final completedSession = state.currentSession!.copyWith(
        endTime: DateTime.now(),
        completed: false,
      );
      await _repository.saveSession(completedSession);
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

    await _repository.saveSession(completedSession);

    // Notification is already shown when timer ends (ringing state)
    // But if we auto-complete (e.g. skip ringing), we might want to show it?
    // For now, let's assume notification was shown at ringing state.
    // _showSessionCompleteNotification(completedSession.type);

    // Update completed sessions count
    final newCompletedCount = completedSession.type == PomodoroSessionType.work
        ? state.completedWorkSessions + 1
        : state.completedWorkSessions;

    final todaySessions = [completedSession, ...state.todaySessions];

    // Determine next session type before clearing current session
    final nextType = _getNextSessionTypeAfterComplete(completedSession.type, newCompletedCount);

    emit(state.copyWith(
      status: PomodoroStatus.completed,
      completedWorkSessions: newCompletedCount,
      todaySessions: todaySessions,
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
  }

  void _onSkipToNext(SkipToNextSession event, Emitter<PomodoroState> emit) {
    _timer?.cancel();
    emit(state.copyWith(
      status: PomodoroStatus.idle,
      clearCurrentSession: true,
      remainingSeconds: 0,
    ));
  }

  void _onTimerTick(TimerTick event, Emitter<PomodoroState> emit) {
    if (state.remainingSeconds <= 1) {
      _timer?.cancel();

      // Show notification
      _showSessionCompleteNotification(state.currentSession?.type ?? PomodoroSessionType.work);

      emit(state.copyWith(
        status: PomodoroStatus.ringing,
        remainingSeconds: 0,
      ));
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
      // After work, take a break
      if ((state.completedWorkSessions + 1) % state.settings.sessionsBeforeLongBreak == 0) {
        return PomodoroSessionType.longBreak;
      }
      return PomodoroSessionType.shortBreak;
    }
    // After break, work
    return PomodoroSessionType.work;
  }

  PomodoroSessionType _getNextSessionTypeAfterComplete(PomodoroSessionType completedType, int newCompletedCount) {
    if (completedType == PomodoroSessionType.work) {
      // After work, take a break
      if (newCompletedCount % state.settings.sessionsBeforeLongBreak == 0) {
        return PomodoroSessionType.longBreak;
      }
      return PomodoroSessionType.shortBreak;
    }
    // After break, work
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

  void _showSessionCompleteNotification(PomodoroSessionType type) {
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

    // Show system notification
    NotificationService().showNotification(
      title: title,
      body: body,
    );

    // Save to in-app notification history
    _notificationRepository.saveNotification(AppNotification(
      id: _uuid.v4(),
      title: title,
      body: body,
      timestamp: DateTime.now(),
    ));
  }
}

