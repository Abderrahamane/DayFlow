// lib/providers/task_provider.dart

import 'package:flutter/foundation.dart';
import '../helpers/database_helper.dart';
import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  bool isLoading = false;

  List<Task> get tasks => _tasks;

  TaskProvider() {
    loadTasksFromDb();
  }

  Future<void> loadTasksFromDb() async {
    isLoading = true;
    notifyListeners();
    try {
      _tasks = await DatabaseHelper.instance.getTasks();
      _sortTasks();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(Task task) async {
    await DatabaseHelper.instance.addTask(task);
    _tasks.add(task);
    _sortTasks();
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await DatabaseHelper.instance.updateTask(task);
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
    _sortTasks();
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    await DatabaseHelper.instance.deleteTask(id);
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  Future<void> toggleTaskCompletion(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks[index];
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await updateTask(updatedTask);
    }
  }

  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  void _sortTasks() {
    _tasks.sort((a, b) {
      if (!a.isCompleted && b.isCompleted) return -1;
      if (a.isCompleted && !b.isCompleted) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });
  }
}