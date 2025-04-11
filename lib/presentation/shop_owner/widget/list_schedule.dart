import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/presentation/shop_owner/bloc/cubit/resolve_booking_cubit.dart';
import '../../../common/helper/schedule_model.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../../service/widget/custom_time_picker.dart';
import 'start_time_tab.dart';

class ListSchedule extends StatelessWidget {
  const ListSchedule({super.key, required this.schedules, this.duration});
  final List<ScheduleModel> schedules;
  final int? duration;

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;

    Future<void> _showScheduleDialog(ScheduleModel schedule) async {
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

      DateTime? selectedStartDateTime;
      DateTime? selectedEndDateTime;

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Select Schedule'),
            content: SizedBox(
              width: double.maxFinite,
              height: 300.h, // Chiều cao dialog
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: 'Start Time'),
                        Tab(text: 'End Time'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          StartTimeTab(
                            duration: duration!,
                            schedule: schedule,
                            onTimeSelected: (pickedDateTime) {
                              context
                                  .read<ResolveBookingShopCubit>()
                                  .updatebookedDate(pickedDateTime, duration!
                                      // estimatedEndDate: endTime,
                                      );
                              selectedStartDateTime = pickedDateTime;
                            },
                          ),
                          _buildEndTimePicker(
                            context,
                            schedule,
                            (pickedDateTime) {
                              selectedEndDateTime = pickedDateTime;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // Hủy
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (selectedStartDateTime != null) {
                    // Nếu không chọn end time, dùng duration để tính
                    selectedEndDateTime ??= selectedStartDateTime!
                        .add(Duration(minutes: duration ?? 0));
                    context.read<ResolveBookingShopCubit>().updatebookedDate(
                          selectedStartDateTime!,
                          duration ?? 0, // Dùng duration mặc định nếu cần
                        );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Selected: ${DateFormat('HH:mm').format(selectedStartDateTime!)} on ${DateFormat('dd/MM').format(selectedStartDateTime!)} - End: ${DateFormat('HH:mm').format(selectedEndDateTime!)}',
                        ),
                      ),
                    );
                  }
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
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
              'User free time',
              style: TextStyle(
                  fontSize: AppSize.textHeading,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black87),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];
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
                    _showScheduleDialog(schedule);
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

  Widget _buildEndTimePicker(
    BuildContext context,
    ScheduleModel schedule,
    Function(DateTime) onTimeSelected,
  ) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          // Chọn ngày trước
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: schedule.date!,
            firstDate: schedule.date!,
            lastDate: schedule.date!.add(const Duration(days: 30)), // Giới hạn
          );

          if (pickedDate != null) {
            final TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(schedule.timeToAsDateTime!),
            );

            if (pickedTime != null) {
              final DateTime selectedEndDateTime = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );
              onTimeSelected(selectedEndDateTime);
            }
          }
        },
        child: const Text('Pick End Time'),
      ),
    );
  }
}
