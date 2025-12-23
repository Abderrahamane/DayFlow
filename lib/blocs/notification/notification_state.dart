part of 'notification_bloc.dart';

enum NotificationStatus { initial, loading, success, failure }

class NotificationState extends Equatable {
  final NotificationStatus status;
  final List<AppNotification> notifications;
  final bool hasReachedMax;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.hasReachedMax = false,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    List<AppNotification>? notifications,
    bool? hasReachedMax,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [status, notifications, hasReachedMax];
}

