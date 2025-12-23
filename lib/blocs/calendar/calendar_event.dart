part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}

class LoadCalendarData extends CalendarEvent {}

class SelectDate extends CalendarEvent {
  final DateTime date;

  const SelectDate(this.date);

  @override
  List<Object?> get props => [date];
}

class ChangeViewMode extends CalendarEvent {
  final CalendarViewMode mode;

  const ChangeViewMode(this.mode);

  @override
  List<Object?> get props => [mode];
}

class ChangeFocusedDay extends CalendarEvent {
  final DateTime day;

  const ChangeFocusedDay(this.day);

  @override
  List<Object?> get props => [day];
}

