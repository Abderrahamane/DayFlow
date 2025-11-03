// lib/services/task_service.dart (UPDATED)
import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import 'habit_service.dart';

class TaskService extends ChangeNotifier {
  final List<Task> _tasks = [];
  TaskFilter _currentFilter = TaskFilter.all;
  TaskSort _currentSort = TaskSort.dateCreated;

  // Add reference to HabitService for syncing
  HabitService? _habitService;

  TaskService() {
    _loadMockData();
  }

  // Method to link with HabitService
  void linkHabitService(HabitService habitService) {
    _habitService = habitService;
  }

  List<Task> get tasks => _getFilteredAndSortedTasks();
  TaskFilter get currentFilter => _currentFilter;
  TaskSort get currentSort => _currentSort;

  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((t) => t.isCompleted).length;
  int get pendingTasks => _tasks.where((t) => !t.isCompleted).length;
  int get overdueTasks => _tasks.where((t) => t.isOverdue).length;

  void _loadMockData() {
    final now = DateTime.now();
    _tasks.addAll([
      Task(
        id: '1',
        title: 'Complete DayFlow UI Design',
        description: 'Finalize the design system and create mockups for all main screens',
        isCompleted: false,
        createdAt: now.subtract(const Duration(days: 3)),
        dueDate: now.add(const Duration(days: 2)),
        priority: TaskPriority.high,
        tags: ['design', 'urgent'],
        subtasks: [
          Subtask(id: 's1', title: 'Create color palette', isCompleted: true),
          Subtask(id: 's2', title: 'Design main screens', isCompleted: true),
          Subtask(id: 's3', title: 'Create component library', isCompleted: false),
        ],
      ),
      Task(
        id: '2',
        title: 'Implement Authentication Flow',
        description: 'Set up Firebase authentication with email/password and Google sign-in',
        isCompleted: true,
        createdAt: now.subtract(const Duration(days: 5)),
        dueDate: now.subtract(const Duration(days: 1)),
        priority: TaskPriority.high,
        tags: ['development', 'backend'],
      ),
      Task(
        id: '3',
        title: 'Write API Documentation',
        description: 'Document all REST API endpoints for the backend team',
        isCompleted: false,
        createdAt: now.subtract(const Duration(days: 2)),
        dueDate: now.add(const Duration(days: 5)),
        priority: TaskPriority.medium,
        tags: ['documentation'],
        subtasks: [
          Subtask(id: 's4', title: 'Document auth endpoints', isCompleted: false),
          Subtask(id: 's5', title: 'Document task endpoints', isCompleted: false),
          Subtask(id: 's6', title: 'Add examples', isCompleted: false),
        ],
      ),
      Task(
        id: '4',
        title: 'Team Meeting Preparation',
        description: 'Prepare slides and demo for weekly team standup',
        isCompleted: false,
        createdAt: now.subtract(const Duration(hours: 3)),
        dueDate: now,
        priority: TaskPriority.high,
        tags: ['meeting'],
      ),
      Task(
        id: '5',
        title: 'Refactor Database Schema',
        description: 'Optimize MongoDB collections and add proper indexes',
        isCompleted: false,
        createdAt: now.subtract(const Duration(days: 7)),
        dueDate: now.add(const Duration(days: 10)),
        priority: TaskPriority.low,
        tags: ['backend', 'optimization'],
      ),
      Task(
        id: '6',
        title: 'Update Dependencies',
        description: 'Update all npm packages to latest stable versions',
        isCompleted: true,
        createdAt: now.subtract(const Duration(days: 1)),
        priority: TaskPriority.low,
        tags: ['maintenance'],
      ),
      Task(
        id: '7',
        title: 'Code Review - Notes Feature',
        description: 'Review pull request for the new notes feature implementation',
        isCompleted: false,
        createdAt: now.subtract(const Duration(hours: 8)),
        dueDate: now.add(const Duration(days: 1)),
        priority: TaskPriority.medium,
        tags: ['review'],
      ),
      Task(
        id: '8',
        title: 'Buy Groceries',
        description: 'Milk, eggs, bread, vegetables, fruits',
        isCompleted: false,
        createdAt: now.subtract(const Duration(hours: 2)),
        dueDate: now,
        priority: TaskPriority.medium,
        tags: ['personal'],
      ),
      // Add some habit-linked tasks
      Task(
        id: '9',
        title: 'Read Flutter Documentation',
        description: 'Study new widget patterns',
        isCompleted: false,
        createdAt: now,
        dueDate: now,
        priority: TaskPriority.medium,
        tags: ['reading', 'documentation'],
      ),
      Task(
        id: '10',
        title: 'Morning Gym Session',
        description: '45 min workout',
        isCompleted: false,
        createdAt: now,
        dueDate: now,
        priority: TaskPriority.high,
        tags: ['workout', 'exercise'],
      ),
    ]);
    notifyListeners();
  }

  List<Task> _getFilteredAndSortedTasks() {
    var filtered = List<Task>.from(_tasks);

    switch (_currentFilter) {
      case TaskFilter.completed:
        filtered = filtered.where((t) => t.isCompleted).toList();
        break;
      case TaskFilter.pending:
        filtered = filtered.where((t) => !t.isCompleted).toList();
        break;
      case TaskFilter.overdue:
        filtered = filtered.where((t) => t.isOverdue).toList();
        break;
      case TaskFilter.today:
        filtered = filtered.where((t) => t.isDueToday).toList();
        break;
      case TaskFilter.all:
        break;
    }

    filtered.sort((a, b) {
      switch (_currentSort) {
        case TaskSort.dateCreated:
          return b.createdAt.compareTo(a.createdAt);
        case TaskSort.dueDate:
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        case TaskSort.priority:
          return b.priority.index.compareTo(a.priority.index);
        case TaskSort.title:
          return a.title.compareTo(b.title);
      }
    });

    return filtered;
  }

  void setFilter(TaskFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  void setSort(TaskSort sort) {
    _currentSort = sort;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      final oldTask = _tasks[index];
      _tasks[index] = task;

      // 🔥 CRITICAL: Sync with Habits when task is completed
      if (!oldTask.isCompleted && task.isCompleted) {
        _habitService?.checkTaskCompletion(task);
      }

      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  Future<void> toggleTaskCompletion(String id) async {
    final task = _tasks.firstWhere((t) => t.id == id);
    await updateTask(task.copyWith(isCompleted: !task.isCompleted));
  }

  Future<void> toggleSubtaskCompletion(String taskId, String subtaskId) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    final subtasks = task.subtasks!.map((s) {
      if (s.id == subtaskId) {
        return s.copyWith(isCompleted: !s.isCompleted);
      }
      return s;
    }).toList();
    await updateTask(task.copyWith(subtasks: subtasks));
  }

  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }
}