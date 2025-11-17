// lib/providers/habits_provider.dart

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/habit_model.dart';
import '../services/mixpanel_service.dart';

/// HabitsProvider - Manages habit state with Firestore integration
/// 
/// This provider handles all habit-related operations including:
/// - Fetching habits from Firestore
/// - Creating new habits
/// - Updating existing habits
/// - Deleting habits
/// - Tracking habit completion
/// 
/// Usage:
/// ```dart
/// final habitsProvider = Provider.of<HabitsProvider>(context);
/// habitsProvider.addHabit(newHabit);
/// ```
class HabitsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Habit> _habits = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Habit> get habits => List.unmodifiable(_habits);
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get totalHabits => _habits.length;
  int get completedToday => _habits.where((h) => h.isCompletedToday).length;
  int get activeStreaks => _habits.where((h) => h.currentStreak > 0).length;

  /// Initialize and load habits from Firestore
  Future<void> loadHabits() async {
    final user = _auth.currentUser;
    if (user == null) {
      _error = 'No user logged in';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('habits')
          .get();

      _habits = snapshot.docs.map((doc) {
        final data = doc.data();
        return Habit.fromFirestore(data, doc.id);
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Error loading habits: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new habit to Firestore
  Future<void> addHabit(Habit habit) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final docRef = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('habits')
          .add(habit.toFirestore());

      final newHabit = Habit(
        id: docRef.id,
        name: habit.name,
        description: habit.description,
        color: habit.color,
        icon: habit.icon,
        frequency: habit.frequency,
        completionHistory: habit.completionHistory,
        createdAt: habit.createdAt,
      );

      _habits.add(newHabit);
      notifyListeners();

      // Track habit creation in analytics
      MixpanelService.instance.trackHabitCreated(
        habitId: docRef.id,
        habitName: habit.name,
        frequency: habit.frequency,
      );
    } catch (e) {
      _error = 'Error adding habit: $e';
      notifyListeners();
    }
  }

  /// Update an existing habit
  Future<void> updateHabit(Habit habit) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('habits')
          .doc(habit.id)
          .update(habit.toFirestore());

      final index = _habits.indexWhere((h) => h.id == habit.id);
      if (index != -1) {
        _habits[index] = habit;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error updating habit: $e';
      notifyListeners();
    }
  }

  /// Toggle habit completion for today
  Future<void> toggleHabitCompletion(String habitId) async {
    final index = _habits.indexWhere((h) => h.id == habitId);
    if (index == -1) return;

    final habit = _habits[index];
    final today = Habit.getDateKey(DateTime.now());
    final isCompleted = habit.completionHistory[today] ?? false;

    final updatedHistory = Map<String, bool>.from(habit.completionHistory);
    updatedHistory[today] = !isCompleted;

    final updatedHabit = Habit(
      id: habit.id,
      name: habit.name,
      description: habit.description,
      color: habit.color,
      icon: habit.icon,
      frequency: habit.frequency,
      completionHistory: updatedHistory,
      createdAt: habit.createdAt,
    );

    await updateHabit(updatedHabit);
  }

  /// Delete a habit
  Future<void> deleteHabit(String habitId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('habits')
          .doc(habitId)
          .delete();

      _habits.removeWhere((h) => h.id == habitId);
      notifyListeners();
    } catch (e) {
      _error = 'Error deleting habit: $e';
      notifyListeners();
    }
  }

  /// Get habit by ID
  Habit? getHabitById(String habitId) {
    try {
      return _habits.firstWhere((h) => h.id == habitId);
    } catch (e) {
      return null;
    }
  }
}
