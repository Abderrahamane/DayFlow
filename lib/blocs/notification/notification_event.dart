part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationEvent {
  final bool refresh;
  const LoadNotifications({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

class MarkNotificationAsRead extends NotificationEvent {
  final String id;
  const MarkNotificationAsRead(this.id);

  @override
  List<Object?> get props => [id];
}

class AddNotification extends NotificationEvent {
  final AppNotification notification;
  const AddNotification(this.notification);

  @override
  List<Object?> get props => [notification];
}

