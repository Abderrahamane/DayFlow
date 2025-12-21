import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

enum NavigationAction {
  none,
  openCreateTask,
}

class NavigationState extends Equatable {
  final int index;
  final NavigationAction action;
  final Object? data;

  const NavigationState({
    required this.index,
    this.action = NavigationAction.none,
    this.data,
  });

  @override
  List<Object?> get props => [index, action, data];
}

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState(index: 0));

  void setIndex(int index, {NavigationAction action = NavigationAction.none, Object? data}) {
    emit(NavigationState(index: index, action: action, data: data));
  }

  void clearAction() {
    emit(NavigationState(index: state.index, action: NavigationAction.none));
  }
}

