import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tracio_fe/presentation/shop_owner/bloc/cubit/resolve_booking_cubit.dart';
import 'package:tracio_fe/presentation/shop_owner/bloc/cubit/resolve_booking_state.dart';

import '../../../core/constants/app_size.dart';

class BookingInformation extends StatefulWidget {
  const BookingInformation(
      {super.key, this.start, this.end, this.duration, this.price});
  final DateTime? start;
  final DateTime? end;
  final String? duration;
  final String? price;
  @override
  State<BookingInformation> createState() => _BookingInformationState();
}

class _BookingInformationState extends State<BookingInformation> {
  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    final DateFormat timeFormat = DateFormat('HH:mm');
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: AppSize.apHorizontalPadding,
            vertical: AppSize.apVerticalPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: BlocBuilder<ResolveBookingShopCubit, ResolveBookingShopState>(
          builder: (context, state) {
            // Dữ liệu mặc định từ widget hoặc state
            final DateTime? displayStartDate =
                state is UpdateParamsWaitingBooking
                    ? state.bookedDate
                    : widget.start;
            final DateTime? displayEndDate = state is UpdateParamsWaitingBooking
                ? state.estimatedEndDate
                : widget.end;

            final String startDateString = displayStartDate != null
                ? dateFormat.format(displayStartDate)
                : 'Not Set';
            final String startTimeString = displayStartDate != null
                ? timeFormat.format(displayStartDate)
                : '--:--';

            final String endDateString = displayEndDate != null
                ? dateFormat.format(displayEndDate)
                : 'Waiting';
            final String endTimeString = displayEndDate != null
                ? timeFormat.format(displayEndDate)
                : '--:--';

            return Column(
              children: [
                Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Service Type',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Service',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Repair Start',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            startDateString,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text(startTimeString),
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.orange, width: 2),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Container(
                            width: 2,
                            height: 100,
                            color: Colors.orange,
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orange,
                            ),
                          ),
                          Text(endTimeString),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Service Complete',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            endDateString,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Duration',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: AppSize.textMedium,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.duration!,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: AppSize.textSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Price :',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '\$ ${widget.price}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ));
  }
}
