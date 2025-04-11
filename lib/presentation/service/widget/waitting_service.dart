import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/presentation/service/bloc/bookingservice/booking_service_cubit.dart';
import 'package:tracio_fe/presentation/service/bloc/get_booking/get_booking_cubit.dart';
import 'package:tracio_fe/presentation/service/page/booking_detail.dart';
import 'package:tracio_fe/presentation/service/widget/booking_status_tab.dart';
import 'package:tracio_fe/presentation/service/widget/overlap_service.dart';
import 'package:tracio_fe/presentation/service/widget/resolve_booking.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../../../data/shop/models/get_booking_req.dart';
import '../../../domain/shop/entities/response/booking_card_view.dart';
import '../bloc/bookingservice/resolve_overlap_service/cubit/resolve_overlap_service_cubit.dart';
import '../bloc/get_booking/get_booking_state.dart';
import 'booking_card.dart';
import 'show_schedule_bottom.dart';

class WaittingService extends StatefulWidget {
  const WaittingService({super.key, required this.animationController});
  final AnimationController animationController;
  @override
  State<WaittingService> createState() => _WaittingServiceState();
}

class _WaittingServiceState extends State<WaittingService> {
  @override
  void initState() {
    context.read<ResolveOverlapServiceCubit>().clearAll();
    context.read<BookingServiceCubit>().clearBookingItem();
    context
        .read<GetBookingCubit>()
        .getBooking(GetBookingReq(status: 'Waiting'));
    widget.animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    return DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
          body: Column(
            children: [
              Container(
                width: double.infinity,
                color: isDark ? AppColors.darkGrey : Colors.white,
                child: TabBar(
                    labelStyle: TextStyle(
                        fontSize: AppSize.textMedium,
                        fontWeight: FontWeight.w600),
                    unselectedLabelColor:
                        isDark ? Colors.white70 : Colors.black87,
                    labelColor: isDark ? AppColors.primary : Colors.black,
                    indicatorColor: AppColors.primary,
                    tabs: [
                      Tab(
                        text: 'Waiting',
                      ),
                      Tab(
                        text: 'Overlap',
                      ),
                      Tab(
                        text: 'Reschedule',
                      )
                    ]),
              ),
              Expanded(
                child: TabBarView(children: [
                  _waitingService(context),
                  // BookingStatusTab(
                  //   animationController: widget.animationController,
                  //   status: 'waiting',
                  //   hasSolve: true,
                  // ),
                  OverlapService(
                      animationController: widget.animationController),
                  BookingStatusTab(
                    status: 'reschedule',
                    animationController: widget.animationController,
                    hasSolve: false,
                  )
                ]),
              )
            ],
          ),
        ));
  }

  Widget _waitingService(BuildContext context) {
    return BlocBuilder<GetBookingCubit, GetBookingState>(
      builder: (context, state) {
        if (state is GetBookingLoaded) {
          var countReschedule =
              context.watch<BookingServiceCubit>().reschedule.length;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: state.bookingList.length,
                  itemBuilder: (context, index) {
                    var animation = Tween(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.animationController,
                            curve: Interval(0.0, 1.0,
                                curve: Curves.fastOutSlowIn)));
                    widget.animationController.forward();
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BookingCard(
                        ontap: () => AppNavigator.push(
                            context,
                            BookingDetailScreen(
                                animationController: widget.animationController,
                                bookingId:
                                    state.bookingList[index].bookingDetailId!)),
                        service: BookingCardViewModel(
                            shopName: state.bookingList[index].shopName,
                            duration: state.bookingList[index].duration,
                            nameService: state.bookingList[index].serviceName,
                            price: state.bookingList[index].price),
                        animation: animation,
                        animationController: widget.animationController,
                        moreWidget: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(
                                    AppSize.borderRadiusSmall),
                                border: Border.all(
                                  color: Colors.green.shade100,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    state.bookingList[index].status!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: AppSize.textMedium,
                                      color: Colors.black87,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            ResolveBooking(
                              // bookingId:
                              //     state.bookingList[index].bookingDetailId!,
                              animationController: widget.animationController,
                              booking: BookingCardViewModel(
                                bookingDetailId:
                                    state.bookingList[index].bookingDetailId,
                                bookedDate: state.bookingList[index].bookedDate,
                                shopName: state.bookingList[index].shopName,
                                nameService:
                                    state.bookingList[index].serviceName,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              countReschedule != 0
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppSize.apHorizontalPadding.w,
                          vertical: AppSize.apVerticalPadding.h),
                      child: ShowScheduleBottom())
                  : Container()
            ],
          );
        } else if (state is GetBookingFailure || state is GetBookingLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return Container();
      },
    );
  }
}
