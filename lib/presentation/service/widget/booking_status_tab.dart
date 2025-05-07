import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/presentation/service/bloc/bookingservice/reschedule_booking/cubit/reschedule_booking_cubit.dart';
import 'package:Tracio/presentation/service/page/booking_detail.dart';
import '../../../core/constants/app_size.dart';
import '../../../data/shop/models/get_booking_req.dart';
import '../../../domain/shop/entities/response/booking_card_view.dart';
import '../../../domain/shop/entities/response/booking_entity.dart';
import '../bloc/bookingservice/booking_service_cubit.dart';
import '../bloc/bookingservice/booking_service_state.dart';
import '../bloc/get_booking/get_booking_cubit.dart';
import '../bloc/get_booking/get_booking_state.dart';
import 'booking_card.dart';
import 'resolve_booking.dart';
import 'show_schedule_bottom.dart';

class BookingStatusTab extends StatefulWidget {
  final String status;
  final AnimationController animationController;
  final String? textBtn;
  const BookingStatusTab({
    super.key,
    required this.status,
    required this.animationController,
    this.textBtn,
  });

  @override
  State<BookingStatusTab> createState() => _BookingStatusTabState();
}

class _BookingStatusTabState extends State<BookingStatusTab> {
  @override
  void initState() {
    super.initState();
    context
        .read<GetBookingCubit>()
        .getBooking(GetBookingReq(status: widget.status));
    widget.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RescheduleBookingCubit, ResolveBookingState>(
      listener: (context, state) {
        if (state is RescheduleBookingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Reschedule successfuly')),
          );

          context.read<GetBookingCubit>().getBooking(
                GetBookingReq(status: widget.status),
              );
        } else if (state is RescheduleBookingFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Reschedule Fail, Try Again')),
          );
        }
      },
      builder: (context, state) {
        return BlocBuilder<GetBookingCubit, GetBookingState>(
          builder: (context, state) {
            if (state is GetBookingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetBookingLoaded) {
              if (state.bookingList.isEmpty &&
                  state.overlapBookingList.isEmpty) {
                return const Center(child: Text("booking is empty"));
              }

              var list = state.bookingList;
              var listOverlap = state.overlapBookingList;
              return Stack(children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                      bottom: 40 + (AppSize.apVerticalPadding * 2)),
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    spacing: 6,
                    children: [
                      listBooking(list),
                      listOverlap.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      AppSize.apHorizontalPadding * .2.w,
                                  vertical: AppSize.apVerticalPadding * .4.h),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        AppSize.apHorizontalPadding * .2.w,
                                    vertical: AppSize.apVerticalPadding * .4.h),
                                decoration: BoxDecoration(
                                    color: Colors.red.shade100,
                                    borderRadius: BorderRadius.circular(
                                        AppSize.borderRadiusMedium)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Overlap in: ${DateFormat('HH:mm, dd/MM/yyyy').format(listOverlap.first.bookedDate!)}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red,
                                          fontSize: AppSize.textMedium),
                                    ),
                                    listBooking(listOverlap),
                                  ],
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: BlocBuilder<BookingServiceCubit, BookingServiceState>(
                    builder: (context, bookState) {
                      var reschedule =
                          context.read<BookingServiceCubit>().reschedule;
                      return reschedule.isNotEmpty
                          ? Container(
                              color: Colors.white,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSize.apHorizontalPadding.w,
                                    vertical: AppSize.apVerticalPadding.h * .2,
                                  ),
                                  child: ShowScheduleBottom()),
                            )
                          : SizedBox.shrink();
                    },
                  ),
                ),
              ]);
            } else {
              return const Center(child: Text("Failed to load bookings"));
            }
          },
        );
      },
    );
  }

  Widget listBooking(List<BookingEntity> bookings) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            var animation = Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: widget.animationController,
                curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
              ),
            );
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: BookingCard(
                  ontap: () => AppNavigator.push(
                      context,
                      BookingDetailScreen(
                          bookingId: bookings[index].bookingDetailId!,
                          animationController: widget.animationController)),
                  service: BookingCardViewModel(
                    imageUrl: bookings[index].serviceMediaFile,
                    shopName: bookings[index].shopName,
                    duration: bookings[index].duration,
                    nameService: bookings[index].serviceName,
                    price: bookings[index].price,
                  ),
                  animation: animation,
                  animationController: widget.animationController,
                  moreWidget: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: getStatusColor(bookings[index].status!),
                          borderRadius:
                              BorderRadius.circular(AppSize.borderRadiusSmall),
                          border: Border.all(
                            color:
                                getStatusBorderColor(bookings[index].status!),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              bookings[index].status!,
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
                      (widget.status == 'Pending' ||
                              widget.status == 'Reschedule' ||
                              widget.status == 'Confirmed')
                          ? ResolveBooking(
                              // isReview: state.bookingList[index].,
                              isDone: false,
                              textBtn: widget.textBtn,
                              // bookingId:
                              //     state.bookingList[index].bookingDetailId!,
                              animationController: widget.animationController,
                              booking: BookingCardViewModel(
                                imageUrl: bookings[index].serviceMediaFile,
                                bookingDetailId:
                                    bookings[index].bookingDetailId,
                                bookedDate: bookings[index].bookedDate,
                                shopName: bookings[index].shopName,
                                nameService: bookings[index].serviceName,
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  )),
            );
          },
        ),
        // BlocBuilder<BookingServiceCubit, BookingServiceState>(
        //   builder: (context, bookState) {
        //     var reschedule = context.read<BookingServiceCubit>().reschedule;
        //     return reschedule.isNotEmpty
        //         ? Padding(
        //             padding: EdgeInsets.symmetric(
        //               horizontal: AppSize.apHorizontalPadding.w,
        //               vertical: AppSize.apVerticalPadding.h,
        //             ),
        //             child: ShowScheduleBottom())
        //         : SizedBox.shrink();
        //   },
        // ),
      ],
    );
  }
}

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Colors.orange.shade100;
    case 'reschedule':
      return Colors.purple.shade100;
    case 'confirmed':
      return Colors.blue.shade100;
    case 'processing':
      return Colors.amber.shade100;
    case 'completed':
      return Colors.green.shade100;
    case 'cancelled':
      return Colors.red.shade100;
    default:
      return Colors.grey.shade200;
  }
}

Color getStatusBorderColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Colors.orange;
    case 'reschedule':
      return Colors.purple;
    case 'confirmed':
      return Colors.blue;
    case 'processing':
      return Colors.amber;
    case 'completed':
      return Colors.green;
    case 'cancelled':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
