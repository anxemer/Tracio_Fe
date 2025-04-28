import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/common/widget/button/text_button.dart';
import 'package:tracio_fe/presentation/service/widget/choose_free_time.dart';
import '../bloc/bookingservice/booking_service_cubit.dart';
import 'confirm_information_booking.dart';

class ShowScheduleBottom extends StatefulWidget {
  const ShowScheduleBottom({
    super.key,
    this.serviceId,
  });
  final int? serviceId;
  // final List<BookingCardViewModel> cartItem;
  // final Function(List<ScheduleModel>)? onSchedulesChanged;
  @override
  State<ShowScheduleBottom> createState() => _ShowScheduleBottomState();
}

class _ShowScheduleBottomState extends State<ShowScheduleBottom> {
  @override
  Widget build(BuildContext context) {
    final bookingCubit = context.read<BookingServiceCubit>();

    return Column(
      children: [
        BasicTextButton(
          text: 'Choose Your Free Time',
          onPress: () {
            ChooseFreeTime().showScheduleBottomSheet(context, widget.serviceId);
            // _showScheduleBottomSheet(context);
          },
          borderColor: Colors.black,
        ),
        if (bookingCubit.schedules != null &&
            bookingCubit.schedules!.isNotEmpty)
          ConfirmInformationBooking(
            serviceId: widget.serviceId,
          )
      ],
    );
  }
}
