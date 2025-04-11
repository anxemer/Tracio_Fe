import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/data/shop/models/get_booking_req.dart';
import 'package:tracio_fe/domain/shop/entities/response/booking_card_view.dart';
import 'package:tracio_fe/presentation/service/bloc/bookingservice/cubit/get_booking_detail_cubit.dart';
import 'package:tracio_fe/presentation/service/bloc/bookingservice/resolve_overlap_service/cubit/resolve_overlap_service_cubit.dart';
import 'package:tracio_fe/presentation/service/bloc/get_booking/get_booking_cubit.dart';
import 'package:tracio_fe/presentation/service/page/booking_detail.dart';
import 'package:tracio_fe/presentation/service/widget/booking_card.dart';
import 'package:tracio_fe/presentation/service/widget/resolve_booking.dart';

import '../../../core/constants/app_size.dart';
import '../../shop_owner/page/booking_detail_shop.dart';
import '../bloc/bookingservice/booking_service_cubit.dart';
import '../bloc/get_booking/get_booking_state.dart';
import 'show_schedule_bottom.dart';

class PendingService extends StatefulWidget {
  const PendingService({
    super.key,
    required this.animationController,
  });
  final AnimationController animationController;
  // final List<ShopServiceEntity> servicePending;

  @override
  State<PendingService> createState() => _PendingServiceState();
}

class _PendingServiceState extends State<PendingService> {
  @override
  void initState() {
    context.read<ResolveOverlapServiceCubit>().clearAll();
    context.read<BookingServiceCubit>().clearBookingItem();
    context
        .read<GetBookingCubit>()
        .getBooking(GetBookingReq(status: 'pending'));
    widget.animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    return BlocBuilder<GetBookingCubit, GetBookingState>(
      builder: (context, state) {
        var countReschedule =
            context.watch<BookingServiceCubit>().reschedule.length;
        if (state is GetBookingLoaded) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
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
                            BlocProvider.value(
                              value:
                                  BlocProvider.of<ResolveOverlapServiceCubit>(
                                      context),
                              child: BlocProvider.value(
                                value: BlocProvider.of<GetBookingDetailCubit>(
                                    context),
                                child: BookingDetailScreen(
                                  bookingId:
                                      state.bookingList[index].bookingDetailId!,
                                  animationController:
                                      widget.animationController,
                                ),
                              ),
                            )),
                        service: BookingCardViewModel(
                            bookingDetailId:
                                state.bookingList[index].bookingDetailId,
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
                                    'Pending',
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
                                textBtn: 'Cancel',
                                // bookingId:
                                // state.bookingList[index].bookingDetailId!,
                                animationController: widget.animationController,
                                booking: BookingCardViewModel(
                                    bookingDetailId: state
                                        .bookingList[index].bookingDetailId!,
                                    shopName: state.bookingList[index].shopName,
                                    duration: state.bookingList[index].duration,
                                    nameService:
                                        state.bookingList[index].serviceName,
                                    price: state.bookingList[index].price))
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
