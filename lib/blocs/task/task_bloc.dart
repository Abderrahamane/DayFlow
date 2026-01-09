import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';

import '../../data/repositories/task_repository.dart';
import '../../data/repositories/notification_repository.dart';
import '../../models/task_model.dart';
import '../../models/notification_model.dart';
import '../../services/notification_servise.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _repository;
  final NotificationRepository? _notificationRepository;
  final _uuid = const Uuid();
  final NotificationService _notificationService = NotificationService();

  TaskBloc(this._repository, {NotificationRepository? notificationRepository})
      : _notificationRepository = notificationRepository,
        super(TaskState.initial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddOrUpdateTask>(_onAddOrUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskCompletionEvent>(_onToggleCompletion);
    on<ToggleSubtaskCompletionEvent>(_onToggleSubtask);
    on<ChangeTaskFilter>(_onChangeFilter);
    on<ChangeTaskSort>(_onChangeSort);
    on<SearchTasks>(_onSearchTasks);
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

    // Schedule notification for task with due date (reminder)
    await _scheduleTaskReminder(task);
  }

  /// Schedule a system notification for a task with a due date
  Future<void> _scheduleTaskReminder(Task task) async {
    // Only schedule if task has a due date and is not completed
    if (task.dueDate == null || task.isCompleted) {
      debugPrint('⏭️ Skipping task reminder: no due date or already completed');
      return;
    }

    // Only schedule if due date is in the future
    if (task.dueDate!.isBefore(DateTime.now())) {
      debugPrint('⏭️ Skipping task reminder: due date is in the past');
      return;
    }

    // Generate a unique notification ID from task ID
    final notificationId = task.id.hashCode.abs();

    try {
      await _notificationService.scheduleNotification(
        id: notificationId,
        title: '📋 Task Reminder: ${task.title}',
        body: task.description ?? 'Your task is due now!',
        scheduledDate: task.dueDate!,
        payload: 'task_${task.id}',
      );
      debugPrint(
          '✅ Task reminder scheduled for "${task.title}" at ${task.dueDate}');

      // Also save to notification history (will show when time comes)
      if (_notificationRepository != null) {
        await _notificationRepository!.saveNotification(AppNotification(
          id: 'task_reminder_${task.id}',
          title: '📋 Task Reminder: ${task.title}',
          body: task.description ?? 'Your task is due now!',
          timestamp: task.dueDate!,
        ));
      }
    } catch (e) {
      debugPrint('❌ Failed to schedule task reminder: $e');
    }
  }

  /// Cancel task reminder notification
  Future<void> _cancelTaskReminder(String taskId) async {
    final notificationId = taskId.hashCode.abs();
    try {
      await _notificationService.cancelNotification(notificationId);
      debugPrint('🚫 Task reminder cancelled for task $taskId');
    } catch (e) {
      debugPrint('❌ Failed to cancel task reminder: $e');
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    // Cancel any scheduled reminder for this task
    await _cancelTaskReminder(event.taskId);

    await _repository.deleteTask(event.taskId);
    emit(state.copyWith(
      tasks: state.tasks.where((t) => t.id != event.taskId).toList(),
    ));
  }

  Future<void> _onToggleCompletion(
    ToggleTaskCompletionEvent event,
    Emitter<TaskState> emit,
  ) async {
    final task = state.tasks.firstWhere((t) => t.id == event.taskId);
    final newCompletedState = !task.isCompleted;

    await _repository.toggleTaskCompletion(event.taskId);

    // Cancel reminder if task is being completed
    if (newCompletedState) {
      await _cancelTaskReminder(event.taskId);
    } else if (task.dueDate != null && task.dueDate!.isAfter(DateTime.now())) {
      // Reschedule reminder if task is being uncompleted and has future due date
      await _scheduleTaskReminder(task.copyWith(isCompleted: false));
    }

    var tasks = state.tasks.map((t) {
      if (t.id == event.taskId) {
        return t.copyWith(isCompleted: newCompletedState);
      }
      return t;
    }).toList();

    // If task is recurring and was just completed, create next occurrence
    if (newCompletedState && task.isRecurring) {
      final nextTask = task.createNextOccurrence(_uuid.v4());
      if (nextTask != null) {
        await _repository.upsertTask(nextTask);
        // Schedule reminder for the next occurrence
        await _scheduleTaskReminder(nextTask);
        tasks = [...tasks, nextTask];
      }
    }

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

  void _onSearchTasks(SearchTasks event, Emitter<TaskState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }
}
