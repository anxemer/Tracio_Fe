import 'package:flutter/material.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Define a model for Notification
class NotificationModel {
  final String title;
  final String description;
  final DateTime timeSent;
  bool isRead;

  NotificationModel({
    required this.title,
    required this.description,
    required this.timeSent,
    this.isRead = false,
  });
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Sample data for notifications
  List<NotificationModel> notifications = [
    NotificationModel(
      title: "New Message",
      description: "You have a new message from John.",
      timeSent: DateTime.now().subtract(Duration(minutes: 2)),
      isRead: false,
    ),
    NotificationModel(
      title: "App Update Available",
      description: "A new update is available for the app.",
      timeSent: DateTime.now().subtract(Duration(hours: 1)),
      isRead: false,
    ),
    NotificationModel(
      title: "Promo Offer",
      description: "Limited time offer! Get 30% off on your next purchase.",
      timeSent: DateTime.now().subtract(Duration(days: 1)),
      isRead: true,
    ),
    NotificationModel(
      title: "Reminder",
      description: "Don't forget to complete your profile.",
      timeSent: DateTime.now().subtract(Duration(days: 2)),
      isRead: false,
    ),
    NotificationModel(
      title: "New Follower",
      description: "Anna just followed you.",
      timeSent: DateTime.now().subtract(Duration(days: 3)),
      isRead: true,
    ),
    NotificationModel(
      title: "Security Alert",
      description: "There was a login attempt from an unrecognized device.",
      timeSent: DateTime.now().subtract(Duration(days: 4)),
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBack: false,
        title: Text(
          'Notifications',
          style: TextStyle(
              fontSize: AppSize.textHeading.sp, color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.w),
                title: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppSize.textMedium.sp,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification.description),
                    SizedBox(height: 4.h),
                    Text(
                      'Sent: ${notification.timeSent.hour}:${notification.timeSent.minute} - ${notification.timeSent.day}/${notification.timeSent.month}/${notification.timeSent.year}',
                      style: TextStyle(
                        fontSize: AppSize.textSmall.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                trailing: Icon(
                  notification.isRead
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: notification.isRead ? Colors.green : Colors.red,
                ),
                onTap: () {
                  setState(() {
                    // Mark as read when tapped
                    notification.isRead = true;
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
