part of 'notification_bloc.dart';

enum NotificationStatus { initial, loading, success, failure }

class NotificationState extends Equatable {
  final NotificationStatus status;
  final List<AppNotification> notifications;
  final bool hasReachedMax;
  final int unreadCount;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.hasReachedMax = false,
    this.unreadCount = 0,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    List<AppNotification>? notifications,
    bool? hasReachedMax,
    int? unreadCount,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props =>
      [status, notifications, hasReachedMax, unreadCount];
}
