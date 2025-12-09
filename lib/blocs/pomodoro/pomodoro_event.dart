part of 'pomodoro_bloc.dart';

abstract class PomodoroEvent extends Equatable {
  const PomodoroEvent();

  @override
  List<Object?> get props => [];
}

class LoadPomodoroData extends PomodoroEvent {}

class StartSession extends PomodoroEvent {
  final PomodoroSessionType? type;

  const StartSession({this.type});

  @override
  List<Object?> get props => [type];
}

class PauseSession extends PomodoroEvent {}

class ResumeSession extends PomodoroEvent {}

class StopSession extends PomodoroEvent {}

class CompleteSession extends PomodoroEvent {}

class SkipToNextSession extends PomodoroEvent {}

class TimerTick extends PomodoroEvent {}

class UpdateSettings extends PomodoroEvent {
  final PomodoroSettings settings;

  const UpdateSettings(this.settings);

  @override
  List<Object?> get props => [settings];
}

class LinkTaskToSession extends PomodoroEvent {
  final String taskId;
  final String taskTitle;

  const LinkTaskToSession({
    required this.taskId,
    required this.taskTitle,
  });

  @override
  List<Object?> get props => [taskId, taskTitle];
}

class ClearLinkedTask extends PomodoroEvent {}

