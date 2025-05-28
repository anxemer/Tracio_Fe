import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Tracio/common/widget/navbar/bottom_nav_bar_manager.dart';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/common/helper/placeholder/service_card.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/common/widget/error.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/shop/models/get_booking_req.dart';
import 'package:Tracio/domain/auth/usecases/logout.dart';
import 'package:Tracio/domain/shop/entities/response/shop_profile_entity.dart';
import 'package:Tracio/presentation/auth/pages/login.dart';
import 'package:Tracio/presentation/service/bloc/get_booking/get_booking_cubit.dart';
import 'package:Tracio/presentation/shop_owner/bloc/shop_profile/shop_profile_cubit.dart';
import 'package:Tracio/presentation/shop_owner/page/service_management.dart';
import 'package:Tracio/presentation/shop_owner/page/shop_profile.dart';
import 'package:Tracio/service_locator.dart';

import '../../../common/helper/notification/notification_model.dart';
import '../../../common/widget/picture/circle_picture.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import '../../../core/services/notifications/i_notification_service.dart';
import '../../../core/services/signalR/implement/notification_hub_service.dart';
import '../../../data/auth/models/change_role_req.dart';
import '../../../data/auth/sources/auth_local_source/auth_local_source.dart';
import '../../../data/user/models/send_fcm_req.dart';
import '../../../data/user/source/user_api_source.dart';
import '../../auth/bloc/authCubit/auth_cubit.dart';
import '../../auth/bloc/authCubit/auth_state.dart';
import '../../chat/bloc/bloc/conversation_bloc.dart';
import '../../chat/pages/conversation.dart';
import '../../notifications/page/notifications.dart';
import '../../service/bloc/get_booking/get_booking_state.dart';
import 'booking_detail_shop.dart';
import 'booking_management.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _notiService = sl<NotificationHubService>();
  late final StreamSubscription<NotificationModel> _messageSubscription;
  @override
  void initState() {
    INotificationService.init();
    // FirebaseMessagingService.init();

    Future.microtask(() async {
      await _notiService.connect();
      _messageSubscription = _notiService.onMessageUpdate.listen((message) {
        final notificationType = getNotificationType(message.entityType);
        final payload = jsonEncode({
          'entityId': message.entityId,
          'entityType': message.entityType,
          'notificationId': message.notificationId,
          'senderName': message.senderName, // Thêm senderName
          'senderAvatar': message.senderAvatar, // Thêm senderAvatar
          'message': message.message, // Thêm message
          'isRead': message.isRead, // Thêm isRead
          'createdAt': message.createdAt, // Thêm createdAt
          'messageId': message.messageId, // Thêm messageId
        });

        INotificationService.showNotification(
          id: message.entityType * 1000 + message.entityId, // ID duy nhất
          type: notificationType,
          title: _getNotificationTitle(message, notificationType),
          body: message.message,
          payload: payload,
        );
      });
    }); // TODO: implement initState
    super.initState();
  }

  String _getNotificationTitle(
      NotificationModel message, NotificationType type) {
    switch (type) {
      case NotificationType.commentBlog:
        return 'New Blog Comment';
      case NotificationType.blogReplyReReply:
        return 'Reply to Your Comment';
      case NotificationType.blogReplyComment:
        return 'Reply to Blog Comment';
      case NotificationType.reactionComment:
        return 'Comment Reaction';
      case NotificationType.reactionBlog:
        return 'Blog Reaction';
      case NotificationType.blogReactionReply:
        return 'Reply Reaction';
      case NotificationType.reviewService:
        return 'Service Review';
      case NotificationType.replyReview:
        return 'Reply to Review';
      case NotificationType.bookingService:
        return 'Booking Update';
      case NotificationType.reviewRoute:
        return 'Route Review';
      case NotificationType.routeReactionRoute:
        return 'Route Reaction';
      case NotificationType.routeReplyReview:
        return 'Reply to Route Review';
      case NotificationType.routeReplyReReply:
        return 'Reply to Route Comment';
      case NotificationType.reactionReview:
        return 'Review Reaction';
      case NotificationType.routeReactionReply:
        return 'Route Reply Reaction';
      case NotificationType.message:
        return 'New Message';
      case NotificationType.subscription:
        return 'System Update';
      case NotificationType.route:
        return 'Route Update';
      case NotificationType.user:
        return 'User Action';
      case NotificationType.challenge:
        return 'New Challenge';
      case NotificationType.groupInvitation:
        return 'Group Invitation';
      case NotificationType.group:
        return 'Group Update';
      default:
        return 'New Notification';
    }
  }

  @override
  void dispose() {
    _messageSubscription.cancel();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                GetBookingCubit()..getBooking(GetBookingReq(status: 'Pending')),
          ),
          BlocProvider(
              create: (context) => ShopProfileCubit()..getShopProfile()),
        ],
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthChangeRole) {
              Future.microtask(() {
                AppNavigator.pushAndRemove(context, BottomNavBarManager());
              });
            }
            if (state is AuthFailure) {
              if (state.failure is AuthenticationFailure) {
                sl<AuthCubit>().logout();
                Future.microtask(() {
                  AppNavigator.pushAndRemove(context, LoginPage());
                });
              }
            }
          },
          child: Scaffold(
              appBar: BasicAppbar(
                action: _buildActionIcons(),
                hideBack: true,
                title: Text(
                  'Dashboard',
                  style: TextStyle(
                      fontSize: AppSize.textHeading,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              body: BlocBuilder<ShopProfileCubit, ShopProfileState>(
                builder: (context, state) {
                  if (state is ShopProfileLoaded) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<ShopProfileCubit>().getShopProfile();
                      },
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            InkWell(
                                onTap: () => AppNavigator.push(
                                    context,
                                    ShopOwnerProfileScreen(
                                      shopProfile: state.shopPrifile,
                                    )),
                                child: _buildShopInfoCard(
                                    isDark, state.shopPrifile)),
                            SizedBox(height: 16.0),
                            Text('Quick stats',
                                style: TextStyle(
                                    fontSize: AppSize.textHeading,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black87,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatisticCard(
                                  ontap: () => AppNavigator.push(
                                      context, BookingManagementScreen()),
                                  title: 'Pending Booking',
                                  value: state.shopPrifile.totalPendingBooking
                                      .toString(),
                                  icon: Icons.event,
                                  color: Colors.blue,
                                ),
                                _buildStatisticCard(
                                  ontap: () => AppNavigator.push(
                                      context,
                                      ServiceManagementPage(
                                          shopId: state.shopPrifile.shopId!)),
                                  title: 'Service',
                                  value:
                                      state.shopPrifile.totalService.toString(),
                                  icon: Icons.directions_bike,
                                  color: Colors.orange,
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatisticCard(
                                  ontap: () => AppNavigator.push(
                                      context,
                                      BookingManagementScreen(
                                        initialIndex: 4,
                                      )),
                                  title: 'Completed booking',
                                  value:
                                      state.shopPrifile.totalBooking.toString(),
                                  icon: Icons.check_circle_outline,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Text('Recent Bookings',
                                style: TextStyle(
                                    fontSize: AppSize.textLarge,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black87,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 8.0),
                            BlocBuilder<GetBookingCubit, GetBookingState>(
                              builder: (context, state) {
                                if (state is GetBookingLoaded) {
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: state.bookingList.length,
                                    separatorBuilder: (context, index) =>
                                        Divider(),
                                    itemBuilder: (context, index) {
                                      final booking = state.bookingList[index];
                                      return ListTile(
                                        leading: Icon(Icons.event),
                                        title: Text(booking.cyclistName!),
                                        subtitle: Text(
                                            '${state.bookingList[index].serviceName}'),
                                        trailing:
                                            _buildStatusChip(booking.status!),
                                        onTap: () {
                                          AppNavigator.push(
                                              context,
                                              BookingDetailShopScreen(
                                                  bookingId: state
                                                      .bookingList[index]
                                                      .bookingDetailId!));
                                        },
                                      );
                                    },
                                  );
                                } else if (state is GetBookingLoading ||
                                    state is GetBookingInitial) {
                                  ServiceCardPlaceHolder();
                                } else if (state is GetBookingFailure) {
                                  if (state.failure is AuthenticationFailure) {
                                    sl<LogoutUseCase>().call(NoParams());
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      AppNavigator.pushReplacement(
                                          context, LoginPage());
                                    });
                                  }
                                }
                                return Center(
                                    child: Column(
                                  children: [
                                    Image.asset(
                                      AppImages.error,
                                      width: AppSize.imageLarge,
                                    ),
                                    Text('Can\'t load booking....'),
                                    IconButton(
                                        onPressed: () async {
                                          // await context.read<GetBlogCubit>().getBlog(GetBlogReq());
                                        },
                                        icon: Icon(
                                          Icons.refresh_outlined,
                                          size: AppSize.iconLarge,
                                        ))
                                  ],
                                ));
                              },
                            ),
                            SizedBox(height: 24.0),
                            Text('Shortcut Key',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 16.0),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildQuickActionButton(
                                      icon: Icons.book_online,
                                      label: 'Booking Management',
                                      onTap: () {
                                        AppNavigator.push(
                                            context, BookingManagementScreen());
                                      },
                                    ),
                                    _buildQuickActionButton(
                                      icon: Icons.directions_bike,
                                      label: 'Service Management',
                                      onTap: () {
                                        AppNavigator.push(
                                            context,
                                            ServiceManagementPage(
                                              shopId: 7,
                                            ));
                                      },
                                    ),
                                  ],
                                ),
                                _buildQuickActionButton(
                                  icon: Icons.logout_rounded,
                                  label: 'Back To Tracio',
                                  onTap: () async {
                                    var refreshToken =
                                        await sl<AuthLocalSource>()
                                            .getRefreshToken();
                                    context.read<AuthCubit>().changeRole(
                                        ChangeRoleReq(
                                            refreshToken: refreshToken,
                                            role: 'user'));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (state is ShopProfileLoading) {
                    return Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                        color: AppColors.secondBackground,
                        size: AppSize.iconExtraLarge,
                      ),
                    );
                  }
                  if (state is ShopProfileFailure) {
                    if (state.failure is AuthenticationFailure) {
                      Future.microtask(() {
                        AppNavigator.pushAndRemove(
                            context, BottomNavBarManager());
                      });
                    }
                    ErrorPage();
                  }
                  return SizedBox.shrink();
                },
              )),
        ));
  }

  Widget _buildActionIcons() {
    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          highlightColor: Colors.grey.shade600,
          splashColor: Colors.white.withAlpha(30),
          hoverColor: Colors.white.withAlpha(10),
          onPressed: () {
            AppNavigator.push(context, NotificationsPage());
          },
          icon: Icon(
            Icons.notifications,
            color: AppColors.primary,
            size: AppSize.iconMedium.w,
          ),
          tooltip: "Notifications",
        ),
        IconButton(
          padding: EdgeInsets.zero,
          highlightColor: Colors.grey.shade600,
          splashColor: Colors.white.withAlpha(30),
          hoverColor: Colors.white.withAlpha(10),
          onPressed: () {
            AppNavigator.push(
                context,
                BlocProvider.value(
                  value: context.read<ConversationBloc>()
                    ..add(GetConversations()),
                  child: ConversationScreen(),
                ));
          },
          icon: Icon(
            Icons.message_outlined,
            color: AppColors.primary,
            size: AppSize.iconMedium.w,
          ),
          tooltip: "Message",
        ),
      ],
    );
  }

  Widget _buildShopInfoCard(bool isDark, ShopProfileEntity shopProfile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CirclePicture(
                imageUrl: shopProfile.profilePicture!,
                imageSize: AppSize.iconLarge),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shopProfile.shopName!,
                    style: TextStyle(
                      fontSize: AppSize.textLarge,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    '${shopProfile.address} - ${shopProfile.district} - ${shopProfile.city}',
                    style: TextStyle(
                      fontSize: AppSize.textSmall,
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSize.apHorizontalPadding * .8.h),
                    height: 28,
                    // width: 100,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: AppColors.secondBackground),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          color: isDark
                              ? AppColors.secondBackground
                              : AppColors.background,
                          size: AppSize.iconSmall,
                        ),
                        Text(
                          '${shopProfile.openTime!.substring(0, 5)} - ${shopProfile.closedTime!.substring(0, 5)}',
                          style: TextStyle(
                            color:
                                isDark ? Colors.grey.shade300 : Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: AppSize.textSmall,
                          ),
                        ),
                      ],
                    ),
                  )
                  // SizedBox(height: 8.0),
                  // Row(
                  //   children: [
                  //     Icon(Icons.star, color: Colors.amber, size: 16.0),
                  //     SizedBox(width: 4.0),
                  //     Text(
                  //       '${_shopRating.toStringAsFixed(1)}',
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         color: isDark ? Colors.white : Colors.black,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback ontap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: ontap,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: color),
                SizedBox(height: 8.0),
                Text(title, style: TextStyle(fontSize: 16)),
                Text(value,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Pending':
        color = Colors.orange;
        break;
      case 'Reschedule':
        color = Colors.yellow;
        break;
      case 'Confirm':
        color = Colors.green;
        break;
      case 'Completed':
        color = Colors.grey;
        break;
      case 'Waiting':
        color = Colors.blueAccent;
        break;
      case 'Canceled':
        color = Colors.redAccent;
        break;
      default:
        color = Colors.black;
    }
    return Chip(
      label: Text(status, style: TextStyle(color: Colors.white)),
      backgroundColor: color,
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 36, color: Theme.of(context).primaryColor),
          SizedBox(height: 8.0),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
