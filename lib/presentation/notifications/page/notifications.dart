// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../common/helper/notification/notification_model.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    // Tải danh sách thông báo khi khởi tạo
    context.read<NotificationBloc>().add(LoadNotifications());
  }

  void _handleNotificationTap(NotificationModel notification) {
    final entityId = notification.entityId;
    final entityType = notification.entityType;

    // Điều hướng dựa trên entityType
    switch (entityType) {
      case 5: // Like blog
      case 6: // Comment on blog
        Navigator.pushNamed(
          context,
          '/blog_detail',
          arguments: {'blogId': entityId},
        );
        break;
      case 7: // New follower
        Navigator.pushNamed(
          context,
          '/user_profile',
          arguments: {'userId': entityId},
        );
        break;
      case 8: // Blog post shared
        Navigator.pushNamed(
          context,
          '/blog_detail',
          arguments: {'blogId': entityId},
        );
        break;
      case 9: // Profile update reminder
        Navigator.pushNamed(context, '/settings');
        break;
      case 10: // Security alert
        Navigator.pushNamed(context, '/security_settings');
        break;
      default:
        Navigator.pushNamed(context, '/notifications');
    }

    print(
        'Navigated for notification: ${notification.notificationId}, entityType: $entityType');
  }

  // Hàm chuyển đổi thời gian thành dạng tương đối (ví dụ: "2 phút trước")
  String _formatTimeAgo(DateTime dateTime) {
    return timeago.format(dateTime,
        locale: 'en'); // Có thể đổi sang ngôn ngữ khác
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBack: false,
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: AppSize.textHeading.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          final notifications = state.notifications
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          if (notifications.isEmpty) {
            return Center(
              child: Text(
                'No notifications yet',
                style: TextStyle(
                  fontSize: AppSize.textMedium.sp,
                  color: Colors.grey,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                child: Card(
                  elevation: 2, // Bóng mờ nhẹ hơn
                  color: notification.isRead
                      ? Colors.white
                      : Colors.blue[50], // Nền nhẹ cho thông báo chưa đọc
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    leading: CircleAvatar(
                      radius: 24.w,
                      backgroundColor: Colors.blueGrey[100],
                      backgroundImage: notification.senderAvatar != null
                          ? NetworkImage(notification.senderAvatar!)
                          : null,
                      child: notification.senderAvatar == null
                          ? Text(
                              notification.senderName.isNotEmpty
                                  ? notification.senderName[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey[800],
                              ),
                            )
                          : null,
                    ),
                    title: Text(
                      notification.senderName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: AppSize.textMedium.sp,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.h),
                        Text(
                          notification.message,
                          style: TextStyle(
                            fontSize: AppSize.textSmall.sp,
                            color: Colors.black54,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _formatTimeAgo(notification.createdAt),
                          style: TextStyle(
                            fontSize: AppSize.textSmall.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      notification.isRead
                          ? Icons.check_circle_outline
                          : Icons.circle,
                      color: notification.isRead ? Colors.green : Colors.red,
                      size: 20.sp, // Kích thước biểu tượng nhỏ hơn
                    ),
                    onTap: () {
                      // Đánh dấu là đã đọc
                      if (!notification.isRead) {
                        context.read<NotificationBloc>().add(
                            MarkNotificationAsRead(
                                notification.notificationId));
                      }
                      // Xử lý điều hướng
                      _handleNotificationTap(notification);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
