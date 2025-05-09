import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../common/helper/notification/notification_model.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends HydratedBloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationState(notifications: [])) {
    on<LoadNotifications>(_onLoadNotifications);
    on<AddNotification>(_onAddNotification);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<DeleteNotification>(_onDeleteNotification);
  }

  void _onLoadNotifications(
      LoadNotifications event, Emitter<NotificationState> emit) {
    emit(state.copyWith(notifications: state.notifications));
  }

  void _onAddNotification(
      AddNotification event, Emitter<NotificationState> emit) {
    final updatedNotifications = List<NotificationModel>.from(state.notifications)
      ..add(event.notification);
    emit(state.copyWith(notifications: updatedNotifications));
  }

  void _onMarkNotificationAsRead(
      MarkNotificationAsRead event, Emitter<NotificationState> emit) {
    final updatedNotifications = state.notifications.map((notification) {
      if (notification.notificationId == event.notificationId) {
        return NotificationModel(
          notificationId: notification.notificationId,
          senderName: notification.senderName,
          senderAvatar: notification.senderAvatar,
          entityId: notification.entityId,
          entityType: notification.entityType,
          message: notification.message,
          isRead: true,
          createdAt: notification.createdAt,
          messageId: notification.messageId,
        );
      }
      return notification;
    }).toList();
    emit(state.copyWith(notifications: updatedNotifications));
  }

  void _onDeleteNotification(
      DeleteNotification event, Emitter<NotificationState> emit) {
    final updatedNotifications = state.notifications
        .where((notification) => notification.notificationId != event.notificationId)
        .toList();
    emit(state.copyWith(notifications: updatedNotifications));
  }

 int extractor=1;
  @override
  NotificationState? fromJson(Map<String, dynamic> json) {
    try {
      return NotificationState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(NotificationState state) {
    return state.toJson();
  }
}