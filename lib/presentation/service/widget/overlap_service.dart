import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/domain/shop/entities/response/booking_entity.dart';
import 'package:tracio_fe/domain/shop/usecase/submit_booking.dart';
import 'package:tracio_fe/presentation/service/bloc/bookingservice/booking_service_cubit.dart';
import 'package:tracio_fe/presentation/service/bloc/bookingservice/resolve_overlap_service/cubit/resolve_overlap_service_cubit.dart';
import 'package:tracio_fe/presentation/service/bloc/get_booking/get_booking_cubit.dart';
import 'package:tracio_fe/presentation/service/page/booking_detail.dart';
import 'package:tracio_fe/presentation/service/widget/booking_card.dart';
import 'package:tracio_fe/presentation/service/widget/show_schedule_bottom.dart';
import 'package:tracio_fe/service_locator.dart';

import '../../../common/widget/button/button.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../../../domain/shop/entities/response/booking_card_view.dart';
import '../bloc/get_booking/get_booking_state.dart';

class OverlapService extends StatefulWidget {
  const OverlapService({super.key, required this.animationController});

  final AnimationController animationController;
  @override
  State<OverlapService> createState() => _OverlapServiceState();
}

class _OverlapServiceState extends State<OverlapService> {
  List<int> selectedBooking = [];
  @override
  void initState() {
    context.read<ResolveOverlapServiceCubit>().clearAll();
    context.read<BookingServiceCubit>().clearBookingItem();
    super.initState();
  }

  // @override
  // void dispose() {
  //   context.read<ResolveOverlapServiceCubit>().clearAll();
  //   // context.read<BookingServiceCubit>().clearBookingItem();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var countReschedule = context.read<BookingServiceCubit>().reschedule.length;
    var isDark = context.isDarkMode;
    const overlapStatusText = {
      OverlapActionStatus.confirmed: 'Confirmed',
      OverlapActionStatus.rescheduled: 'Rescheduled',
      OverlapActionStatus.cancelled: 'Cancelled',
    };
    final resolvedMap = context.watch<ResolveOverlapServiceCubit>().state;
    final hasAnyConfirmed =
        resolvedMap.containsValue(OverlapActionStatus.confirmed);

    return BlocBuilder<GetBookingCubit, GetBookingState>(
      builder: (context, state) {
        if (state is GetBookingLoaded) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 20, 10, 20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  // borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Overlapping schedules ${state.overlapBookingList.length} services.',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: AppSize.textLarge,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.info_outline_rounded,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.black,
                    ),
                    Column(
                      children: [
                        ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: state.overlapBookingList.length,
                          itemBuilder: (context, index) {
                            final booking = state.overlapBookingList[index];
                            final action = resolvedMap[booking.bookingDetailId];
                            var animation = Tween(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                    parent: widget.animationController,
                                    curve: Interval(0.0, 1.0,
                                        curve: Curves.fastOutSlowIn)));
                            widget.animationController.forward();
                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Time shop choose: ${DateFormat('dd/MM/yyyy HH:mm').format(state.overlapBookingList[index].bookedDate!)}',
                                        style: TextStyle(
                                            fontSize: AppSize.textLarge,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87),
                                      ),
                                      BookingCard(
                                        ontap: () => AppNavigator.push(
                                            context,
                                            BookingDetailScreen(
                                                animationController:
                                                    widget.animationController,
                                                bookingId: state
                                                    .overlapBookingList[index]
                                                    .bookingDetailId!)),
                                        backgroundColor: isDark
                                            ? Colors.grey.shade800
                                            : Colors.white,
                                        useAnimation: true,
                                        imageSize: AppSize.imageSmall,
                                        service: BookingCardViewModel(
                                          shopName: state
                                              .overlapBookingList[index]
                                              .shopName,
                                          nameService: state
                                              .overlapBookingList[index]
                                              .serviceName,
                                        ),
                                        animation: animation,
                                        animationController:
                                            widget.animationController,
                                        moreWidget: Column(
                                          children: [
                                            Container(
                                              width: 200.w,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: action ==
                                                        OverlapActionStatus
                                                            .confirmed
                                                    ? Colors.green.shade50
                                                    : Colors.red.shade50,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppSize
                                                            .borderRadiusSmall),
                                                border: Border.all(
                                                  color: action ==
                                                          OverlapActionStatus
                                                              .confirmed
                                                      ? Colors.green.shade100
                                                      : Colors.red.shade100,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    // resultChoose,
                                                    overlapStatusText[action] ??
                                                        'Overlap',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize:
                                                          AppSize.textMedium,
                                                      color: Colors.black87,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            buttonResolve(
                                                context,
                                                state.overlapBookingList[index],
                                                hasAnyConfirmed)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    )
                  ],
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

  void showDialogConfirmation(BookingCardViewModel service) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        var isDark = context.isDarkMode;
        var animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn)));
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(20),
          children: [
            Icon(Icons.info_outline_rounded,
                size: AppSize.iconMedium,
                color: isDark ? Colors.white70 : Colors.black38),
            SizedBox(
              width: 10,
            ),
            Text(
              'If you confirm the schedule of this service, you will have to  reschedule\n or cancel for other services.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: AppSize.textMedium,
              ),
            ),
            BookingCard(
                imageSize: AppSize.imageSmall,
                animationController: widget.animationController,
                animation: animation,
                service: service),
            SizedBox(
              width: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      sl<SubmitBookingUseCase>().call(service.bookingDetailId!);
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

  Widget buttonResolve(
      BuildContext context, BookingEntity booking, bool hasAnyConfirmed) {
    var bookingCubit = context.read<BookingServiceCubit>();
    var resolveOverlapCubit = context.read<ResolveOverlapServiceCubit>();
    var isDark = context.isDarkMode;

    final currentBookingStatus =
        resolveOverlapCubit.state[booking.bookingDetailId];
    final isCurrentBookingConfirmed =
        currentBookingStatus == OverlapActionStatus.confirmed;

    if (isCurrentBookingConfirmed) {
      return Container();
    }

    if (hasAnyConfirmed) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonDesign(
            width: 120.w,
            height: 32.h,
            ontap: () {
              context.read<ResolveOverlapServiceCubit>().markAction(
                  booking.bookingDetailId!, OverlapActionStatus.cancelled);
            },
            text: 'Cancel',
            fillColor: Colors.transparent,
            textColor: isDark ? Colors.grey.shade200 : Colors.black87,
            borderColor: isDark ? Colors.grey.shade200 : Colors.black87,
            fontSize: AppSize.textSmall,
          ),
          SizedBox(
            width: 20.w,
          ),
          bookingCubit.reschedule.contains(booking.bookingDetailId)
              ? ButtonDesign(
                  width: 120.w,
                  height: 32.h,
                  ontap: () {
                    context.read<ResolveOverlapServiceCubit>().markAction(
                        booking.bookingDetailId!,
                        OverlapActionStatus.rescheduled);
                    bookingCubit
                        .removeRescheduleBooking(booking.bookingDetailId!);
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
                    context.read<ResolveOverlapServiceCubit>().markAction(
                        booking.bookingDetailId!,
                        OverlapActionStatus.rescheduled);
                    bookingCubit.addRescheduleBooking(booking.bookingDetailId!);
                  },
                  text: 'Reschedule',
                  fillColor: AppColors.secondBackground,
                  textColor: Colors.black,
                  borderColor: isDark ? Colors.grey.shade200 : Colors.black87,
                  fontSize: AppSize.textSmall,
                ),
        ],
      );
    }

    // Trạng thái ban đầu - chưa có booking nào được confirm
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        bookingCubit.reschedule.contains(booking.bookingDetailId)
            ? ButtonDesign(
                width: 120.w,
                height: 32.h,
                ontap: () {
                  context.read<ResolveOverlapServiceCubit>().markAction(
                      booking.bookingDetailId!,
                      OverlapActionStatus.rescheduled);
                  bookingCubit
                      .removeRescheduleBooking(booking.bookingDetailId!);
                },
                text: 'Selected',
                fillColor: Colors.green.shade200,
                textColor: Colors.black,
                borderColor: isDark ? Colors.grey.shade200 : Colors.black87,
                fontSize: AppSize.textSmall,
              )
            : ButtonDesign(
                width: 120.w,
                height: 32.h,
                ontap: () {
                  context.read<ResolveOverlapServiceCubit>().markAction(
                      booking.bookingDetailId!,
                      OverlapActionStatus.rescheduled);
                  bookingCubit.addRescheduleBooking(booking.bookingDetailId!);
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
        ButtonDesign(
          width: 120.w,
          height: 32.h,
          ontap: () async {
            showDialogConfirmation(
              BookingCardViewModel(
                bookingDetailId: booking.bookingDetailId,
                bookedDate: booking.bookedDate,
                shopName: booking.shopName,
                nameService: booking.serviceName,
              ),
            );
          },
          text: 'Resolve',
          fillColor: AppColors.secondBackground,
          textColor: isDark ? Colors.grey.shade200 : Colors.white,
          borderColor: isDark ? Colors.grey.shade200 : Colors.black87,
          fontSize: AppSize.textSmall,
        )
      ],
    );
  }
}
