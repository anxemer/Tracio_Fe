// notification_state.dart
import '../../../common/helper/notification/notification_model.dart';

class NotificationState {
  final List<NotificationModel> notifications;

  NotificationState({required this.notifications});

  NotificationState copyWith({List<NotificationModel>? notifications}) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications.map((n) => n.toMap()).toList(),
    };
  }

  factory NotificationState.fromJson(Map<String, dynamic> json) {
    return NotificationState(
      notifications: (json['notifications'] as List)
          .map((item) => NotificationModel.fromMap(item))
          .toList(),
    );
  }
}