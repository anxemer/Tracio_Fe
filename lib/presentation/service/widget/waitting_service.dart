import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/widget/blog/custom_bottomsheet.dart';
import 'package:tracio_fe/common/widget/button/basic_app_button.dart';
import 'package:tracio_fe/presentation/service/bloc/get_booking/get_booking_cubit.dart';
import 'package:tracio_fe/presentation/service/widget/overlap_service.dart';

import '../../../common/widget/button/button.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../../../data/shop/models/get_booking_req.dart';
import '../../../domain/shop/entities/response/booking_card_view.dart';
import '../bloc/get_booking/get_booking_state.dart';
import 'booking_card.dart';

class WaittingService extends StatefulWidget {
  const WaittingService({super.key, required this.animationController});
  final AnimationController animationController;
  @override
  State<WaittingService> createState() => _WaittingServiceState();
}

class _WaittingServiceState extends State<WaittingService> {
  @override
  void initState() {
    context
        .read<GetBookingCubit>()
        .getBooking(GetBookingReq(status: 'Waiting'));
    widget.animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    return BlocBuilder<GetBookingCubit, GetBookingState>(
      builder: (context, state) {
        if (state is GetBookingLoaded) {
          print(state.overlapBookingList.length);
          if (state.bookingList.isEmpty) {
            return Center(
              child: Text('Chưa có bookingn nào'),
            );
          }
          return Column(
            children: [
              state.overlapBookingList.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.fromLTRB(16, 20, 10, 20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: Colors.red,
                          ),
                          Expanded(
                            child: Text(
                              'You have ${state.overlapBookingList.length} services with overlapping schedules.',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: AppSize.textLarge,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          ButtonDesign(
                            width: 80.w,
                            height: 30.h,
                            textColor: Colors.white,
                            ontap: () {
                              CustomModalBottomSheet.show(
                                  context: context,
                                  child: OverlapService(
                                    animationController:
                                        widget.animationController,
                                    overlapList: state.overlapBookingList,
                                  ));
                            },
                            fillColor: AppColors.primary,
                            borderColor: Colors.black,
                            fontSize: AppSize.textMedium,
                            text: 'View',
                          )
                          // CloseButton(
                          //   onPressed: () {},
                          //   color: Colors.red,
                          // ),
                        ],
                      ),
                    )
                  : Container(),
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
                        service: BookingCardViewModel(
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ButtonDesign(
                                  width: 160,
                                  height: 40,
                                  ontap: () {},
                                  text: 'Reschedule',
                                  fillColor: Colors.transparent,
                                  textColor: isDark
                                      ? Colors.grey.shade200
                                      : Colors.black87,
                                  borderColor: isDark
                                      ? Colors.grey.shade200
                                      : Colors.black87,
                                  fontSize: AppSize.textMedium,
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                ButtonDesign(
                                  width: 160,
                                  height: 40,
                                  ontap: () async {
                                    // var time = showTimePicker(
                                    //   context: context,
                                    //   initialTime: TimeOfDay.now(),

                                    // );
                                  },
                                  text: 'Confirm',
                                  fillColor: AppColors.secondBackground,
                                  textColor: isDark
                                      ? Colors.grey.shade200
                                      : Colors.white,
                                  borderColor: context.isDarkMode
                                      ? Colors.grey.shade200
                                      : Colors.black87,
                                  fontSize: AppSize.textMedium,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
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
