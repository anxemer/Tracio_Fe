import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/core/constants/app_size.dart';

class CustomTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final Function(TimeOfDay) onTimeSelected;
  final int startHour;
  final int endHour;
  final int minuteInterval;

  const CustomTimePicker({
    Key? key,
    required this.initialTime,
    required this.onTimeSelected,
    this.startHour = 9,
    this.endHour = 20,
    this.minuteInterval = 15,
  }) : super(key: key);

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late TimeOfDay selectedTime;
  late int selectedHour;
  late int selectedMinute;

  @override
  void initState() {
    super.initState();
    // Đảm bảo thời gian ban đầu nằm trong phạm vi cho phép
    int initialHour = widget.initialTime.hour;
    int initialMinute = widget.initialTime.minute;

    if (initialHour < widget.startHour) {
      initialHour = widget.startHour;
      initialMinute = 0;
    } else if (initialHour > widget.endHour) {
      initialHour = widget.endHour;
      initialMinute = 0;
    }

    // Làm tròn phút theo khoảng
    initialMinute =
        (initialMinute ~/ widget.minuteInterval) * widget.minuteInterval;

    selectedTime = TimeOfDay(hour: initialHour, minute: initialMinute);
    selectedHour = initialHour;
    selectedMinute = initialMinute;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Time',
                    style: TextStyle(
                      fontSize: AppSize.textLarge.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Hiển thị thời gian đã chọn
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                '${selectedTime.format(context)}',
                style: TextStyle(
                  fontSize: AppSize.textLarge,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),

            // Phần chọn giờ
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 16),
              child: Text(
                'Hour (${widget.startHour} - ${widget.endHour})',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.endHour - widget.startHour + 1,
                itemBuilder: (context, index) {
                  final hour = widget.startHour + index;
                  final isSelected = selectedHour == hour;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedHour = hour;
                          selectedTime =
                              TimeOfDay(hour: hour, minute: selectedMinute);
                          widget.onTimeSelected(selectedTime);
                        });
                      },
                      child: Container(
                        width: 50,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$hour',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Phần chọn phút
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 16),
              child: Text(
                'Minute',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 60 ~/ widget.minuteInterval,
                itemBuilder: (context, index) {
                  final minute = index * widget.minuteInterval;
                  final isSelected = selectedMinute == minute;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedMinute = minute;
                          selectedTime =
                              TimeOfDay(hour: selectedHour, minute: minute);
                          widget.onTimeSelected(selectedTime);
                        });
                      },
                      child: Container(
                        width: 50,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          minute.toString().padLeft(2, '0'),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('CANCEL'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, selectedTime);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(
                        color: context.isDarkMode
                            ? Colors.grey.shade300
                            : Colors.black87),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Hàm hiển thị Time Picker tùy chỉnh
Future<TimeOfDay?> showCustomHourMinutePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
  int startHour = 9,
  int endHour = 20,
  int minuteInterval = 15,
}) async {

  TimeOfDay adjustedInitialTime = initialTime;
  if (initialTime.hour < startHour) {
    adjustedInitialTime = TimeOfDay(hour: startHour, minute: 0);
  } else if (initialTime.hour > endHour) {
    adjustedInitialTime = TimeOfDay(hour: endHour, minute: 0);
  }

  // Hiển thị dialog với time picker tùy chỉnh
  final result = await showDialog<TimeOfDay>(
    context: context,
    builder: (BuildContext context) {
      TimeOfDay selectedTime = adjustedInitialTime;

      return CustomTimePicker(
        initialTime: adjustedInitialTime,
        startHour: startHour,
        endHour: endHour,
        minuteInterval: minuteInterval,
        onTimeSelected: (time) {
          selectedTime = time;
        },
      );
    },
  );

  return result;
}
