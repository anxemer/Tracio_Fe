import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotiService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  //INIT
  Future<void> initNotification() async {
    if (_isInitialized) return;

    //prepare android settings
    const initSettingAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    //prepare ios settings
    const initSettingIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: initSettingAndroid,
      iOS: initSettingIOS,
    );

    await notificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (details) => null);
  }

  //NOTIFICATIONS DETAIL SETUP
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
            "daily_channel_id", "Daily Notifications",
            channelDescription: "Daily Notification Channel",
            importance: Importance.max,
            priority: Priority.high),
        iOS: DarwinNotificationDetails());
  }

  //SHOW NOTIFICATIONS
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? description,
  }) async {
    return notificationsPlugin.show(
        id, title, description, notificationDetails());
  }

  //ON NOTIFICATION APP
}
