import 'dart:async';
import 'dart:convert';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/presentation/service/page/booking_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../common/helper/notification/notification_model.dart';
import '../../../presentation/notifications/bloc/notification_bloc.dart';
import '../../../presentation/notifications/bloc/notification_event.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

enum NotificationType {
  commentBlog,
  blogReplyReReply,
  blogReplyComment,
  reactionComment,
  blogReactionReply,
  reactionBlog,
  reviewService,
  replyReview,
  bookingService,
  reviewRoute,
  routeReactionRoute,
  routeReplyReview,
  routeReplyReReply,
  reactionReview,
  routeReactionReply,
  message,
  subscription,
  route,
  user,
  challenge,
  groupInvitation,
  group,
}

NotificationType getNotificationType(int entityType) {
  switch (entityType) {
    case 1:
      return NotificationType.commentBlog;
    case 2:
      return NotificationType.blogReplyReReply;
    case 3:
      return NotificationType.blogReplyComment;
    case 4:
      return NotificationType.reactionComment;
    case 5:
      return NotificationType.reactionBlog;
    case 6:
      return NotificationType.blogReactionReply;
    case 7:
      return NotificationType.reviewService;
    case 8:
      return NotificationType.replyReview;
    case 9:
      return NotificationType.bookingService;
    case 10:
      return NotificationType.reviewRoute;
    case 11:
      return NotificationType.routeReactionRoute;
    case 12:
      return NotificationType.routeReplyReview;
    case 13:
      return NotificationType.routeReplyReReply;
    case 14:
      return NotificationType.reactionReview;
    case 15:
      return NotificationType.routeReactionReply;
    case 16:
      return NotificationType.message;
    case 17:
      return NotificationType.subscription;
    case 18:
      return NotificationType.route;
    case 19:
      return NotificationType.user;
    case 20:
      return NotificationType.challenge;
    case 21:
      return NotificationType.groupInvitation;
    case 22:
      return NotificationType.group;
    default:
      return NotificationType.message;
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  INotificationService._handleNotificationTap(notificationResponse.payload);
}

class INotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const int _trackingChannelId = 888;
  static const int _blogChannelId = 1001;
  static const int _serviceReviewChannelId = 1002;
  static const int _bookingChannelId = 1003;
  static const int _routeChannelId = 1004;
  static const int _messageChannelId = 1005;
  static const int _subscriptionChannelId = 1006;
  static const int _userChannelId = 1007;
  static const int _challengeChannelId = 1008;
  static const int _groupChannelId = 1009;

  static Future<void> init() async {
    const androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInitSettings);

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static void _onNotificationTapped(NotificationResponse response) {
    _handleNotificationTap(response.payload);
  }

  static void _handleNotificationTap(String? payload) {
    if (payload == null) {
      print('No payload provided');
      return;
    }

    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final entityId = data['entityId'] as int;
      final entityType = data['entityType'] as int;
      final notificationId = data['notificationId'] as String;

      final context = navigatorKey.currentContext;
      if (context == null) {
        print('No context available for navigation');
        return;
      }

      switch (entityType) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
          Navigator.pushNamed(
            context,
            '/blog_detail',
            arguments: {'blogId': entityId},
          );
          break;
        case 7:
        // case 8:
        case 14:
          Navigator.pushNamed(
            context,
            '/service_detail',
            arguments: {'serviceId': entityId},
          );
          break;
        case 8:
          AppNavigator.push(context, BookingDetailScreen(bookingId: entityId));
          // Navigator.pushNamed(
          //   context,
          //   '/booking_detail',
          //   arguments: {'bookingId': entityId},
          // );
          break;
        case 10:
        case 11:
        case 12:
        case 13:
        case 15:
        case 18:
          Navigator.pushNamed(
            context,
            '/route_detail',
            arguments: {'routeId': entityId},
          );
          break;
        case 16:
          Navigator.pushNamed(
            context,
            '/chat',
            arguments: {'chatId': entityId},
          );
          break;
        case 17:
          Navigator.pushNamed(context, '/settings');
          break;
        case 19:
          Navigator.pushNamed(
            context,
            '/user_profile',
            arguments: {'userId': entityId},
          );
          break;
        case 20:
          Navigator.pushNamed(
            context,
            '/challenge_detail',
            arguments: {'challengeId': entityId},
          );
          break;
        case 21:
        case 22:
          Navigator.pushNamed(
            context,
            '/group_detail',
            arguments: {'groupId': entityId},
          );
          break;
        default:
          Navigator.pushNamed(context, '/notifications');
      }

      print(
          'Navigated for notification: $notificationId, entityType: $entityType');
    } catch (e) {
      print('Error handling notification tap: $e');
    }
  }

  static Future<void> showNotification({
    required int id,
    required NotificationType type,
    required String title,
    required String body,
    String? payload,
    DateTime? startTime,
  }) async {
    // Giải mã payload để lấy thông tin
    Map<String, dynamic>? payloadData;
    if (payload != null) {
      payloadData = jsonDecode(payload) as Map<String, dynamic>;
    }

    // Tạo NotificationModel
    final notification = NotificationModel(
      notificationId: payloadData?['notificationId'] ?? id.toString(),
      senderName: payloadData?['senderName'] ?? 'System',
      senderAvatar: payloadData?['senderAvatar'],
      entityId: payloadData?['entityId'] ?? 0,
      entityType: payloadData?['entityType'] ?? type.index,
      message: body,
      isRead: false,
      createdAt: DateTime.now(),
      messageId: payloadData?['messageId'],
    );

    // Thêm thông báo vào NotificationBloc
    final context = navigatorKey.currentContext;
    if (context != null) {
      context.read<NotificationBloc>().add(AddNotification(notification));
    }

    // Hiển thị thông báo
    final androidDetails = _getAndroidNotificationDetails(type, startTime);
    final details = NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(id, title, body, details, payload: payload);
  }

  static AndroidNotificationDetails _getAndroidNotificationDetails(
      NotificationType type, DateTime? startTime) {
    switch (type) {
      // case NotificationType.rideTracking:
      //   return AndroidNotificationDetails(
      //     'ride_tracking',
      //     'Ride Tracking',
      //     channelDescription: 'Ride tracking in progress',
      //     importance: Importance.defaultImportance,
      //     priority: Priority.defaultPriority,
      //     ongoing: true,
      //     onlyAlertOnce: true,
      //     usesChronometer: true,
      //     silent: true,
      //     when: startTime?.millisecondsSinceEpoch ??
      //         DateTime.now().millisecondsSinceEpoch,
      //   );
      case NotificationType.commentBlog:
      case NotificationType.blogReplyReReply:
      case NotificationType.blogReplyComment:
      case NotificationType.reactionComment:
      case NotificationType.reactionBlog:
      case NotificationType.blogReactionReply:
        return const AndroidNotificationDetails(
          'blog_channel',
          'Blog Notifications',
          channelDescription: 'Notifications related to blog interactions',
          importance: Importance.high,
          priority: Priority.high,
        );
      case NotificationType.reviewService:
      case NotificationType.replyReview:
      case NotificationType.reactionReview:
        return const AndroidNotificationDetails(
          'service_review_channel',
          'Service Reviews',
          channelDescription: 'Service review updates and replies',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        );
      case NotificationType.bookingService:
        return const AndroidNotificationDetails(
          'booking_channel',
          'Booking Service',
          channelDescription: 'Notifications for service bookings',
          importance: Importance.high,
          priority: Priority.high,
        );
      case NotificationType.reviewRoute:
      case NotificationType.routeReactionRoute:
      case NotificationType.routeReplyReview:
      case NotificationType.routeReplyReReply:
      case NotificationType.routeReactionReply:
      case NotificationType.route:
        return const AndroidNotificationDetails(
          'route_channel',
          'Route Notifications',
          channelDescription: 'Notifications related to routes and reviews',
          importance: Importance.high,
          priority: Priority.high,
        );
      case NotificationType.message:
        return const AndroidNotificationDetails(
          'message_channel',
          'Messages',
          channelDescription: 'Direct chat messages',
          importance: Importance.max,
          priority: Priority.max,
        );
      case NotificationType.subscription:
        return const AndroidNotificationDetails(
          'subscription_channel',
          'Subscription Updates',
          channelDescription: 'News about subscriptions or memberships',
          importance: Importance.low,
          priority: Priority.low,
        );
      case NotificationType.user:
        return const AndroidNotificationDetails(
          'user_channel',
          'User Notifications',
          channelDescription: 'Notifications related to user actions',
          importance: Importance.high,
          priority: Priority.high,
        );
      case NotificationType.challenge:
        return const AndroidNotificationDetails(
          'challenge_channel',
          'Challenge Notifications',
          channelDescription: 'Notifications related to challenges',
          importance: Importance.high,
          priority: Priority.high,
        );
      case NotificationType.groupInvitation:
      case NotificationType.group:
        return const AndroidNotificationDetails(
          'group_channel',
          'Group Notifications',
          channelDescription: 'Notifications related to groups and invitations',
          importance: Importance.high,
          priority: Priority.high,
        );
    }
  }

  static void sendRideTrackingNotification(
      String title, String body, DateTime startTime,
      {String? payload}) {
    final rideTrackingChannel = AndroidNotificationDetails(
      'ride_tracking',
      'Ride Tracking',
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
      payload: payload,
    );
  }

  static void sendBlogNotification(
      String title, String body, NotificationType blogType,
      {String? payload}) {
    final blogChannel = const AndroidNotificationDetails(
      'blog_channel',
      'Blog Notifications',
      channelDescription: 'Notifications related to blog interactions',
      importance: Importance.high,
      priority: Priority.high,
    );

    _notificationsPlugin.show(
      _blogChannelId,
      title,
      body,
      NotificationDetails(android: blogChannel),
      payload: payload,
    );
  }

  static void sendServiceReviewNotification(
      String title, String body, NotificationType reviewType,
      {String? payload}) {
    final serviceReviewChannel = const AndroidNotificationDetails(
      'service_review_channel',
      'Service Reviews',
      channelDescription: 'Service review updates and replies',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    _notificationsPlugin.show(
      _serviceReviewChannelId,
      title,
      body,
      NotificationDetails(android: serviceReviewChannel),
      payload: payload,
    );
  }

  static void sendBookingServiceNotification(String title, String body,
      {String? payload}) {
    final bookingChannel = const AndroidNotificationDetails(
      'booking_channel',
      'Booking Service',
      channelDescription: 'Notifications for service bookings',
      importance: Importance.high,
      priority: Priority.high,
    );

    _notificationsPlugin.show(
      _bookingChannelId,
      title,
      body,
      NotificationDetails(android: bookingChannel),
      payload: payload,
    );
  }

  static void sendRouteNotification(
      String title, String body, NotificationType routeType,
      {String? payload}) {
    final routeChannel = const AndroidNotificationDetails(
      'route_channel',
      'Route Notifications',
      channelDescription: 'Notifications related to routes and reviews',
      importance: Importance.high,
      priority: Priority.high,
    );

    _notificationsPlugin.show(
      _routeChannelId,
      title,
      body,
      NotificationDetails(android: routeChannel),
      payload: payload,
    );
  }

  static void sendMessageNotification(String title, String body,
      {String? payload}) {
    final messageChannel = const AndroidNotificationDetails(
      'message_channel',
      'Messages',
      channelDescription: 'Direct chat messages',
      importance: Importance.max,
      priority: Priority.max,
    );

    _notificationsPlugin.show(
      _messageChannelId,
      title,
      body,
      NotificationDetails(android: messageChannel),
      payload: payload,
    );
  }

  static void sendSubscriptionNotification(String title, String body,
      {String? payload}) {
    final subscriptionChannel = const AndroidNotificationDetails(
      'subscription_channel',
      'Subscription Updates',
      channelDescription: 'News about subscriptions or memberships',
      importance: Importance.low,
      priority: Priority.low,
    );

    _notificationsPlugin.show(
      _subscriptionChannelId,
      title,
      body,
      NotificationDetails(android: subscriptionChannel),
      payload: payload,
    );
  }

  static void sendUserNotification(String title, String body,
      {String? payload}) {
    final userChannel = const AndroidNotificationDetails(
      'user_channel',
      'User Notifications',
      channelDescription: 'Notifications related to user actions',
      importance: Importance.high,
      priority: Priority.high,
    );

    _notificationsPlugin.show(
      _userChannelId,
      title,
      body,
      NotificationDetails(android: userChannel),
      payload: payload,
    );
  }

  static void sendChallengeNotification(String title, String body,
      {String? payload}) {
    final challengeChannel = const AndroidNotificationDetails(
      'challenge_channel',
      'Challenge Notifications',
      channelDescription: 'Notifications related to challenges',
      importance: Importance.high,
      priority: Priority.high,
    );

    _notificationsPlugin.show(
      _challengeChannelId,
      title,
      body,
      NotificationDetails(android: challengeChannel),
      payload: payload,
    );
  }

  static void sendGroupNotification(String title, String body,
      {String? payload}) {
    final groupChannel = const AndroidNotificationDetails(
      'group_channel',
      'Group Notifications',
      channelDescription: 'Notifications related to groups and invitations',
      importance: Importance.high,
      priority: Priority.high,
    );

    _notificationsPlugin.show(
      _groupChannelId,
      title,
      body,
      NotificationDetails(android: groupChannel),
      payload: payload,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}
