import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dayflow/data/repositories/notification_repository.dart';
import 'package:dayflow/models/notification_model.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;

  NotificationBloc(this._repository) : super(const NotificationState()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkNotificationAsRead>(_onMarkAsRead);
    on<AddNotification>(_onAddNotification);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    if (state.hasReachedMax && !event.refresh) return;

    try {
      if (state.status == NotificationStatus.initial || event.refresh) {
        emit(state.copyWith(status: NotificationStatus.loading));
        final notifications = await _repository.fetchNotifications();
        emit(state.copyWith(
          status: NotificationStatus.success,
          notifications: notifications,
          hasReachedMax: notifications.length < 10,
        ));
      } else {
        final notifications = await _repository.fetchNotifications(
          startAfter: state.notifications.last,
        );
        emit(notifications.isEmpty
            ? state.copyWith(hasReachedMax: true)
            : state.copyWith(
                status: NotificationStatus.success,
                notifications: List.of(state.notifications)..addAll(notifications),
                hasReachedMax: notifications.length < 10,
              ));
      }
    } catch (_) {
      emit(state.copyWith(status: NotificationStatus.failure));
    }
  }

  Future<void> _onMarkAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    await _repository.markAsRead(event.id);
    final updatedNotifications = state.notifications.map((n) {
      return n.id == event.id ? n.copyWith(isRead: true) : n;
    }).toList();
    emit(state.copyWith(notifications: updatedNotifications));
  }

  Future<void> _onAddNotification(
    AddNotification event,
    Emitter<NotificationState> emit,
  ) async {
    await _repository.saveNotification(event.notification);
    emit(state.copyWith(
      notifications: [event.notification, ...state.notifications],
    ));
  }
}

