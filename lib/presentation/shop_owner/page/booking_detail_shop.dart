import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/helper/placeholder/booking_detail.dart';
import 'package:tracio_fe/common/helper/schedule_model.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/data/shop/models/waiting_booking.dart';
import 'package:tracio_fe/domain/shop/usecase/cancel_booking.dart';
import 'package:tracio_fe/presentation/service/bloc/bookingservice/booking_service_cubit.dart';
import 'package:tracio_fe/presentation/service/bloc/bookingservice/cubit/get_booking_detail_cubit.dart';
import 'package:tracio_fe/presentation/service/widget/dialog_confirm_booking.dart';
import 'package:tracio_fe/presentation/shop_owner/bloc/cubit/resolve_booking_cubit.dart';
import 'package:tracio_fe/presentation/shop_owner/widget/list_schedule.dart';

import '../../../common/widget/button/button.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import '../../../domain/shop/entities/response/booking_card_view.dart';
import '../../../service_locator.dart';
import '../bloc/cubit/resolve_booking_state.dart';
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
    context.read<GetBookingDetailCubit>().getBookingDetail(widget.bookingId);
    context.read<ResolveBookingShopCubit>().resetState();
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
          backgroundColor: Colors.transparent,
          title: Text(
            'Booking Detail',
            style: TextStyle(
                fontSize: AppSize.textHeading, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocConsumer<ResolveBookingShopCubit, ResolveBookingShopState>(
          listener: (context, state) {
            if (state is WaitingBookingSuccess) {
              // Khi state là WaitingBookingSuccess, load lại dữ liệu
              context
                  .read<GetBookingDetailCubit>()
                  .getBookingDetail(widget.bookingId);
            }
          },
          builder: (context, resolveState) {
            return BlocBuilder<GetBookingDetailCubit, GetBookingDetailState>(
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
                                      SizedBox(width: 10.w),
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
                                          SizedBox(height: 10.h),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on_outlined,
                                                size: AppSize.iconMedium,
                                                color: isDark
                                                    ? AppColors.secondBackground
                                                    : AppColors.background,
                                              ),
                                              SizedBox(width: 4.w),
                                              Text(
                                                '${state.bookingdetail.district} - ${state.bookingdetail.city}',
                                                style: TextStyle(
                                                    fontSize:
                                                        AppSize.textMedium,
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.w),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
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
                                        ),
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
                                    start: state.bookingdetail.bookedDate,
                                    end: state.bookingdetail.estimatedEndDate,
                                    duration:
                                        state.bookingdetail.formattedDuration,
                                    price: state.bookingdetail.formattedPrice,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ListSchedule(
                          duration: state.bookingdetail.duration,
                          schedules: state.bookingdetail.userDayFrees!,
                        ),
                      ],
                    ),
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
        bottomNavigationBar: Builder(
          builder: (context) {
            final state = context.watch<GetBookingDetailCubit>().state;

            if (state is GetBookingDetailLoaded) {
              final booking = state.bookingdetail;

              if (booking.status != 'pending') {
                return const SizedBox
                    .shrink(); // Không hiển thị nút nếu status không đúng
              }
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
                    bookingDetailId: state.bookingdetail.bookingDetailId,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget buttonResolve(BuildContext context, BookingCardViewModel booking) {
    var params = context.watch<ResolveBookingShopCubit>();
    WaitingModel waiting = WaitingModel(
      bookingId: booking.bookingDetailId,
      bookedDate: params.bookedDate,
      estimatedEndDate: params.estimatedEndDate,
      userNote: 'userNote',
      shopNote: '',
      reason: 'reason',
      price: 200,
    );
    var isDark = context.isDarkMode;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonDesign(
          width: 120.w,
          height: 32.h,
          ontap: () {
            sl<CancelBookingUseCase>().call(booking.bookingDetailId!);
          },
          text: 'Cancel',
          fillColor: Colors.green.shade200,
          textColor: isDark ? Colors.white70 : Colors.black,
          borderColor: isDark ? Colors.grey.shade200 : Colors.black87,
          fontSize: AppSize.textSmall,
        ),
        SizedBox(width: 20.w),
        ButtonDesign(
          width: 120.w,
          height: 32.h,
          ontap: () async {
            context
                .read<ResolveBookingShopCubit>()
                .resolvePendingBooking(waiting);
          },
          text: 'Resolve',
          fillColor: AppColors.secondBackground,
          textColor: isDark ? Colors.grey.shade200 : Colors.white,
          borderColor: isDark ? Colors.grey.shade200 : Colors.black87,
          fontSize: AppSize.textSmall,
        ),
      ],
    );
  }
}
