part of 'habit_bloc.dart';

enum HabitStatus { initial, loading, ready, failure }

class HabitState extends Equatable {
  final List<Habit> habits;
  final HabitStatus status;
  final String? errorMessage;

  const HabitState({
    this.habits = const [],
    this.status = HabitStatus.initial,
    this.errorMessage,
  });

  int get completedToday =>
      habits.where((habit) => habit.isCompletedToday).length;
  int get activeStreaks => habits.where((habit) => habit.currentStreak > 0).length;
  double get todayCompletionPercentage =>
      habits.isEmpty ? 0 : (completedToday / habits.length) * 100;

  HabitState copyWith({
    List<Habit>? habits,
    HabitStatus? status,
    String? errorMessage,
  }) {
    return HabitState(
      habits: habits ?? this.habits,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [habits, status, errorMessage];
}
