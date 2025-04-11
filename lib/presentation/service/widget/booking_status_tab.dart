import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_size.dart';
import '../../../data/shop/models/get_booking_req.dart';
import '../../../domain/shop/entities/response/booking_card_view.dart';
import '../bloc/get_booking/get_booking_cubit.dart';
import '../bloc/get_booking/get_booking_state.dart';
import 'booking_card.dart';
import 'resolve_booking.dart';

class BookingStatusTab extends StatefulWidget {
  final String status;
  final AnimationController animationController;
  final bool hasSolve;
  final String? textBtn;
  const BookingStatusTab({
    super.key,
    required this.status,
    required this.animationController,
    this.hasSolve = false,
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
    return BlocBuilder<GetBookingCubit, GetBookingState>(
      builder: (context, state) {
        if (state is GetBookingLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetBookingLoaded) {
          if (state.bookingList.isEmpty) {
            return const Center(child: Text("booking is empty"));
          }
          var list = state.bookingList;
          return ListView.builder(
            itemCount: list.length,
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
                  service: BookingCardViewModel(
                    shopName: list[index].shopName,
                    duration: list[index].duration,
                    nameService: list[index].serviceName,
                    price: list[index].price,
                  ),
                  animation: animation,
                  animationController: widget.animationController,
                  moreWidget: widget.hasSolve
                      ? Column(
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
                              textBtn: widget.textBtn,
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
                        )
                      : Container(),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text("Failed to load bookings"));
        }
      },
    );
  }
}
