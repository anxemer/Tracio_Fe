import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/presentation/service/bloc/bookingservice/get_booking_detail_cubit/get_booking_detail_cubit.dart';
import 'package:Tracio/presentation/service/bloc/bookingservice/resolve_overlap_service/cubit/resolve_overlap_service_cubit.dart';
import 'package:Tracio/presentation/service/bloc/get_booking/get_booking_cubit.dart';
import 'package:Tracio/presentation/service/widget/booking_status_tab.dart';

import '../../../core/configs/theme/app_colors.dart';

class MyBookingPage extends StatefulWidget {
  const MyBookingPage({super.key});
  // final List<ShopServiceEntity> serviceBooking;

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage>
    with TickerProviderStateMixin {
  late AnimationController tabAnimationController;
  late AnimationController screenAnimationController;

  @override
  void initState() {
    screenAnimationController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    tabAnimationController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    indexView = BookingStatusTab(
      status: 'Pending',
      animationController: tabAnimationController,
    );
    tabAnimationController.forward();
    screenAnimationController.forward();
    // widget.animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    screenAnimationController.dispose();

    tabAnimationController.dispose();
    super.dispose();
  }

  Widget indexView = Container();
  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetBookingCubit(),
        ),
        BlocProvider(
          create: (context) => ResolveOverlapServiceCubit(),
        ),
        BlocProvider(
          create: (context) => GetBookingDetailCubit(),
        ),
      ],
      child: Scaffold(
          appBar: BasicAppbar(
            title: Text('My Booking',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.textHeading,
                )),
          ),
          body: DefaultTabController(
              length: 7,
              initialIndex: 0,
              child: Scaffold(
                body: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: isDark ? AppColors.darkGrey : Colors.white,
                      child: TabBar(
                          padding: EdgeInsets.only(left: 0),
                          isScrollable: true,
                          labelStyle: TextStyle(
                              fontSize: AppSize.textMedium,
                              fontWeight: FontWeight.w600),
                          unselectedLabelColor:
                              isDark ? Colors.white70 : Colors.grey.shade500,
                          labelColor: isDark ? AppColors.primary : Colors.black,
                          indicatorColor: AppColors.primary,
                          tabs: [
                            Tab(
                              text: 'Pending',
                            ),
                            Tab(
                              text: 'Reschedule',
                            ),
                            Tab(
                              text: 'Confirmed',
                            ),
                            Tab(
                              text: 'Processing',
                            ),
                            Tab(
                              text: 'Completed',
                            ),
                            Tab(
                              text: 'Canceled',
                            ),
                            Tab(
                              text: 'Not Arrive',
                            )
                          ]),
                    ),
                    Expanded(
                      child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            BookingStatusTab(
                              status: 'Pending',
                              animationController: tabAnimationController,
                            ),
                            BookingStatusTab(
                              status: 'Reschedule',
                              animationController: tabAnimationController,
                            ),
                            BookingStatusTab(
                              status: 'Confirmed',
                              animationController: tabAnimationController,
                            ),
                            BookingStatusTab(
                              status: 'Processing',
                              animationController: tabAnimationController,
                            ),
                            BookingStatusTab(
                              status: 'Completed',
                              animationController: tabAnimationController,
                            ),
                            BookingStatusTab(
                              status: 'Cancelled',
                              animationController: tabAnimationController,
                            ),
                            BookingStatusTab(
                              status: 'NotArrive',
                              animationController: tabAnimationController,
                            ),
                          ]),
                    )
                  ],
                ),
              ))),
    );
  }
}
