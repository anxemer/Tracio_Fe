import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/helper/schedule_model.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/domain/shop/usecase/cancel_booking.dart';
import 'package:tracio_fe/presentation/service/bloc/bookingservice/booking_service_cubit.dart';
import 'package:tracio_fe/presentation/service/bloc/bookingservice/cubit/get_booking_detail_cubit.dart';
import 'package:tracio_fe/presentation/service/bloc/bookingservice/resolve_overlap_service/cubit/resolve_overlap_service_cubit.dart';
import 'package:tracio_fe/presentation/service/widget/booking_card.dart';
import 'package:tracio_fe/presentation/service/widget/confirm_information_booking.dart';
import 'package:tracio_fe/presentation/service/widget/dialog_confirm_booking.dart';
import 'package:tracio_fe/presentation/service/widget/resolve_booking.dart';
import 'package:tracio_fe/presentation/service/widget/show_schedule_bottom.dart';

import '../../../common/widget/button/button.dart';
import '../../../common/widget/picture/circle_picture.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import '../../../domain/shop/entities/response/booking_card_view.dart';
import '../../../domain/shop/usecase/submit_booking.dart';
import '../../../service_locator.dart';

class BookingDetailScreen extends StatefulWidget {
  // final Map<String, dynamic> bookingDetail;

  const BookingDetailScreen(
      {super.key, required this.bookingId, required this.animationController});
  final int bookingId;
  final AnimationController animationController;
  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  @override
  void initState() {
    widget.animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    var bookingCubit = context.read<BookingServiceCubit>();
    return BlocProvider(
      create: (context) =>
          GetBookingDetailCubit()..getBookingDetail(widget.bookingId),
      child: Scaffold(
        appBar: BasicAppbar(
          title: Text(
            'Booking Detail',
            style: TextStyle(
                fontSize: AppSize.textHeading, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<GetBookingDetailCubit, GetBookingDetailState>(
          builder: (context, state) {
            if (state is GetBookingDetailLoaded) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppSize.apHorizontalPadding * .4,
                            vertical: AppSize.apVerticalPadding * .2),
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppSize.apHorizontalPadding * .4,
                                vertical: AppSize.apVerticalPadding * .4),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        AppImages.picture,
                                        width: AppSize.imageMedium.w,
                                        height: AppSize.imageMedium.h,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.bookingdetail.serviceName!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: AppSize.textLarge,
                                              color: isDark
                                                  ? Colors.grey.shade300
                                                  : Colors.black87),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Row(
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              size: AppSize.iconMedium,
                                              color: isDark
                                                  ? AppColors.secondBackground
                                                  : AppColors.background,
                                            ),
                                            SizedBox(
                                              width: 4.w,
                                            ),
                                            Text(
                                              'Thu Duc - Ho Chi Minh',
                                              style: TextStyle(
                                                  fontSize: AppSize.textMedium,
                                                  color: isDark
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.w,
                                        ),
                                        // Row(
                                        //   crossAxisAlignment:
                                        //       CrossAxisAlignment.center,
                                        //   children: [
                                        //     Icon(
                                        //       Icons.star_rate_rounded,
                                        //       size: AppSize.iconMedium,
                                        //       color: isDark
                                        //           ? AppColors.secondBackground
                                        //           : AppColors.background,
                                        //     ),
                                        //     SizedBox(
                                        //       width: 4.w,
                                        //     ),
                                        //     Text(
                                        //       '4.9',
                                        //       style: TextStyle(
                                        //           fontSize: AppSize.textMedium,
                                        //           color: AppColors
                                        //               .secondBackground),
                                        //     ),
                                        //     SizedBox(
                                        //       width: 4,
                                        //     ),
                                        //     Text(
                                        //       '1000 review',
                                        //       style: TextStyle(
                                        //           fontSize: AppSize.textMedium,
                                        //           color: isDark
                                        //               ? Colors.grey.shade200
                                        //               : Colors.grey.shade400),
                                        //     ),
                                        //   ],
                                        // )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
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
                                        state.bookingdetail.status!,
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
                                Divider(
                                  thickness: 1,
                                  height: 4,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                shopInformation(context),
                                SizedBox(
                                  height: 10.h,
                                ),
                                bookingSumary(
                                    state.bookingdetail.bookedDate,
                                    state.bookingdetail.estimatedEndDate,
                                    state.bookingdetail.formattedDuration,
                                    state.bookingdetail.formattedPrice)
                              ],
                            ),
                          ),
                        )),
                    // SizedBox(
                    //   height: 10.h,
                    // ),
                    scheduleList(context, state.bookingdetail.userDayFrees!),
                  ],
                ),
              );
            } else if (state is GetBookingDetailLoading) {
              return Shimmer.fromColors(
                baseColor: Colors.black26,
                highlightColor: Colors.black54,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.black38,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      width: 160,
                      height: 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.black26,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(3, (index) {
                        return Container(
                          width: double.infinity,
                          height: 12,
                          margin: EdgeInsets.only(top: index == 0 ? 0 : 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.black26,
                          ),
                        );
                      }),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [120, 180].asMap().entries.map((e) {
                            return Container(
                              width: e.value.toDouble(),
                              height: 12,
                              margin: EdgeInsets.only(top: e.key == 0 ? 0 : 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.black26,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return Center(
                child: Column(
              children: [
                Image.asset(
                  AppImages.error,
                  width: AppSize.imageLarge,
                ),
                Text('Can\'t load blog....'),
                IconButton(
                    onPressed: () {
                      context
                          .read<GetBookingDetailCubit>()
                          .getBookingDetail(widget.bookingId);
                    },
                    icon: Icon(
                      Icons.refresh_outlined,
                      size: AppSize.iconLarge,
                    ))
              ],
            ));
          },
        ),
        bottomNavigationBar: Builder(
          builder: (context) {
            final state = context.watch<GetBookingDetailCubit>().state;
            var countReschedule =
                context.watch<BookingServiceCubit>().reschedule;
            if (state is GetBookingDetailLoaded) {
              // buttonResolve(context, state.bookingdetail.status!);

              // var animation = Tween(begin: 0.0, end: 1.0).animate(
              //     CurvedAnimation(
              //         parent: widget.animationController,
              //         curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn)));
              return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSize.apHorizontalPadding,
                      vertical: AppSize.apVerticalPadding),
                  child: buttonResolve(
                      context,
                      BookingCardViewModel(
                          shopName: state.bookingdetail.shopName,
                          duration: state.bookingdetail.duration,
                          nameService: state.bookingdetail.serviceName,
                          price: state.bookingdetail.price,
                          status: state.bookingdetail.status,
                          bookingDetailId:
                              state.bookingdetail.bookingDetailId)));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget scheduleList(BuildContext context, List<ScheduleModel> schedules) {
    var isDark = context.isDarkMode;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppSize.apHorizontalPadding * .4,
          vertical: AppSize.apVerticalPadding * .2),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Your Free Time',
              style: TextStyle(
                  fontSize: AppSize.textHeading,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black87),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: schedules.length,
              // padding: EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

                return ListTile(
                  leading: Icon(
                    Icons.date_range_rounded,
                    size: AppSize.iconLarge,
                    color: AppColors.primary,
                  ),
                  title: Row(
                    children: [
                      Text(
                        // '2025-04-08 ',
                        dateFormat.format(schedule.date!),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: AppSize.textLarge),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Icon(
                        Icons.timelapse_outlined,
                        size: AppSize.iconLarge,
                        color: AppColors.primary,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        '${DateFormat('HH:mm').format(schedule.timeFromAsDateTime!)} - ${DateFormat('HH:mm').format(schedule.timeToAsDateTime!)}',

                        // dateFormat.format(schedule.timeFromAsDateTime!),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: AppSize.textLarge),
                      ),
                    ],
                  ),
                  // subtitle: Text('09:00 - 18:00'
                  //     // '${schedule.timeFrom.format(context)} - ${schedule.timeTo.format(context)}',
                  //     ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget shopInformation(BuildContext context) {
    var isDark = context.isDarkMode;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CirclePicture(
                  imageUrl:
                      'https://bizweb.dktcdn.net/100/481/209/products/img-5958-jpeg.jpg?v=1717069788060',
                  imageSize: AppSize.iconMedium),
              SizedBox(
                width: 10.w,
              ),
              Column(
                children: [
                  Text(
                    'Shop name',
                    style: TextStyle(
                      color: isDark ? Colors.grey.shade300 : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: AppSize.textLarge,
                    ),
                  ),
                  Container(
                    height: 28,
                    width: 100,
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
                          '7h - 22h',
                          style: TextStyle(
                            color:
                                isDark ? Colors.grey.shade300 : Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: AppSize.textSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  SizedBox(
                    width: AppSize.iconSmall.w,
                    height: AppSize.iconSmall.h,
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.phone,
                          size: AppSize.iconSmall,
                        )),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  SizedBox(
                    width: AppSize.iconSmall.w,
                    height: AppSize.iconSmall.h,
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.message_rounded,
                          size: AppSize.iconSmall,
                        )),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget bookingSumary(
      DateTime? start, DateTime? end, String duration, String price) {
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
        child: Column(
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
                        start != null ? dateFormat.format(start) : 'Waiting',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                // const SizedBox(height: 10),

                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(start != null ? timeFormat.format(start) : ''),
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.orange, width: 2),
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
                      Text(end != null ? timeFormat.format(end) : ''),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

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
                        end != null ? dateFormat.format(end) : 'Waiting',
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
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        duration,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                    '\$ $price',
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
        ));
  }

  Widget buttonResolve(BuildContext context, BookingCardViewModel booking) {
    // var status = context.watch<GetBookingDetailCubit>().bookingdetail.status;
    var isDark = context.isDarkMode;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonDesign(
          width: 120.w,
          height: 32.h,
          ontap: () {
            booking.status == 'Pending'
                ? sl<CancelBookingUseCase>().call(booking.bookingDetailId!)
                : DialogConfirmBooking().showDialogConfirmation(context, () {});
            // setState(() {});
            // context
            //     .read<ResolveOverlapServiceCubit>()
            //     .markAction(widget.bookingId, OverlapActionStatus.rescheduled);
            // bookingCubit.removeRescheduleBooking(widget.bookingId);
          },
          text: booking.status == 'Pending' ? 'cancel' : ' Reschedule',
          fillColor: Colors.green.shade200,
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
            booking.status != 'Pending'
                ? showDialogConfirmation(booking)
                : ConfirmInformationBooking();
          },
          text: booking.status != 'Pending' ? 'Confirm' : 'Reschedule',
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
            parent: widget.animationController,
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
