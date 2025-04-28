import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/helper/placeholder/booking_detail.dart';
import 'package:tracio_fe/common/helper/schedule_model.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/domain/shop/usecase/cancel_booking.dart';
import 'package:tracio_fe/presentation/service/bloc/bookingservice/booking_service_cubit.dart';
import 'package:tracio_fe/presentation/service/bloc/bookingservice/get_booking_detail_cubit/get_booking_detail_cubit.dart';
import 'package:tracio_fe/presentation/service/widget/dialog_confirm_booking.dart';

import '../../../common/helper/navigator/app_navigator.dart';
import '../../../common/widget/blog/custom_bottomsheet.dart';
import '../../../common/widget/button/button.dart';
import '../../../common/widget/input_text_form_field.dart';
import '../../../common/widget/picture/circle_picture.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import '../../../domain/shop/entities/response/booking_detail_entity.dart';
import '../../../service_locator.dart';
import '../widget/add_schedule.dart';
import '../widget/booking_status_tab.dart';
import '../widget/choose_free_time.dart';
import '../widget/review_service.dart';
import 'review_booking.dart';

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
    return BlocProvider(
      create: (context) =>
          GetBookingDetailCubit()..getBookingDetail(widget.bookingId),
      child: Scaffold(
        appBar: BasicAppbar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Booking Detail',
            style: TextStyle(
                fontSize: AppSize.textHeading, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<GetBookingDetailCubit, GetBookingDetailState>(
          builder: (context, state) {
            if (state is GetBookingDetailLoaded) {
              return Stack(children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                      bottom: 40 + (AppSize.apVerticalPadding * 2)),
                  physics: BouncingScrollPhysics(),
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
                                                    fontSize:
                                                        AppSize.textMedium,
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.w,
                                          ),
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
                                      color: getStatusColor(
                                          state.bookingdetail.status!),
                                      borderRadius: BorderRadius.circular(
                                          AppSize.borderRadiusSmall),
                                      border: Border.all(
                                        color: getStatusBorderColor(
                                            state.bookingdetail.status!),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      state.bookingdetail.formattedPrice,
                                      state.bookingdetail.adjustPriceReason)
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
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(AppSize.borderRadiusLarge),
                                topRight: Radius.circular(
                                    AppSize.borderRadiusLarge))),
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppSize.apHorizontalPadding,
                                vertical: AppSize.apVerticalPadding),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    _buildActionButtons(state.bookingdetail),
                              ),
                            ))))
              ]);
            } else if (state is GetBookingDetailLoading) {
              return BookingDetailPlaceholder();
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

  Widget bookingSumary(DateTime? start, DateTime? end, String duration,
      String price, String? adjustPriceReason) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (adjustPriceReason != null) ...[
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Price:',
                            style: TextStyle(
                                fontSize: AppSize.textMedium,
                                color: Colors.grey)),
                        Text(
                          '$price \$',
                          style: TextStyle(
                            fontSize: AppSize.textLarge,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Reason: ',
                          style: TextStyle(
                            fontSize: AppSize.textLarge,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          ' $adjustPriceReason',
                          style: TextStyle(
                            fontSize: AppSize.textLarge,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Price:',
                            style: TextStyle(
                                fontSize: AppSize.textMedium,
                                color: Colors.grey)),
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: AppSize.textLarge,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ));
  }

  List<Widget> _buildActionButtons(BookingDetailEntity booking) {
    TextEditingController noteCon = TextEditingController();
    var bookingCubit = context.read<BookingServiceCubit>();
    final isDark = context.isDarkMode;

    switch (booking.status) {
      case 'Pending':
      case 'Reschedule':
      case 'Confirmed':
        return [
          ButtonDesign(
            width: 140.w,
            height: 40.h,
            ontap: () {
              sl<CancelBookingUseCase>().call(booking.bookingDetailId!);
            },
            text: 'Cancel',
            fillColor: Colors.green.shade200,
            textColor: isDark ? Colors.white70 : Colors.black,
            borderColor: isDark ? Colors.grey.shade200 : Colors.black87,
            fontSize: AppSize.textMedium,
          ),
          SizedBox(width: 20.w),
          ButtonDesign(
            width: 140.w,
            height: 40.h,
            ontap: () {
              DialogConfirmBooking().showDialogConfirmation(context, () {
                ChooseFreeTime()
                    .showScheduleBottomSheet(context, booking.serviceId);
              });
            },
            text: 'Reschedule',
            fillColor: AppColors.secondBackground,
            textColor: isDark ? Colors.grey.shade200 : Colors.white,
            borderColor: isDark ? Colors.grey.shade200 : Colors.black87,
            fontSize: AppSize.textMedium,
          ),
        ];

      case 'Completed':
        return [
          ButtonDesign(
            width: 140.w,
            height: 40.h,
            ontap: () {
              booking.isReviewed!
                  ? ReviewService(
                      bookingDetailId: booking.bookingDetailId!,
                    )
                  : AppNavigator.push(
                      context,
                      ReviewBookingScreen(
                        bookingId: booking.bookingDetailId!,
                        imageUrl: booking.profilePicture!,
                        serviceName: booking.serviceName!,
                      ));
            },
            text: booking.isReviewed! ? 'View Review' : 'Review',
            fillColor: Colors.transparent,
            textColor: isDark ? Colors.white70 : Colors.black,
            borderColor: isDark ? Colors.grey.shade200 : Colors.black87,
            fontSize: AppSize.textMedium,
          ),
          SizedBox(width: 20.w),
          ButtonDesign(
            width: 140.w,
            height: 40.h,
            ontap: () {},
            text: 'Rebook',
            fillColor: AppColors.primary,
            textColor: Colors.white70,
            borderColor: isDark ? Colors.grey.shade200 : Colors.black87,
            fontSize: AppSize.textMedium,
          ),
        ];

      case 'Cancelled':
        return [
          ButtonDesign(
            width: 140.w,
            height: 40.h,
            ontap: () {
              CustomModalBottomSheet.show(
                  initialSize: .3,
                  maxSize: .4,
                  minSize: .1,
                  context: context,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: context.isDarkMode
                          ? AppColors.darkGrey
                          : Colors.grey.shade200,
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSize.apHorizontalPadding,
                        vertical: AppSize.apVerticalPadding),
                    // height: 100,
                    // width: double.infinity,
                    child: Column(
                      children: [
                        AddSchedule(
                          serviceId: booking.serviceId,
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        InputTextFormField(
                            controller: noteCon,
                            labelText: 'Note',
                            hint: 'Note',
                            onFieldSubmitted: (value) {
                              bookingCubit.updateNote(
                                  booking.serviceId.toString(), value);
                            }),
                      ],
                    ),
                  ));
            },
            text: 'Rebooking',
            fillColor: AppColors.primary,
            textColor: Colors.white70,
            borderColor: isDark ? Colors.grey.shade200 : Colors.black87,
            fontSize: AppSize.textMedium,
          ),
        ];

      case 'Processing':
      default:
        return []; // Không hiển thị nút nào
    }
  }
}
