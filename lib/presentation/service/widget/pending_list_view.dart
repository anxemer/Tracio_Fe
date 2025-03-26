import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/domain/shop/entities/booking_card_view.dart';
import 'package:tracio_fe/presentation/service/bloc/get_booking/get_booking_cubit.dart';
import 'package:tracio_fe/presentation/service/widget/booking_card.dart';

import '../../../common/widget/button/button.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../bloc/get_booking/get_booking_state.dart';

class PendingListView extends StatefulWidget {
  const PendingListView({
    super.key,
    required this.animationController,
  });
  final AnimationController animationController;
  // final List<ShopServiceEntity> servicePending;

  @override
  State<PendingListView> createState() => _PendingListViewState();
}

class _PendingListViewState extends State<PendingListView> {
  @override
  void initState() {
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
            itemCount: 5,
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
                      nameService: state.bookingList[index].serviceName,
                      price: state.bookingList[index].price.toString()),
                  animation: animation,
                  animationController: widget.animationController,
                  moreWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonDesign(
                        ontap: () {},
                        text: 'Edit',
                        fillColor: Colors.transparent,
                        textColor:
                            isDark ? Colors.grey.shade200 : Colors.black87,
                        borderColor:
                            isDark ? Colors.grey.shade200 : Colors.black87,
                        fontSize: AppSize.textMedium,
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      ButtonDesign(
                        ontap: () async {
                          // var time = showTimePicker(
                          //   context: context,
                          //   initialTime: TimeOfDay.now(),

                          // );
                        },
                        text: 'Cancel',
                        fillColor: AppColors.secondBackground,
                        textColor:
                            isDark ? Colors.grey.shade200 : Colors.black87,
                        borderColor: context.isDarkMode
                            ? Colors.grey.shade200
                            : Colors.black87,
                        fontSize: AppSize.textMedium,
                      )
                    ],
                  ),
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
