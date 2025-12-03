import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../data/repositories/task_repository.dart';
import '../../models/task_model.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _repository;
  final _uuid = const Uuid();

  TaskBloc(this._repository) : super(TaskState.initial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddOrUpdateTask>(_onAddOrUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskCompletionEvent>(_onToggleCompletion);
    on<ToggleSubtaskCompletionEvent>(_onToggleSubtask);
    on<ChangeTaskFilter>(_onChangeFilter);
    on<ChangeTaskSort>(_onChangeSort);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(state.copyWith(status: TaskStatus.loading));
    try {
      final tasks = await _repository.fetchTasks();
      emit(state.copyWith(
        status: TaskStatus.ready,
        tasks: tasks,
      ));
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.failure, errorMessage: '$e'));
    }
  }

  Future<void> _onAddOrUpdateTask(
    AddOrUpdateTask event,
    Emitter<TaskState> emit,
  ) async {
    final task = event.task.id.isEmpty
        ? event.task.copyWith(id: _uuid.v4(), createdAt: DateTime.now())
        : event.task;

    await _repository.upsertTask(task);
    final updatedTasks = List<Task>.from(state.tasks)
      ..removeWhere((t) => t.id == task.id)
      ..add(task);

    emit(state.copyWith(tasks: updatedTasks));
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    await _repository.deleteTask(event.taskId);
    emit(state.copyWith(
      tasks: state.tasks.where((t) => t.id != event.taskId).toList(),
    ));
  }

  Future<void> _onToggleCompletion(
    ToggleTaskCompletionEvent event,
    Emitter<TaskState> emit,
  ) async {
    await _repository.toggleTaskCompletion(event.taskId);
    final tasks = state.tasks.map((task) {
      if (task.id == event.taskId) {
        return task.copyWith(isCompleted: !task.isCompleted);
      }
      return task;
    }).toList();

    emit(state.copyWith(tasks: tasks));
  }

  Future<void> _onToggleSubtask(
    ToggleSubtaskCompletionEvent event,
    Emitter<TaskState> emit,
  ) async {
    await _repository.toggleSubtask(event.taskId, event.subtaskId);
    final tasks = state.tasks.map((task) {
      if (task.id == event.taskId && task.subtasks != null) {
        final updated = task.subtasks!.map((subtask) {
          if (subtask.id == event.subtaskId) {
            return subtask.copyWith(isCompleted: !subtask.isCompleted);
          }
          return subtask;
        }).toList();
        return task.copyWith(subtasks: updated);
      }
      return task;
    }).toList();

    emit(state.copyWith(tasks: tasks));
  }

  void _onChangeFilter(ChangeTaskFilter event, Emitter<TaskState> emit) {
    emit(state.copyWith(filter: event.filter));
  }

  void _onChangeSort(ChangeTaskSort event, Emitter<TaskState> emit) {
    emit(state.copyWith(sort: event.sort));
  }
}
