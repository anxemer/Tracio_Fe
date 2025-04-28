import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/presentation/service/page/review_booking.dart';
import 'package:tracio_fe/presentation/service/widget/review_service.dart';

import '../../../common/widget/button/button.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../../../domain/shop/entities/response/booking_card_view.dart';
import '../../../domain/shop/usecase/process_booking.dart';
import '../../../service_locator.dart';
import '../bloc/bookingservice/booking_service_cubit.dart';
import '../bloc/bookingservice/resolve_overlap_service/cubit/resolve_overlap_service_cubit.dart';
import 'booking_card.dart';

class ResolveBooking extends StatefulWidget {
  const ResolveBooking({
    super.key,
    // required this.bookingId,
    required this.animationController,
    required this.booking,
    this.textBtn,
    required this.isDone,
    this.isReview = false,
  });
  // final int bookingId;
  final BookingCardViewModel booking;
  final AnimationController? animationController;
  final String? textBtn;
  final bool isDone;
  final bool isReview;
  @override
  State<ResolveBooking> createState() => _ResolveBookingState();
}

class _ResolveBookingState extends State<ResolveBooking> {
  @override
  void initState() {
    widget.animationController?.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bookingCubit = context.read<BookingServiceCubit>();
    var isDark = context.isDarkMode;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        bookingCubit.reschedule.contains(widget.booking.bookingDetailId)
            ? ButtonDesign(
                width: 120.w,
                height: 32.h,
                ontap: () {
                  setState(() {});
                  context.read<ResolveOverlapServiceCubit>().markAction(
                      widget.booking.bookingDetailId!,
                      OverlapActionStatus.rescheduled);
                  bookingCubit
                      .removeRescheduleBooking(widget.booking.bookingDetailId!);
                },
                text: 'Selected',
                fillColor: Colors.green.shade200,
                textColor: isDark ? Colors.white70 : Colors.black,
                borderColor: isDark ? Colors.grey.shade200 : Colors.black87,
                fontSize: AppSize.textSmall,
              )
            : ButtonDesign(
                width: 120.w,
                height: 32.h,
                ontap: () {
                  setState(() {});
                  context.read<ResolveOverlapServiceCubit>().markAction(
                      widget.booking.bookingDetailId!,
                      OverlapActionStatus.rescheduled);
                  bookingCubit
                      .addRescheduleBooking(widget.booking.bookingDetailId!);
                },
                text: 'Reschedule',
                fillColor: Colors.transparent,
                textColor: isDark ? Colors.white70 : Colors.black,
                borderColor: isDark ? Colors.grey.shade200 : Colors.black87,
                fontSize: AppSize.textSmall,
              ),
        SizedBox(
          width: 20.w,
        ),
        widget.isDone
            ? ButtonDesign(
                width: 120.w,
                height: 32.h,
                ontap: () async {
                  widget.isReview
                      ? ReviewService(
                          bookingDetailId: widget.booking.bookingDetailId!,
                        )
                      : AppNavigator.push(
                          context,
                          ReviewBookingScreen(
                            bookingId: widget.booking.bookingDetailId!,
                            imageUrl: widget.booking.imageUrl!,
                            serviceName: widget.booking.nameService!,
                          ));
                },
                text: widget.isReview ? 'View Review' : 'Review',
                fillColor: AppColors.secondBackground,
                textColor: isDark ? Colors.grey.shade200 : Colors.white,
                borderColor:
                    context.isDarkMode ? Colors.grey.shade200 : Colors.black87,
                fontSize: AppSize.textSmall)
            : ButtonDesign(
                width: 120.w,
                height: 32.h,
                ontap: () async {
                  // AppNavigator.push(context, ReviewBookingScreen());
                  showDialogConfirmation(widget.booking);
                },
                text: 'Cancel',
                fillColor: AppColors.secondBackground,
                textColor: isDark ? Colors.grey.shade200 : Colors.white,
                borderColor:
                    context.isDarkMode ? Colors.grey.shade200 : Colors.black87,
                fontSize: AppSize.textSmall,
              )
      ],
    );
  }

  void showDialogConfirmation(BookingCardViewModel service) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        var animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn)));
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(20),
          children: [
            Icon(Icons.info_outline_rounded,
                size: AppSize.iconSmall, color: Colors.black38),
            SizedBox(
              width: 10,
            ),
            Text(
              'Are you sure you want to cancel this booking?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: AppSize.textMedium,
              ),
            ),
            // BookingCard(
            //     imageSize: AppSize.iconMedium,
            //     animationController: widget.animationController,
            //     animation: animation,
            //     service: service),
            SizedBox(
              width: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      sl<ProcessBookingUseCase>()
                          .call(service.bookingDetailId!);
                      // showDialogConfirmation(service
                      // BookingCardViewModel(
                      //   bookingDetailId: service.bookingDetailId,
                      //   bookedDate: service.bookedDate,
                      //   shopName: se.shopName,
                      //   nameService: booking.serviceName,
                      // ),
                      // );

                      Navigator.pop(context, 'yes');
                    },
                    style: ButtonStyle(
                      backgroundColor: const WidgetStatePropertyAll(Colors.red),
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.white),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                          fontSize: AppSize.textMedium,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, 'no');
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.black54),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    child: Text('Reschedule',
                        style: TextStyle(
                            fontSize: AppSize.textMedium,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (result == null) return;
    if (result is! String) return;
    if (result == 'no') {
      return;
    }
    if (result == 'yes') {
      context
          .read<ResolveOverlapServiceCubit>()
          .markAction(service.bookingDetailId!, OverlapActionStatus.confirmed);

      return;
    }
  }
}
