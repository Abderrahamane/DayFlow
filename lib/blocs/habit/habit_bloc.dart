import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../data/repositories/habit_repository.dart';
import '../../models/habit_model.dart';

part 'habit_event.dart';
part 'habit_state.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final HabitRepository _repository;
  final _uuid = const Uuid();

  HabitBloc(this._repository) : super(const HabitState()) {
    on<LoadHabits>(_onLoadHabits);
    on<AddOrUpdateHabit>(_onAddOrUpdateHabit);
    on<DeleteHabitEvent>(_onDeleteHabit);
    on<ToggleHabitCompletionEvent>(_onToggleCompletion);
  }

  Future<void> _onLoadHabits(
    LoadHabits event,
    Emitter<HabitState> emit,
  ) async {
    emit(state.copyWith(status: HabitStatus.loading));
    try {
      final habits = await _repository.fetchHabits();
      emit(state.copyWith(status: HabitStatus.ready, habits: habits));
    } catch (e) {
      emit(state.copyWith(status: HabitStatus.failure, errorMessage: '$e'));
    }
  }

  Future<void> _onAddOrUpdateHabit(
    AddOrUpdateHabit event,
    Emitter<HabitState> emit,
  ) async {
    final habit = event.habit.id.isEmpty
        ? event.habit.copyWith(id: _uuid.v4(), createdAt: DateTime.now())
        : event.habit;

    await _repository.upsertHabit(habit);
    final updatedHabits = List<Habit>.from(state.habits)
      ..removeWhere((h) => h.id == habit.id)
      ..add(habit);
    emit(state.copyWith(habits: updatedHabits));
  }

  Future<void> _onDeleteHabit(
    DeleteHabitEvent event,
    Emitter<HabitState> emit,
  ) async {
    await _repository.deleteHabit(event.habitId);
    emit(state.copyWith(
      habits: state.habits.where((h) => h.id != event.habitId).toList(),
    ));
  }

  Future<void> _onToggleCompletion(
    ToggleHabitCompletionEvent event,
    Emitter<HabitState> emit,
  ) async {
    await _repository.toggleCompletion(event.habitId, event.dateKey);
    final habits = state.habits.map((habit) {
      if (habit.id == event.habitId) {
        final history = Map<String, bool>.from(habit.completionHistory);
        history[event.dateKey] = !(history[event.dateKey] ?? false);
        return habit.copyWith(completionHistory: history);
      }
      return habit;
    }).toList();

    emit(state.copyWith(habits: habits));
  }
}
