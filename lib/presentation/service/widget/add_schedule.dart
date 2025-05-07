import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/presentation/service/bloc/bookingservice/booking_service_cubit.dart';
import 'package:Tracio/presentation/service/page/my_booking.dart';

import '../../../common/helper/schedule_model.dart';
import '../bloc/bookingservice/booking_service_state.dart';
import 'show_schedule_bottom.dart';

// GlobalKey cho navigatorKey
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AddSchedule extends StatefulWidget {
  const AddSchedule({
    super.key,
    this.onSchedulesChanged,
    this.serviceId,
  });
  // final List<BookingCardViewModel> bookingModel;
  final int? serviceId;
 
  final Function(List<ScheduleModel>)? onSchedulesChanged;

  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingServiceCubit, BookingServiceState>(
        listener: (context, state) {
      if (state is BookingServiceLoading) {
        EasyLoading.show(status: 'Loading...');
      } else if (state is BookingServiceSuccess) {
        context.read<BookingServiceCubit>().clearBookingItem();
        EasyLoading.dismiss();
        AppNavigator.pushReplacement(context, MyBookingPage());
      } else if (state is BookingServiceFailure) {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking failed')),
        );
      }
    }, builder: (context, state) {
      return Column(
        // mainAxisSize: MainAxisSize.min, // Đảm bảo chỉ chiếm không gian cần thiết
        children: [
          ShowScheduleBottom(
         
            serviceId: widget.serviceId,
          ),
        ],
      );
    });
  }

  // Hiển thị dialog danh sách lịch đã đặt
}
