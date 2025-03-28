import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  //TODO Handle on tap notification
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const int _trackingChannelId = 888;

  static Future<void> init() async {
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInitSettings);

    await _notificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground);
  }

  static void _onNotificationTapped(NotificationResponse response) async {
    //TODO Handle on tap notification
  }

  static void sendRideTrackingNotification(
      String title, String body, DateTime startTime) {
    final rideTrackingChannel = AndroidNotificationDetails(
      'ride_tracking',
      'Ride Tracking Start',
      channelDescription: 'Ongoing notifications for ride tracking',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      ongoing: true,
      onlyAlertOnce: true,
      usesChronometer: true,
      silent: true,
      when: startTime.millisecondsSinceEpoch,
    );

    _notificationsPlugin.show(
      _trackingChannelId,
      title,
      body,
      NotificationDetails(android: rideTrackingChannel),
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}
