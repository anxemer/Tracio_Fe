// notification_bloc.dart
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../common/helper/notification/notification_model.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends HydratedBloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationState(notifications: [])) {
    on<LoadNotifications>(_onLoadNotifications);
    on<AddNotification>(_onAddNotification);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
  }

  void _onLoadNotifications(
      LoadNotifications event, Emitter<NotificationState> emit) {
    // Trạng thái đã được HydratedBloc khôi phục, chỉ cần emit lại
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

  @override
  NotificationState? fromJson(Map<String, dynamic> json) {
    try {
      return NotificationState.fromJson(json);
    } catch (_) {
      return null; // Nếu có lỗi, trả về null để sử dụng trạng thái mặc định
    }
  }

  @override
  Map<String, dynamic>? toJson(NotificationState state) {
    return state.toJson();
  }
}