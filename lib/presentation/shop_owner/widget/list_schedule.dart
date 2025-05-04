import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/presentation/shop_owner/bloc/resolve_booking/resolve_booking_cubit.dart';
import '../../../common/helper/schedule_model.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../../service/widget/custom_time_picker.dart';

class ListSchedule extends StatefulWidget {
  const ListSchedule({super.key, required this.schedules, this.duration});
  final List<ScheduleModel> schedules;
  final int? duration;

  @override
  State<ListSchedule> createState() => _ListScheduleState();
}

class _ListScheduleState extends State<ListSchedule> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;

    Future<void> showScheduleDialog(ScheduleModel schedule) async {
      if (schedule.date == null ||
          schedule.timeFrom == null ||
          schedule.timeTo == null ||
          schedule.timeFromAsDateTime == null ||
          schedule.timeToAsDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Schedule data is incomplete.')),
        );
        return;
      }
      final TimeOfDay? pickedTime = await showCustomHourMinutePicker(
        context: context,
        initialTime: schedule.timeFrom!,
        startHour: schedule.timeFrom!.hour,
        endHour: schedule.timeTo!.hour,
        minuteInterval: 60,
      );

      if (pickedTime != null) {
        final DateTime combinedDateTime = DateTime(
          schedule.date!.year,
          schedule.date!.month,
          schedule.date!.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        context
            .read<ResolveBookingShopCubit>()
            .updatebookedDate(combinedDateTime);
      }
    }

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
              'Customer  free time',
              style: TextStyle(
                  fontSize: AppSize.textHeading,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black87),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.schedules.length,
              itemBuilder: (context, index) {
                final schedule = widget.schedules[index];
                final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

                return ListTile(
                  leading: Icon(
                    Icons.date_range_rounded,
                    size: AppSize.iconMedium,
                    color: AppColors.primary,
                  ),
                  title: Row(
                    children: [
                      Text(
                        dateFormat.format(schedule.date!),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: AppSize.textMedium),
                      ),
                      SizedBox(width: 10.w),
                      Icon(
                        Icons.timelapse_outlined,
                        size: AppSize.iconMedium,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        '${DateFormat('HH:mm').format(schedule.timeFromAsDateTime!)} - ${DateFormat('HH:mm').format(schedule.timeToAsDateTime!)}',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: AppSize.textMedium),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.touch_app, color: AppColors.background),
                  onTap: () {
                    showScheduleDialog(schedule);
                  },
                );
              },
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
