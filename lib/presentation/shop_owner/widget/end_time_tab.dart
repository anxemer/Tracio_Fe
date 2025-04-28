import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';

import '../../../common/helper/schedule_model.dart';
import '../../../core/configs/theme/app_colors.dart' show AppColors;
import '../../../core/constants/app_size.dart';
import '../../service/widget/custom_time_picker.dart';
import '../bloc/resolve_booking/resolve_booking_cubit.dart';

class EndTimeTab extends StatefulWidget {
  final ScheduleModel schedule;
  final Function(DateTime) onTimeSelected;
  final int duration;
  const EndTimeTab({
    Key? key,
    required this.schedule,
    required this.onTimeSelected,
    required this.duration,
  }) : super(key: key);

  @override
  _EndTimeTabState createState() => _EndTimeTabState();
}

class _EndTimeTabState extends State<EndTimeTab> {
  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();
    // _showTimePicker();
  }

  Future<void> _showTimePicker() async {
    final TimeOfDay startTimeOfDay = widget.schedule.timeFrom!;
    final TimeOfDay endTimeOfDay = widget.schedule.timeTo!;
    final TimeOfDay initialTime = widget.schedule.timeFrom!;
    final DateFormat timeFormat = DateFormat('HH:mm');

    final TimeOfDay? pickedTime = await showCustomHourMinutePicker(
      context: context,
      initialTime: initialTime,
      startHour: startTimeOfDay.hour,
      endHour: endTimeOfDay.hour,
      minuteInterval: 60,
    );

    if (pickedTime != null) {
      final DateTime newSelectedDateTime = DateTime(
        widget.schedule.date!.year,
        widget.schedule.date!.month,
        widget.schedule.date!.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      final DateTime startTime = widget.schedule.timeFromAsDateTime!;
      final DateTime endTime = widget.schedule.timeToAsDateTime!;

      if ((newSelectedDateTime.isAfter(startTime) ||
              newSelectedDateTime.isAtSameMomentAs(startTime)) &&
          (newSelectedDateTime.isBefore(endTime) ||
              newSelectedDateTime.isAtSameMomentAs(endTime))) {
        widget.onTimeSelected(newSelectedDateTime);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Selected time is outside the allowed range (${timeFormat.format(startTime)} - ${timeFormat.format(endTime)}).',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var bookedDate = context.watch<ResolveBookingShopCubit>().bookedDate;
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    final DateFormat timeFormat = DateFormat('HH:mm');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Choose time in ${dateFormat.format(widget.schedule.date!)}',
          style: TextStyle(
            fontSize: AppSize.textMedium,
            color: context.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(height: 16.h),
        InkWell(
          onTap: () => _showTimePicker(),
          child: Text(
            bookedDate != null
                ? 'Selected: ${timeFormat.format(bookedDate)}'
                : 'No time selected yet',
            style: TextStyle(
              fontSize: AppSize.textLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        // Giữ lại text của bạn
      ],
    );
  }
}
