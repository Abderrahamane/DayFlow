import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dayflow/models/habit_model.dart';

void main() {
  group('Habit Model', () {
    late Habit habit;
    late DateTime now;

    setUp(() {
      now = DateTime.now();
      habit = Habit(
        id: 'habit-1',
        name: 'Exercise',
        description: 'Daily workout',
        icon: '🏃',
        frequency: HabitFrequency.daily,
        goalCount: 1,
        createdAt: now,
        color: Colors.blue,
      );
    });

    test('should create a habit with given properties', () {
      expect(habit.id, 'habit-1');
      expect(habit.name, 'Exercise');
      expect(habit.description, 'Daily workout');
      expect(habit.icon, '🏃');
      expect(habit.frequency, HabitFrequency.daily);
      expect(habit.goalCount, 1);
    });

    test('copyWith should create a new habit with updated properties', () {
      final updatedHabit = habit.copyWith(
        name: 'Morning Run',
        goalCount: 2,
      );

      expect(updatedHabit.name, 'Morning Run');
      expect(updatedHabit.goalCount, 2);
      expect(updatedHabit.id, habit.id);
      expect(updatedHabit.description, habit.description);
    });

    test('isCompletedToday should return false when not completed', () {
      expect(habit.isCompletedToday, false);
    });

    test('isCompletedToday should return true when completed today', () {
      final today = Habit.getDateKey(now);
      final completedHabit = habit.copyWith(
        completionHistory: {today: true},
      );

      expect(completedHabit.isCompletedToday, true);
    });

    test('currentStreak should return 0 when no completions', () {
      expect(habit.currentStreak, 0);
    });

    test('currentStreak should count consecutive days', () {
      final yesterday = Habit.getDateKey(now.subtract(const Duration(days: 1)));
      final today = Habit.getDateKey(now);

      final habitWithStreak = habit.copyWith(
        completionHistory: {
          yesterday: true,
          today: true,
        },
      );

      expect(habitWithStreak.currentStreak, 2);
    });

    test('totalCompletions should count all completed days', () {
      final habitWithHistory = habit.copyWith(
        completionHistory: {
          '2024-01-01': true,
          '2024-01-02': false,
          '2024-01-03': true,
          '2024-01-05': true,
        },
      );

      expect(habitWithHistory.totalCompletions, 3);
    });

    test('getCompletionRate should calculate correct rate', () {
      final today = Habit.getDateKey(now);
      final yesterday = Habit.getDateKey(now.subtract(const Duration(days: 1)));
      final twoDaysAgo = Habit.getDateKey(now.subtract(const Duration(days: 2)));

      final habitWithHistory = habit.copyWith(
        completionHistory: {
          today: true,
          yesterday: true,
          twoDaysAgo: false,
        },
      );

      // 2 out of 3 days = ~66.67%
      final rate = habitWithHistory.getCompletionRate(3);
      expect(rate, closeTo(66.67, 0.1));
    });

    test('getDateKey should format date correctly', () {
      final testDate = DateTime(2024, 3, 15);
      expect(Habit.getDateKey(testDate), '2024-03-15');
    });
  });

  group('HabitFrequency', () {
    test('should have correct frequency values', () {
      expect(HabitFrequency.values.length, 3);
      expect(HabitFrequency.values.contains(HabitFrequency.daily), true);
      expect(HabitFrequency.values.contains(HabitFrequency.weekly), true);
      expect(HabitFrequency.values.contains(HabitFrequency.custom), true);
    });
  });
}

