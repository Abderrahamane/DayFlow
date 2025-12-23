part of 'habit_stats_bloc.dart';

abstract class HabitStatsEvent extends Equatable {
  const HabitStatsEvent();

  @override
  List<Object?> get props => [];
}

class LoadHabitStats extends HabitStatsEvent {}

class SelectHabit extends HabitStatsEvent {
  final String habitId;

  const SelectHabit(this.habitId);

  @override
  List<Object?> get props => [habitId];
}

class ChangeTimeRange extends HabitStatsEvent {
  final StatsTimeRange range;

  const ChangeTimeRange(this.range);

  @override
  List<Object?> get props => [range];
}

class CompareHabits extends HabitStatsEvent {
  final List<String> habitIds;

  const CompareHabits(this.habitIds);

  @override
  List<Object?> get props => [habitIds];
}

class ClearComparison extends HabitStatsEvent {}

