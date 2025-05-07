import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/presentation/service/bloc/get_booking/get_booking_cubit.dart';

import '../../../common/helper/navigator/app_navigator.dart';
import '../../../core/constants/app_size.dart';
import '../../../data/shop/models/get_booking_req.dart';
import '../../../domain/shop/entities/response/booking_card_view.dart';
import '../../service/bloc/bookingservice/get_booking_detail_cubit/get_booking_detail_cubit.dart';
import '../../service/bloc/bookingservice/resolve_overlap_service/cubit/resolve_overlap_service_cubit.dart';
import '../../service/bloc/get_booking/get_booking_state.dart';
import '../../service/page/booking_detail.dart';
import '../../service/widget/booking_card.dart';
import '../page/booking_detail_shop.dart';

class RecentBooking extends StatefulWidget {
  const RecentBooking({super.key, required this.animationController});
  final AnimationController animationController;

  @override
  State<RecentBooking> createState() => _RecentBookingState();
}

class _RecentBookingState extends State<RecentBooking> {
  @override
  void initState() {
    context
        .read<GetBookingCubit>()
        .getBooking(GetBookingReq(status: 'Pending'));
    widget.animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Section',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              Text(
                'See All',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<GetBookingCubit, GetBookingState>(
          builder: (context, state) {
            if (state is GetBookingLoaded) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: state.bookingList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BookingCard(
                      useAnimation: false,
                      ontap: () => AppNavigator.push(
                          context,
                          BlocProvider.value(
                            value: BlocProvider.of<ResolveOverlapServiceCubit>(
                                context),
                            child: BlocProvider.value(
                              value: BlocProvider.of<GetBookingDetailCubit>(
                                  context),
                              child: BookingDetailShopScreen(
                                bookingId:
                                    state.bookingList[index].bookingDetailId!,
                              ),
                            ),
                          )),
                      service: BookingCardViewModel(
                          shopName: state.bookingList[index].shopName,
                          duration: state.bookingList[index].duration,
                          nameService: state.bookingList[index].serviceName,
                          price: state.bookingList[index].price),
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
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is GetBookingFailure ||
                state is GetBookingLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return Container();
          },
        )
      ],
    );
  }
}
