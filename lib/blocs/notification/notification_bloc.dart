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
    on<MarkAllNotificationsAsRead>(_onMarkAllAsRead);
    on<DeleteNotification>(_onDeleteNotification);
    on<AddNotification>(_onAddNotification);
    on<LoadUnreadCount>(_onLoadUnreadCount);
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
        final unreadCount = await _repository.getUnreadCount();
        emit(state.copyWith(
          status: NotificationStatus.success,
          notifications: notifications,
          hasReachedMax: notifications.length < 10,
          unreadCount: unreadCount,
        ));
      } else {
        final notifications = await _repository.fetchNotifications(
          startAfter: state.notifications.last,
        );
        emit(notifications.isEmpty
            ? state.copyWith(hasReachedMax: true)
            : state.copyWith(
                status: NotificationStatus.success,
                notifications: List.of(state.notifications)
                  ..addAll(notifications),
                hasReachedMax: notifications.length < 10,
              ));
      }
    } catch (e) {
      print('❌ Error loading notifications: $e');
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
    final newUnreadCount = state.unreadCount > 0 ? state.unreadCount - 1 : 0;
    emit(state.copyWith(
      notifications: updatedNotifications,
      unreadCount: newUnreadCount,
    ));
  }

  Future<void> _onMarkAllAsRead(
    MarkAllNotificationsAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    await _repository.markAllAsRead();
    final updatedNotifications =
        state.notifications.map((n) => n.copyWith(isRead: true)).toList();
    emit(state.copyWith(
      notifications: updatedNotifications,
      unreadCount: 0,
    ));
  }

  Future<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationState> emit,
  ) async {
    final notification = state.notifications.firstWhere(
      (n) => n.id == event.id,
      orElse: () => AppNotification(
        id: '',
        title: '',
        body: '',
        timestamp: DateTime.now(),
        isRead: true,
      ),
    );

    await _repository.deleteNotification(event.id);
    final updatedNotifications =
        state.notifications.where((n) => n.id != event.id).toList();
    final newUnreadCount = !notification.isRead && state.unreadCount > 0
        ? state.unreadCount - 1
        : state.unreadCount;
    emit(state.copyWith(
      notifications: updatedNotifications,
      unreadCount: newUnreadCount,
    ));
  }

  Future<void> _onAddNotification(
    AddNotification event,
    Emitter<NotificationState> emit,
  ) async {
    await _repository.saveNotification(event.notification);
    final newUnreadCount =
        event.notification.isRead ? state.unreadCount : state.unreadCount + 1;
    emit(state.copyWith(
      notifications: [event.notification, ...state.notifications],
      unreadCount: newUnreadCount,
    ));
  }

  Future<void> _onLoadUnreadCount(
    LoadUnreadCount event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final count = await _repository.getUnreadCount();
      emit(state.copyWith(unreadCount: count));
    } catch (e) {
      print('❌ Error loading unread count: $e');
    }
  }
}
