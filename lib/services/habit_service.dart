// lib/services/habit_service.dart
import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../models/task_model.dart';

class HabitService extends ChangeNotifier {
  final List<Habit> _habits = [];

  HabitService() {
    _loadMockData();
  }

  List<Habit> get habits => List.unmodifiable(_habits);

  int get totalHabits => _habits.length;
  int get completedToday => _habits.where((h) => h.isCompletedToday).length;
  int get activeStreaks => _habits.where((h) => h.currentStreak > 0).length;

  void _loadMockData() {
    final now = DateTime.now();

    // Create some historical data
    Map<String, bool> readingHistory = {};
    Map<String, bool> workoutHistory = {};
    Map<String, bool> meditationHistory = {};
    Map<String, bool> codingHistory = {};

    // Simulate 30 days of history with varying completion
    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      final dateKey = Habit._getDateKey(date);

      // Reading: high consistency (80%)
      readingHistory[dateKey] = i % 5 != 0;

      // Workout: medium consistency (60%)
      workoutHistory[dateKey] = i % 3 != 0;

      // Meditation: building streak (last 7 days complete)
      meditationHistory[dateKey] = i < 7;

      // Coding: moderate (50%)
      codingHistory[dateKey] = i % 2 == 0;
    }

    _habits.addAll([
      Habit(
        id: '1',
        name: 'Read for 20 mins',
        description: 'Read books, articles, or documentation',
        icon: '📚',
        frequency: HabitFrequency.daily,
        goalCount: 7,
        linkedTaskTags: ['reading', 'books', 'documentation'],
        completionHistory: readingHistory,
        createdAt: now.subtract(const Duration(days: 30)),
        color: const Color(0xFF8B5CF6), // Purple
      ),
      Habit(
        id: '2',
        name: 'Morning Workout',
        description: 'Exercise for at least 30 minutes',
        icon: '💪',
        frequency: HabitFrequency.weekly,
        goalCount: 5,
        linkedTaskTags: ['exercise', 'workout', 'fitness'],
        completionHistory: workoutHistory,
        createdAt: now.subtract(const Duration(days: 25)),
        color: const Color(0xFFEF4444), // Red
      ),
      Habit(
        id: '3',
        name: 'Meditation',
        description: '10 minutes of mindfulness',
        icon: '🧘',
        frequency: HabitFrequency.daily,
        goalCount: 7,
        linkedTaskTags: ['meditation', 'mindfulness'],
        completionHistory: meditationHistory,
        createdAt: now.subtract(const Duration(days: 20)),
        color: const Color(0xFF10B981), // Green
      ),
      Habit(
        id: '4',
        name: 'Code Practice',
        description: 'Practice coding or work on projects',
        icon: '💻',
        frequency: HabitFrequency.weekly,
        goalCount: 5,
        linkedTaskTags: ['development', 'coding', 'backend'],
        completionHistory: codingHistory,
        createdAt: now.subtract(const Duration(days: 15)),
        color: const Color(0xFF6366F1), // Indigo
      ),
      Habit(
        id: '5',
        name: 'Drink Water',
        description: 'Stay hydrated - 8 glasses',
        icon: '💧',
        frequency: HabitFrequency.daily,
        goalCount: 7,
        linkedTaskTags: [],
        completionHistory: {},
        createdAt: now.subtract(const Duration(days: 10)),
        color: const Color(0xFF3B82F6), // Blue
      ),
    ]);

    notifyListeners();
  }

  // Toggle habit completion for today
  Future<void> toggleHabitCompletion(String habitId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final index = _habits.indexWhere((h) => h.id == habitId);
    if (index == -1) return;

    final habit = _habits[index];
    final today = Habit._getDateKey(DateTime.now());
    final newHistory = Map<String, bool>.from(habit.completionHistory);

    newHistory[today] = !(habit.isCompletedToday);

    _habits[index] = habit.copyWith(completionHistory: newHistory);
    notifyListeners();
  }

  // Check if a completed task should update any habits
  void checkTaskCompletion(Task task) {
    if (!task.isCompleted || task.tags == null || task.tags!.isEmpty) return;

    bool updated = false;
    final today = Habit._getDateKey(DateTime.now());

    for (int i = 0; i < _habits.length; i++) {
      final habit = _habits[i];

      // Check if task tags match any of the habit's linked tags
      final hasMatchingTag = task.tags!.any(
            (tag) => habit.linkedTaskTags.any(
              (habitTag) => habitTag.toLowerCase() == tag.toLowerCase(),
        ),
      );

      if (hasMatchingTag && !habit.isCompletedToday) {
        // Auto-complete the habit for today
        final newHistory = Map<String, bool>.from(habit.completionHistory);
        newHistory[today] = true;
        _habits[i] = habit.copyWith(completionHistory: newHistory);
        updated = true;
      }
    }

    if (updated) {
      notifyListeners();
    }
  }

  // Add new habit
  Future<void> addHabit(Habit habit) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _habits.add(habit);
    notifyListeners();
  }

  // Update habit
  Future<void> updateHabit(Habit habit) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
      notifyListeners();
    }
  }

  // Delete habit
  Future<void> deleteHabit(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _habits.removeWhere((h) => h.id == id);
    notifyListeners();
  }

  // Get habit by ID
  Habit? getHabitById(String id) {
    try {
      return _habits.firstWhere((h) => h.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get habits with active streaks
  List<Habit> get habitsWithStreaks {
    return _habits.where((h) => h.currentStreak > 0).toList()
      ..sort((a, b) => b.currentStreak.compareTo(a.currentStreak));
  }

  // Get today's completion percentage
  double get todayCompletionPercentage {
    if (_habits.isEmpty) return 0;
    return (completedToday / totalHabits) * 100;
  }
}