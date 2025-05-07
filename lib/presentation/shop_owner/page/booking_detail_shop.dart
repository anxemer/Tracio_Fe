import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/common/helper/placeholder/booking_detail_holder.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/presentation/service/bloc/bookingservice/get_booking_detail_cubit/get_booking_detail_cubit.dart';
import 'package:Tracio/presentation/service/widget/all_review_service.dart';
import 'package:Tracio/presentation/service/widget/review_service.dart';
import 'package:Tracio/presentation/shop_owner/bloc/resolve_booking/resolve_booking_cubit.dart';
import 'package:Tracio/presentation/shop_owner/widget/list_schedule.dart';

import '../../../common/widget/button/button.dart';
import '../../../common/widget/dialog_confirm.dart';
import '../../../common/widget/picture/picture.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import '../../../domain/shop/entities/response/booking_detail_entity.dart';
import '../../../domain/shop/usecase/cancel_booking.dart';
import '../../../service_locator.dart';
import '../../service/widget/booking_status_tab.dart';
import '../../service/widget/cancel_reason.dart';
import '../bloc/resolve_booking/resolve_booking_state.dart';
import '../widget/booking_information.dart';

class BookingDetailShopScreen extends StatefulWidget {
  // final Map<String, dynamic> bookingDetail;

  const BookingDetailShopScreen({super.key, required this.bookingId});
  final int bookingId;
  State<BookingDetailShopScreen> createState() =>
      _BookingDetailShopScreenState();
}

class _BookingDetailShopScreenState extends State<BookingDetailShopScreen> {
  @override
  void initState() {
    context.read<ResolveBookingShopCubit>().resetState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              GetBookingDetailCubit()..getBookingDetail(widget.bookingId),
        ),
      ],
      child: Scaffold(
        appBar: BasicAppbar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Booking Detail',
            style: TextStyle(
                fontSize: AppSize.textHeading, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocConsumer<ResolveBookingShopCubit, ResolveBookingShopState>(
          listener: (context, state) {
            if (state is ConfirmBookingSuccess) {
              context
                  .read<GetBookingDetailCubit>()
                  .getBookingDetail(widget.bookingId);
            }
          },
          builder: (context, resolveState) {
            return BlocBuilder<GetBookingDetailCubit, GetBookingDetailState>(
              builder: (context, state) {
                if (state is GetBookingDetailLoaded) {
                  var haveConfirm = ['Pending', 'Reschedule']
                      .contains(state.bookingdetail.status);
                  return Column(
                    children: [
                      Expanded(
                        child: Stack(children: [
                          SingleChildScrollView(
                            padding: EdgeInsets.only(
                                bottom: 40 + (AppSize.apVerticalPadding * 2)),
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          AppSize.apHorizontalPadding * .4,
                                      vertical: AppSize.apVerticalPadding * .2),
                                  child: Card(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              AppSize.apHorizontalPadding * .4,
                                          vertical:
                                              AppSize.apVerticalPadding * .4),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: PictureCustom(
                                                  width: AppSize.imageMedium.w,
                                                  imageUrl: state.bookingdetail
                                                      .serviceMediaFile!,
                                                  height: AppSize.imageMedium.h,
                                                ),
                                              ),
                                              SizedBox(width: 10.w),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      state.bookingdetail
                                                          .serviceName!,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              AppSize.textLarge,
                                                          color: isDark
                                                              ? Colors
                                                                  .grey.shade300
                                                              : Colors.black87),
                                                    ),
                                                    SizedBox(height: 10.h),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .location_on_outlined,
                                                          size: AppSize
                                                              .iconMedium,
                                                          color: isDark
                                                              ? AppColors
                                                                  .secondBackground
                                                              : AppColors
                                                                  .background,
                                                        ),
                                                        SizedBox(width: 4.w),
                                                        Expanded(
                                                          child: Text(
                                                            '${state.bookingdetail.district} - ${state.bookingdetail.city}',
                                                            style: TextStyle(
                                                                fontSize: AppSize
                                                                    .textMedium,
                                                                color: isDark
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.h),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: getStatusColor(
                                                  state.bookingdetail.status!),
                                              borderRadius:
                                                  BorderRadius.circular(AppSize
                                                      .borderRadiusSmall),
                                              border: Border.all(
                                                  color: getStatusBorderColor(
                                                      state.bookingdetail
                                                          .status!)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  state.bookingdetail.status!,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize:
                                                        AppSize.textMedium,
                                                    color: Colors.black87,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          Divider(
                                            thickness: 1,
                                            height: 4,
                                            color: Colors.black,
                                          ),
                                          SizedBox(height: 10.h),
                                          BookingInformation(
                                            userNote:
                                                state.bookingdetail.userNote,
                                            adjPrice: state.bookingdetail
                                                .adjustPriceReason,
                                            shopNote:
                                                state.bookingdetail.shopNote,
                                            status: state.bookingdetail.status!,
                                            start:
                                                state.bookingdetail.bookedDate,
                                            duration: state.bookingdetail
                                                .formattedDuration,
                                            price: state
                                                .bookingdetail.formattedPrice,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                haveConfirm
                                    ? ListSchedule(
                                        duration: state.bookingdetail.duration,
                                        schedules:
                                            state.bookingdetail.userDayFrees!,
                                      )
                                    : Container(),
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
                                        topLeft: Radius.circular(
                                            AppSize.borderRadiusLarge),
                                        topRight: Radius.circular(
                                            AppSize.borderRadiusLarge))),
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: AppSize.apHorizontalPadding,
                                        vertical: AppSize.apVerticalPadding),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: _buildActionButtons(
                                          state.bookingdetail),
                                    )),
                              ))
                        ]),
                      )
                    ],
                  );
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
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildActionButtons(BookingDetailEntity booking) {
    final isDark = context.isDarkMode;

    switch (booking.status) {
      case 'Pending':
      case 'Reschedule':
        return [
          ButtonDesign(
            width: 140.w,
            height: 40.h,
            ontap: () {
              DialogConfirm(
                      btnLeft: () => Navigator.pop(context),
                      btnRight: () =>
                          AppNavigator.push(context, CancelReasonScreen()),
                      notification:
                          'Are you sure you want to cancel this Booking?')
                  .showDialogConfirmation(context);
            },
            text: 'Cancel',
            fillColor: Colors.transparent,
            textColor: isDark ? Colors.white70 : Colors.black,
            borderColor: isDark ? Colors.grey.shade200 : Colors.black87,
            fontSize: AppSize.textMedium,
          ),
          SizedBox(width: 20.w),
          ButtonDesign(
            width: 140.w,
            height: 40.h,
            ontap: () {
              setState(() {});
              context.read<ResolveBookingShopCubit>().resolvePendingBooking(
                  booking.formattedDuration, booking.bookingDetailId!);

              // ShowScheduleBottom();
            },
            text: 'Confirm',
            fillColor: AppColors.secondBackground,
            textColor: isDark ? Colors.grey.shade100 : Colors.white,
            borderColor: isDark ? Colors.grey.shade200 : Colors.black87,
            fontSize: AppSize.textMedium,
          ),
        ];
      case 'Confirmed':
        return [
          ButtonDesign(
            width: 140.w,
            height: 40.h,
            ontap: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.cancel, color: Colors.red),
                      title: Text('Cancel Booking'),
                      onTap: () {
                        DialogConfirm(
                          btnLeft: () =>
                              AppNavigator.push(context, CancelReasonScreen()),
                          btnRight: () => Navigator.pop(context),
                          notification:
                              'Are you sure you want to cancel this Booking?',
                        ).showDialogConfirmation(context);
                      },
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.error_outline, color: Colors.orange),
                      title: Text('Customer Not Arrived'),
                      onTap: () {
                        Navigator.pop(context);

                        print("Marked as Not Arrived");
                      },
                    ),
                  ],
                ),
              );
            },
            text: 'Cancel',
            fillColor: Colors.transparent,
            textColor: isDark ? Colors.white70 : Colors.black,
            borderColor: isDark ? Colors.grey.shade200 : Colors.black87,
            fontSize: AppSize.textMedium,
          ),
          SizedBox(width: 20.w),
          ButtonDesign(
            width: 140.w,
            height: 40.h,
            ontap: () {
              context
                  .read<ResolveBookingShopCubit>()
                  .processBooking(booking.bookingDetailId!);
            },
            text: 'Received',
            fillColor: AppColors.secondBackground,
            textColor: isDark ? Colors.grey.shade100 : Colors.white,
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
              AppNavigator.push(
                  context,
                  AllReviewService(
                    isReviewd: booking.isReviewed!,
                    isShopOwner: true,
                    bookingId: booking.bookingDetailId,
                  ));
            },
            text: 'View Review',
            fillColor: AppColors.secondBackground,
            textColor: isDark ? Colors.white70 : Colors.black,
            borderColor: isDark ? Colors.grey.shade200 : Colors.black87,
            fontSize: AppSize.textMedium,
          ),
          // SizedBox(width: 20.w),
          // ButtonDesign(
          //   width: 140.w,
          //   height: 40.h,
          //   ontap: () {},
          //   text: 'Rebook',
          //   fillColor: Colors.green.shade400,
          //   textColor: isDark ? Colors.white70 : Colors.black,
          //   borderColor: isDark ? Colors.grey.shade200 : Colors.black87,
          //   fontSize: AppSize.textSmall,
          // ),
        ];

      case 'Processing':
        return [
          ButtonDesign(
            width: 140.w,
            height: 40.h,
            ontap: () {
              context
                  .read<ResolveBookingShopCubit>()
                  .completeBooking(booking.bookingDetailId!);
            },
            text: 'Comleted',
            fillColor: AppColors.primary,
            textColor: Colors.white70,
            borderColor: isDark ? Colors.grey.shade200 : Colors.black87,
            fontSize: AppSize.textMedium,
          ),
        ];
      case 'Not Arrive':
      case 'Cancelled':
      default:
        return []; // Không hiển thị nút nào
    }
  }
}
