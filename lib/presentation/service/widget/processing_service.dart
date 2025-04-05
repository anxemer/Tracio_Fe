import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/presentation/service/bloc/get_booking/get_booking_cubit.dart';

import '../../../core/constants/app_size.dart';
import '../../../data/shop/models/get_booking_req.dart';
import '../../../domain/shop/entities/response/booking_card_view.dart';
import '../bloc/get_booking/get_booking_state.dart';
import 'booking_card.dart';

class ProcessingService extends StatefulWidget {
  const ProcessingService({super.key, required this.animationController});
  final AnimationController animationController;
  @override
  State<ProcessingService> createState() => _ProcessingServiceState();
}

class _ProcessingServiceState extends State<ProcessingService> {
  @override
  void initState() {
    context
        .read<GetBookingCubit>()
        .getBooking(GetBookingReq(status: 'Processing'));
    widget.animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    return BlocBuilder<GetBookingCubit, GetBookingState>(
      builder: (context, state) {
        if (state is GetBookingLoaded) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: state.bookingList.length,
            itemBuilder: (context, index) {
              var animation = Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn)));
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
                  moreWidget: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius:
                          BorderRadius.circular(AppSize.borderRadiusSmall),
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     ButtonDesign(
                  //       width: 100,
                  //       height: 40,
                  //       ontap: () {},
                  //       text: 'Edit',
                  //       fillColor: Colors.transparent,
                  //       textColor:
                  //           isDark ? Colors.grey.shade200 : Colors.black87,
                  //       borderColor:
                  //           isDark ? Colors.grey.shade200 : Colors.black87,
                  //       fontSize: AppSize.textMedium,
                  //     ),
                  //     SizedBox(
                  //       width: 20.w,
                  //     ),
                  //     ButtonDesign(
                  //       width: 100,
                  //       height: 40,
                  //       ontap: () async {
                  //         // var time = showTimePicker(
                  //         //   context: context,
                  //         //   initialTime: TimeOfDay.now(),

                  //         // );
                  //       },
                  //       text: 'Cancel',
                  //       fillColor: AppColors.secondBackground,
                  //       textColor:
                  //           isDark ? Colors.grey.shade200 : Colors.black87,
                  //       borderColor: context.isDarkMode
                  //           ? Colors.grey.shade200
                  //           : Colors.black87,
                  //       fontSize: AppSize.textMedium,
                  //     )
                  //   ],
                  // ),
                ),
              );
            },
          );
        } else if (state is GetBookingFailure || state is GetBookingLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return Container();
      },
    );
  }
}
