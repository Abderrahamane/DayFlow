part of 'habit_bloc.dart';

abstract class HabitEvent extends Equatable {
  const HabitEvent();

  @override
  List<Object?> get props => [];
}

class LoadHabits extends HabitEvent {}

class AddOrUpdateHabit extends HabitEvent {
  final Habit habit;

  const AddOrUpdateHabit(this.habit);

  @override
  List<Object?> get props => [habit];
}

class DeleteHabitEvent extends HabitEvent {
  final String habitId;

  const DeleteHabitEvent(this.habitId);

  @override
  List<Object?> get props => [habitId];
}

class ToggleHabitCompletionEvent extends HabitEvent {
  final String habitId;
  final String dateKey;

  const ToggleHabitCompletionEvent({
    required this.habitId,
    required this.dateKey,
  });

  @override
  List<Object?> get props => [habitId, dateKey];
}

class SearchHabits extends HabitEvent {
  final String query;

  const SearchHabits(this.query);

  @override
  List<Object?> get props => [query];
}
