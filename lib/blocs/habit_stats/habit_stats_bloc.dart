import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/repositories/habit_repository.dart';
import '../../models/habit_model.dart';

part 'habit_stats_event.dart';
part 'habit_stats_state.dart';

class HabitStatsBloc extends Bloc<HabitStatsEvent, HabitStatsState> {
  final HabitRepository _repository;

  HabitStatsBloc(this._repository) : super(const HabitStatsState()) {
    on<LoadHabitStats>(_onLoadStats);
    on<SelectHabit>(_onSelectHabit);
    on<ChangeTimeRange>(_onChangeTimeRange);
    on<CompareHabits>(_onCompareHabits);
    on<ClearComparison>(_onClearComparison);
  }

  Future<void> _onLoadStats(
    LoadHabitStats event,
    Emitter<HabitStatsState> emit,
  ) async {
    emit(state.copyWith(status: HabitStatsStatus.loading));
    try {
      final habits = await _repository.fetchHabits();
      final stats = habits.map((h) => HabitStatistics.fromHabit(h)).toList();

      emit(state.copyWith(
        status: HabitStatsStatus.ready,
        habits: habits,
        statistics: stats,
        selectedHabit: habits.isNotEmpty ? habits.first : null,
      ));
    } catch (e) {
      emit(state.copyWith(status: HabitStatsStatus.failure, errorMessage: '$e'));
    }
  }

  void _onSelectHabit(SelectHabit event, Emitter<HabitStatsState> emit) {
    final habit = state.habits.firstWhere(
      (h) => h.id == event.habitId,
      orElse: () => state.habits.first,
    );
    emit(state.copyWith(selectedHabit: habit));
  }

  void _onChangeTimeRange(ChangeTimeRange event, Emitter<HabitStatsState> emit) {
    emit(state.copyWith(timeRange: event.range));
  }

  void _onCompareHabits(CompareHabits event, Emitter<HabitStatsState> emit) {
    emit(state.copyWith(comparisonHabitIds: event.habitIds));
  }

  void _onClearComparison(ClearComparison event, Emitter<HabitStatsState> emit) {
    emit(state.copyWith(comparisonHabitIds: []));
  }
}

/// Statistics calculated for a single habit
class HabitStatistics {
  final String habitId;
  final String habitName;
  final int totalCompletions;
  final int currentStreak;
  final int longestStreak;
  final double completionRate7Days;
  final double completionRate30Days;
  final double completionRate90Days;
  final Map<String, bool> completionHistory;
  final List<StreakPeriod> streakHistory;
  final Map<int, int> completionsByDayOfWeek; // 1-7 (Mon-Sun) -> count
  final Map<int, int> completionsByMonth; // 1-12 -> count

  HabitStatistics({
    required this.habitId,
    required this.habitName,
    required this.totalCompletions,
    required this.currentStreak,
    required this.longestStreak,
    required this.completionRate7Days,
    required this.completionRate30Days,
    required this.completionRate90Days,
    required this.completionHistory,
    required this.streakHistory,
    required this.completionsByDayOfWeek,
    required this.completionsByMonth,
  });

  factory HabitStatistics.fromHabit(Habit habit) {
    final completionsByDayOfWeek = <int, int>{};
    final completionsByMonth = <int, int>{};
    final streakHistory = <StreakPeriod>[];

    // Calculate completions by day of week and month
    for (final entry in habit.completionHistory.entries) {
      if (entry.value) {
        try {
          final date = DateTime.parse(entry.key);
          final dayOfWeek = date.weekday;
          final month = date.month;

          completionsByDayOfWeek[dayOfWeek] =
              (completionsByDayOfWeek[dayOfWeek] ?? 0) + 1;
          completionsByMonth[month] =
              (completionsByMonth[month] ?? 0) + 1;
        } catch (_) {}
      }
    }

    // Calculate streak history
    if (habit.completionHistory.isNotEmpty) {
      final sortedDates = habit.completionHistory.keys.toList()..sort();
      DateTime? streakStart;
      DateTime? lastDate;
      int currentStreakLength = 0;

      for (final dateKey in sortedDates) {
        if (habit.completionHistory[dateKey] != true) continue;

        try {
          final date = DateTime.parse(dateKey);

          if (lastDate == null) {
            streakStart = date;
            currentStreakLength = 1;
          } else if (date.difference(lastDate).inDays == 1) {
            currentStreakLength++;
          } else {
            // Streak ended, save it
            if (streakStart != null && currentStreakLength > 0) {
              streakHistory.add(StreakPeriod(
                startDate: streakStart,
                endDate: lastDate,
                length: currentStreakLength,
              ));
            }
            streakStart = date;
            currentStreakLength = 1;
          }
          lastDate = date;
        } catch (_) {}
      }

      // Add the last streak
      if (streakStart != null && lastDate != null && currentStreakLength > 0) {
        streakHistory.add(StreakPeriod(
          startDate: streakStart,
          endDate: lastDate,
          length: currentStreakLength,
        ));
      }
    }

    return HabitStatistics(
      habitId: habit.id,
      habitName: habit.name,
      totalCompletions: habit.totalCompletions,
      currentStreak: habit.currentStreak,
      longestStreak: habit.longestStreak,
      completionRate7Days: habit.getCompletionRate(7),
      completionRate30Days: habit.getCompletionRate(30),
      completionRate90Days: habit.getCompletionRate(90),
      completionHistory: habit.completionHistory,
      streakHistory: streakHistory,
      completionsByDayOfWeek: completionsByDayOfWeek,
      completionsByMonth: completionsByMonth,
    );
  }

  /// Get completion data for a chart (last N days)
  List<DailyCompletion> getCompletionChartData(int days) {
    final data = <DailyCompletion>[];
    final now = DateTime.now();

    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = Habit.getDateKey(date);
      final completed = completionHistory[dateKey] ?? false;

      data.add(DailyCompletion(
        date: date,
        completed: completed,
      ));
    }

    return data;
  }

  /// Get weekly completion rate for chart
  List<WeeklyRate> getWeeklyRateData(int weeks) {
    final data = <WeeklyRate>[];
    final now = DateTime.now();

    for (int w = weeks - 1; w >= 0; w--) {
      final weekStart = now.subtract(Duration(days: now.weekday - 1 + (w * 7)));
      int completed = 0;
      int total = 7;

      for (int d = 0; d < 7; d++) {
        final date = weekStart.add(Duration(days: d));
        final dateKey = Habit.getDateKey(date);
        if (completionHistory[dateKey] == true) {
          completed++;
        }
      }

      data.add(WeeklyRate(
        weekStart: weekStart,
        rate: (completed / total) * 100,
        completedDays: completed,
      ));
    }

    return data;
  }
}

class StreakPeriod {
  final DateTime startDate;
  final DateTime endDate;
  final int length;

  StreakPeriod({
    required this.startDate,
    required this.endDate,
    required this.length,
  });
}

class DailyCompletion {
  final DateTime date;
  final bool completed;

  DailyCompletion({required this.date, required this.completed});
}

class WeeklyRate {
  final DateTime weekStart;
  final double rate;
  final int completedDays;

  WeeklyRate({
    required this.weekStart,
    required this.rate,
    required this.completedDays,
  });
}

