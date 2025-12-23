part of 'habit_stats_bloc.dart';

enum HabitStatsStatus { initial, loading, ready, failure }

enum StatsTimeRange {
  week7,
  month30,
  quarter90;

  int get days {
    switch (this) {
      case StatsTimeRange.week7:
        return 7;
      case StatsTimeRange.month30:
        return 30;
      case StatsTimeRange.quarter90:
        return 90;
    }
  }

  String get displayName {
    switch (this) {
      case StatsTimeRange.week7:
        return '7 Days';
      case StatsTimeRange.month30:
        return '30 Days';
      case StatsTimeRange.quarter90:
        return '90 Days';
    }
  }
}

class HabitStatsState extends Equatable {
  final List<Habit> habits;
  final List<HabitStatistics> statistics;
  final Habit? selectedHabit;
  final StatsTimeRange timeRange;
  final List<String> comparisonHabitIds;
  final HabitStatsStatus status;
  final String? errorMessage;

  const HabitStatsState({
    this.habits = const [],
    this.statistics = const [],
    this.selectedHabit,
    this.timeRange = StatsTimeRange.month30,
    this.comparisonHabitIds = const [],
    this.status = HabitStatsStatus.initial,
    this.errorMessage,
  });

  /// Get statistics for selected habit
  HabitStatistics? get selectedHabitStats {
    if (selectedHabit == null) return null;
    return statistics.firstWhere(
      (s) => s.habitId == selectedHabit!.id,
      orElse: () => HabitStatistics.fromHabit(selectedHabit!),
    );
  }

  /// Get habits for comparison
  List<Habit> get comparisonHabits =>
      habits.where((h) => comparisonHabitIds.contains(h.id)).toList();

  /// Get statistics for comparison habits
  List<HabitStatistics> get comparisonStats =>
      statistics.where((s) => comparisonHabitIds.contains(s.habitId)).toList();

  /// Overall statistics across all habits
  double get overallCompletionRate {
    if (habits.isEmpty) return 0;
    return habits.fold<double>(
          0,
          (sum, h) => sum + h.getCompletionRate(timeRange.days),
        ) /
        habits.length;
  }

  int get totalStreakDays =>
      habits.fold<int>(0, (sum, h) => sum + h.currentStreak);

  int get totalCompletionsAllTime =>
      habits.fold<int>(0, (sum, h) => sum + h.totalCompletions);

  Habit? get bestPerformingHabit {
    if (habits.isEmpty) return null;
    return habits.reduce((a, b) =>
        a.getCompletionRate(timeRange.days) > b.getCompletionRate(timeRange.days)
            ? a
            : b);
  }

  Habit? get longestStreakHabit {
    if (habits.isEmpty) return null;
    return habits.reduce((a, b) => a.longestStreak > b.longestStreak ? a : b);
  }

  HabitStatsState copyWith({
    List<Habit>? habits,
    List<HabitStatistics>? statistics,
    Habit? selectedHabit,
    StatsTimeRange? timeRange,
    List<String>? comparisonHabitIds,
    HabitStatsStatus? status,
    String? errorMessage,
  }) {
    return HabitStatsState(
      habits: habits ?? this.habits,
      statistics: statistics ?? this.statistics,
      selectedHabit: selectedHabit ?? this.selectedHabit,
      timeRange: timeRange ?? this.timeRange,
      comparisonHabitIds: comparisonHabitIds ?? this.comparisonHabitIds,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        habits,
        statistics,
        selectedHabit,
        timeRange,
        comparisonHabitIds,
        status,
        errorMessage,
      ];
}

