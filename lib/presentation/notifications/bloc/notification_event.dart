// notification_event.dart
import '../../../common/helper/notification/notification_model.dart';

abstract class NotificationEvent {}

class LoadNotifications extends NotificationEvent {}

class AddNotification extends NotificationEvent {
  final NotificationModel notification;

  AddNotification(this.notification);
}

class MarkNotificationAsRead extends NotificationEvent {
  final String notificationId;

  MarkNotificationAsRead(this.notificationId);
}