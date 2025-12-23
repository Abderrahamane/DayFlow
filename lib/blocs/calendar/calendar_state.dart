part of 'calendar_bloc.dart';

enum CalendarStatus { initial, loading, ready, failure }
enum CalendarViewMode { month, week, day }

class CalendarState extends Equatable {
  final CalendarStatus status;
  final List<Task> allTasks;
  final List<Habit> allHabits;
  final DateTime selectedDate;
  final DateTime focusedDay;
  final CalendarViewMode viewMode;
  final String? errorMessage;

  const CalendarState({
    required this.status,
    required this.allTasks,
    required this.allHabits,
    required this.selectedDate,
    required this.focusedDay,
    required this.viewMode,
    this.errorMessage,
  });

  factory CalendarState.initial() => CalendarState(
        status: CalendarStatus.initial,
        allTasks: const [],
        allHabits: const [],
        selectedDate: DateTime.now(),
        focusedDay: DateTime.now(),
        viewMode: CalendarViewMode.month,
      );

  /// Get tasks for a specific date
  List<Task> getTasksForDate(DateTime date) {
    return allTasks.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.year == date.year &&
          task.dueDate!.month == date.month &&
          task.dueDate!.day == date.day;
    }).toList();
  }

  /// Get habits for a specific date
  List<Habit> getHabitsForDate(DateTime date) {
    return allHabits.where((habit) {
      // Check if habit should be tracked on this date based on frequency
      return _shouldTrackHabitOnDate(habit, date);
    }).toList();
  }

  bool _shouldTrackHabitOnDate(Habit habit, DateTime date) {
    switch (habit.frequency) {
      case HabitFrequency.daily:
        return true;
      case HabitFrequency.weekly:
        // Track on same weekday as created
        return date.weekday == habit.createdAt.weekday;
      case HabitFrequency.custom:
        return true;
    }
  }

  /// Get completion status for habit on date
  bool isHabitCompletedOnDate(Habit habit, DateTime date) {
    final dateKey = Habit.getDateKey(date);
    return habit.completionHistory[dateKey] ?? false;
  }

  /// Get tasks for the selected date
  List<Task> get selectedDateTasks => getTasksForDate(selectedDate);

  /// Get habits for the selected date
  List<Habit> get selectedDateHabits => getHabitsForDate(selectedDate);

  /// Get event count for a date (tasks + habits)
  int getEventCountForDate(DateTime date) {
    return getTasksForDate(date).length + getHabitsForDate(date).length;
  }

  /// Check if a date has events
  bool hasEventsOnDate(DateTime date) {
    return getTasksForDate(date).isNotEmpty || getHabitsForDate(date).isNotEmpty;
  }

  /// Get task priority color markers for a date
  List<TaskPriority> getTaskPrioritiesForDate(DateTime date) {
    return getTasksForDate(date).map((t) => t.priority).toSet().toList();
  }

  CalendarState copyWith({
    CalendarStatus? status,
    List<Task>? allTasks,
    List<Habit>? allHabits,
    DateTime? selectedDate,
    DateTime? focusedDay,
    CalendarViewMode? viewMode,
    String? errorMessage,
  }) {
    return CalendarState(
      status: status ?? this.status,
      allTasks: allTasks ?? this.allTasks,
      allHabits: allHabits ?? this.allHabits,
      selectedDate: selectedDate ?? this.selectedDate,
      focusedDay: focusedDay ?? this.focusedDay,
      viewMode: viewMode ?? this.viewMode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allTasks,
        allHabits,
        selectedDate,
        focusedDay,
        viewMode,
        errorMessage,
      ];
}

