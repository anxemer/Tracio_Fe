import 'dart:io';

import 'package:Tracio/common/widget/navbar/bottom_nav_bar_manager.dart';
import 'package:Tracio/data/user/models/send_fcm_req.dart';
import 'package:Tracio/data/user/source/user_api_source.dart';
import 'package:Tracio/presentation/service/widget/all_review_service.dart';
import 'package:Tracio/service_locator.dart';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../common/helper/schedule_model.dart' as MyApp;
import '../../../presentation/service/page/booking_detail.dart';
import 'i_notification_service.dart'; // Import service hiển thị notification cục bộ

class FirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> init() async {
    // Yêu cầu quyền thông báo (đặc biệt cho iOS)
    await _firebaseMessaging.requestPermission(
      sound: true,
      alert: true,
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
    Future<String?> _getId() async {
      var deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        // import 'dart:io'
        var iosDeviceInfo = await deviceInfo.iosInfo;
        return iosDeviceInfo.identifierForVendor; // unique ID on iOS
      } else if (Platform.isAndroid) {
        var androidDeviceInfo = await deviceInfo.androidInfo;
        return AndroidId().getId(); // unique ID on Android
      }
    }

    // Lấy token
    final deviceId = await _getId();
    final token = await _firebaseMessaging.getToken();
    print("FCM Token: $token"); // Gửi token này lên server để push notification
    print(
        "device Token: $deviceId"); // Gửi token này lên server để push notification
    sl<UserApiSource>()
        .sendFcm(SendFcmReq(deviceId: deviceId ?? '', fcmToken: token ?? ''));
    // Handle khi app đang mở
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    // Handle khi user tap notification từ background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleTap(message);
    });

    // Handle khi app khởi động từ trạng thái bị kill (cold start)
    final msg = await _firebaseMessaging.getInitialMessage();
    if (msg != null) {
      _handleTap(msg);
    }
  }

  static void _handleMessage(RemoteMessage message) {
    final notification = message.notification;
    final data = message.data;

    if (notification != null) {
      final title = notification.title ?? '';
      final body = notification.body ?? '';
      final payload = data['payload'] ?? '';
      final type = NotificationType.values.firstWhere(
        (e) => e.toString() == 'NotificationType.${data['type']}',
        orElse: () => NotificationType.message, // Mặc định nếu không tìm thấy
      );

      // Gọi phương thức của INotificationService để hiển thị thông báo cục bộ
      INotificationService.showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        type: type,
        title: title,
        body: body,
        payload: payload,
      );
    }
  }

  static void _handleTap(RemoteMessage message) {
    final data = message.data;
    final payload = data['payload'];
    final typeString =
        data['type']; // Loại thông báo (rideTracking, commentBlog, v.v.)

    if (payload != null) {
      // Chuyển loại thông báo thành enum
      NotificationType notificationType = NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == typeString,
        orElse: () =>
            NotificationType.subscription, // Mặc định nếu không tìm thấy
      );

      switch (notificationType) {
        // case NotificationType.rideTracking:
        //   final rideId = payload; // Giả sử payload là rideId
        //  Navigator.of(MyApp.navigatorKey.currentContext!).push(
        //     MaterialPageRoute(
        //       builder: (context) => BookingDetailScreen(bookingId: bookingId),
        //     ),
        //   );
        //   break;

        // case NotificationType.commentBlog:
        //   final blogId = payload; // Giả sử payload là blogId
        //   Navigator.of(MyApp.navigatorKey.currentContext!).push(
        //     MaterialPageRoute(
        //       builder: (context) => DetailBlocPage(: bookingId),
        //     ),
        //   );
        //   break;

        // case NotificationType.blogReplyReReply:
        //   final commentId = payload; // Giả sử payload là commentId
        //   Navigator.of(MyApp.navigatorKey.currentContext!).push(
        //     MaterialPageRoute(
        //       builder: (context) => BookingDetailScreen(bookingId: bookingId),
        //     ),
        //   );
        //   break;

        // case NotificationType.blogReplyComment:
        //   final commentId = payload; // Giả sử payload là commentId
        //  Navigator.of(MyApp.navigatorKey.currentContext!).push(
        //     MaterialPageRoute(
        //       builder: (context) => BookingDetailScreen(bookingId: bookingId),
        //     ),
        //   );
        //   break;

        // case NotificationType.reactionBlog:
        //   final blogId = payload; // Giả sử payload là blogId
        // Navigator.of(MyApp.navigatorKey.currentContext!).push(
        //     MaterialPageRoute(
        //       builder: (context) => BookingDetailScreen(bookingId: bookingId),
        //     ),
        //   );
        //   break;

        //   case NotificationType.reactionComment:
        //     final commentId = payload; // Giả sử payload là commentId
        //  Navigator.of(MyApp.navigatorKey.currentContext!).push(
        //       MaterialPageRoute(
        //         builder: (context) => BookingDetailScreen(bookingId: bookingId),
        //       ),
        //     );
        //     break;

        // case NotificationType.blogReactionReply:
        //   final commentId = payload; // Giả sử payload là commentId
        // Navigator.of(MyApp.navigatorKey.currentContext!).push(
        //     MaterialPageRoute(
        //       builder: (context) => BookingDetailScreen(bookingId: bookingId),
        //     ),
        //   );
        //   break;

        case NotificationType.reviewService:
          final serviceId = payload; // Giả sử payload là serviceId
          Navigator.of(MyApp.navigatorKey.currentContext!).push(
            MaterialPageRoute(
              builder: (context) => AllReviewService(serviceId: serviceId),
            ),
          );
          break;

        case NotificationType.replyReview:
          final reviewId = payload; // Giả sử payload là reviewId
          Navigator.of(MyApp.navigatorKey.currentContext!).push(
            MaterialPageRoute(
              builder: (context) => AllReviewService(bookingId: reviewId),
            ),
          );
          break;

        case NotificationType.bookingService:
          final bookingId = payload; // Giả sử payload là bookingId
          Navigator.of(MyApp.navigatorKey.currentContext!).push(
            MaterialPageRoute(
              builder: (context) => BookingDetailScreen(
                bookingId: bookingId,
              ),
            ),
          );
          break;

        //   case NotificationType.reviewRoute:
        //     final routeId = payload; // Giả sử payload là routeId
        //  Navigator.of(MyApp.navigatorKey.currentContext!).push(
        //       MaterialPageRoute(
        //         builder: (context) => BookingDetailScreen(bookingId: bookingId),
        //       ),
        //     );
        //     break;

        // case NotificationType.routeReactRoute:
        //   final routeId = payload; // Giả sử payload là routeId
        // Navigator.of(MyApp.navigatorKey.currentContext!).push(
        //     MaterialPageRoute(
        //       builder: (context) => BookingDetailScreen(bookingId: bookingId),
        //     ),
        //   );
        //   break;

        //   case NotificationType.routeReplyReview:
        //     final reviewId = payload; // Giả sử payload là reviewId
        //  Navigator.of(MyApp.navigatorKey.currentContext!).push(
        //       MaterialPageRoute(
        //         builder: (context) => BookingDetailScreen(bookingId: bookingId),
        //       ),
        //     );
        //     break;

        // case NotificationType.routeReplyReReply:
        //   final replyId = payload; // Giả sử payload là replyId
        // Navigator.of(MyApp.navigatorKey.currentContext!).push(
        //     MaterialPageRoute(
        //       builder: (context) => BookingDetailScreen(bookingId: bookingId),
        //     ),
        //   );
        //   break;

        // case NotificationType.message:
        //   final messageId = payload; // Giả sử payload là messageId
        // Navigator.of(MyApp.navigatorKey.currentContext!).push(
        //     MaterialPageRoute(
        //       builder: (context) => BookingDetailScreen(bookingId: bookingId),
        //     ),
        //   );
        //   break;

        // case NotificationType.subscription:
        //     Navigator.of(MyApp.navigatorKey.currentContext!).push(
        //     MaterialPageRoute(
        //       builder: (context) => BookingDetailScreen(bookingId: bookingId),
        //     ),
        //   );
        //   break;

        default:
          Navigator.of(MyApp.navigatorKey.currentContext!).push(
            MaterialPageRoute(
              builder: (context) => BottomNavBarManager(),
            ),
          );
          break;
      }
    }
  }
}
