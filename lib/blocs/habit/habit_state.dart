part of 'habit_bloc.dart';

enum HabitStatus { initial, loading, ready, failure }

class HabitState extends Equatable {
  final List<Habit> habits;
  final HabitStatus status;
  final String? errorMessage;
  final String searchQuery;

  const HabitState({
    this.habits = const [],
    this.status = HabitStatus.initial,
    this.errorMessage,
    this.searchQuery = '',
  });

  int get completedToday =>
      habits.where((habit) => habit.isCompletedToday).length;
  int get activeStreaks => habits.where((habit) => habit.currentStreak > 0).length;
  double get todayCompletionPercentage =>
      habits.isEmpty ? 0 : (completedToday / habits.length) * 100;

  List<Habit> get visibleHabits {
    if (searchQuery.isEmpty) return habits;
    final query = searchQuery.toLowerCase();
    return habits.where((h) {
      return h.name.toLowerCase().contains(query) ||
          (h.description?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  HabitState copyWith({
    List<Habit>? habits,
    HabitStatus? status,
    String? errorMessage,
    String? searchQuery,
  }) {
    return HabitState(
      habits: habits ?? this.habits,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [habits, status, errorMessage, searchQuery];
}
