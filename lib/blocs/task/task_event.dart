part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddOrUpdateTask extends TaskEvent {
  final Task task;

  const AddOrUpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;

  const DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class ToggleTaskCompletionEvent extends TaskEvent {
  final String taskId;

  const ToggleTaskCompletionEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class ToggleSubtaskCompletionEvent extends TaskEvent {
  final String taskId;
  final String subtaskId;

  const ToggleSubtaskCompletionEvent({
    required this.taskId,
    required this.subtaskId,
  });

  @override
  List<Object?> get props => [taskId, subtaskId];
}

class ChangeTaskFilter extends TaskEvent {
  final TaskFilter filter;

  const ChangeTaskFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

class ChangeTaskSort extends TaskEvent {
  final TaskSort sort;

  const ChangeTaskSort(this.sort);

  @override
  List<Object?> get props => [sort];
}

class SearchTasks extends TaskEvent {
  final String query;

  const SearchTasks(this.query);

  @override
  List<Object?> get props => [query];
}
