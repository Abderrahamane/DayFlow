import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/repositories/task_repository.dart';
import '../../data/repositories/habit_repository.dart';
import '../../models/task_model.dart';
import '../../models/habit_model.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final TaskRepository _taskRepository;
  final HabitRepository _habitRepository;

  CalendarBloc({
    required TaskRepository taskRepository,
    required HabitRepository habitRepository,
  })  : _taskRepository = taskRepository,
        _habitRepository = habitRepository,
        super(CalendarState.initial()) {
    on<LoadCalendarData>(_onLoadData);
    on<SelectDate>(_onSelectDate);
    on<ChangeViewMode>(_onChangeViewMode);
    on<ChangeFocusedDay>(_onChangeFocusedDay);
  }

  Future<void> _onLoadData(
    LoadCalendarData event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWith(status: CalendarStatus.loading));
    try {
      final tasks = await _taskRepository.fetchTasks();
      final habits = await _habitRepository.fetchHabits();
      emit(state.copyWith(
        status: CalendarStatus.ready,
        allTasks: tasks,
        allHabits: habits,
      ));
    } catch (e) {
      emit(state.copyWith(status: CalendarStatus.failure, errorMessage: '$e'));
    }
  }

  void _onSelectDate(SelectDate event, Emitter<CalendarState> emit) {
    emit(state.copyWith(selectedDate: event.date));
  }

  void _onChangeViewMode(ChangeViewMode event, Emitter<CalendarState> emit) {
    emit(state.copyWith(viewMode: event.mode));
  }

  void _onChangeFocusedDay(ChangeFocusedDay event, Emitter<CalendarState> emit) {
    emit(state.copyWith(focusedDay: event.day));
  }
}

