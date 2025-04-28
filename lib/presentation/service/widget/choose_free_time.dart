import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';

import '../../../common/helper/schedule_model.dart';
import '../../../common/widget/blog/custom_bottomsheet.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../../../data/shop/models/booking_service_req.dart';
import '../../../data/shop/models/reschedule_booking_model.dart';
import '../bloc/bookingservice/booking_service_cubit.dart';
import '../bloc/bookingservice/reschedule_booking/cubit/reschedule_booking_cubit.dart';
import 'custom_time_picker.dart';

class ChooseFreeTime {
  TextEditingController _timeFromCon = TextEditingController();
  TextEditingController _timeToCon = TextEditingController();
  TextEditingController _dateCon = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTimeFrom;
  TimeOfDay? _selectedTimeTo;

  final List<ScheduleModel> _schedules = [];
  void showScheduleBottomSheet(BuildContext context, int? serviceId) {
    final bookingCubit = context.read<BookingServiceCubit>();

    // Reset các giá trị khi mở bottom sheet mới
    _timeFromCon = TextEditingController();
    _timeToCon = TextEditingController();
    _dateCon = TextEditingController();
    _selectedDate = null;
    _selectedTimeFrom = null;
    _selectedTimeTo = null;

    // Biến để theo dõi lỗi
    String? errorMessage;

    CustomModalBottomSheet.show(
      maxSize: 1,
      initialSize: .8,
      context: context,
      child: StatefulBuilder(
        builder: (context, setModalState) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color:
                        context.isDarkMode ? AppColors.darkGrey : Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppSize.borderRadiusMedium),
                        topRight: Radius.circular(AppSize.borderRadiusMedium))),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Appointment',
                          style: TextStyle(
                            fontSize: AppSize.textHeading,
                            color: context.isDarkMode
                                ? Colors.grey.shade300
                                : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    // Hiển thị thông báo lỗi nếu có
                    if (errorMessage != null)
                      Container(
                        margin: EdgeInsets.only(bottom: 16.h),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                errorMessage!,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: AppSize.textSmall,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setModalState(() {
                                  errorMessage = null;
                                });
                              },
                              child: Icon(Icons.close,
                                  color: Colors.red, size: AppSize.iconLarge),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 8.h),
                    Form(
                      child: Column(
                        children: [
                          TextFormField(
                            readOnly: true,
                            controller: _dateCon,
                            decoration: InputDecoration(
                              label: Text(
                                'Date',
                                style: TextStyle(
                                  fontSize: AppSize.textMedium,
                                  color: context.isDarkMode
                                      ? Colors.grey.shade300
                                      : Colors.black87,
                                ),
                              ),
                              suffixIcon: InkWell(
                                onTap: () async {
                                  // Tạo một bản sao của danh sách lịch để truyền vào hàm pickDateTime
                                  final currentSchedules =
                                      List<ScheduleModel>.from(_schedules);
                                  final pickedDate = await pickDateTime(
                                      context, currentSchedules);
                                  if (pickedDate != null) {
                                    setModalState(() {
                                      errorMessage =
                                          null; // Xóa lỗi nếu thành công
                                      _selectedDate = pickedDate;
                                      _dateCon.text = DateFormat('dd-MM-yyyy')
                                          .format(pickedDate);
                                    });
                                  }
                                },
                                child: Icon(
                                  Icons.calendar_today,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              hintText: 'Select date',
                              hintStyle: TextStyle(
                                fontSize: AppSize.textMedium,
                                color: context.isDarkMode
                                    ? Colors.grey.shade300
                                    : Colors.black87,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.background),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: _timeFromCon,
                                  decoration: InputDecoration(
                                    label: Text(
                                      'From',
                                      style: TextStyle(
                                        fontSize: AppSize.textMedium,
                                        color: context.isDarkMode
                                            ? Colors.grey.shade300
                                            : Colors.black87,
                                      ),
                                    ),
                                    suffixIcon: InkWell(
                                      onTap: () async {
                                        if (_selectedDate == null) {
                                          setModalState(() {
                                            errorMessage =
                                                'Please select a date first';
                                          });
                                          return;
                                        }

                                        // Sử dụng TimePicker tùy chỉnh
                                        final time =
                                            await showCustomHourMinutePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                          startHour: 9,
                                          endHour: 20,
                                          minuteInterval: 15,
                                        );

                                        if (time != null) {
                                          // Kiểm tra thời gian hợp lệ nếu là ngày hôm nay
                                          if (!_isValidTimeForToday(
                                              _selectedDate!, time)) {
                                            setModalState(() {
                                              errorMessage =
                                                  'Cannot select time in the past';
                                            });
                                            return;
                                          }

                                          setModalState(() {
                                            errorMessage =
                                                null; // Xóa lỗi nếu thành công
                                            _selectedTimeFrom = time;
                                            _timeFromCon.text =
                                                time.format(context);

                                            // Reset timeTo nếu không còn hợp lệ
                                            if (_selectedTimeTo != null &&
                                                !_isTimeFromBeforeTimeTo(
                                                    time, _selectedTimeTo!)) {
                                              _selectedTimeTo = null;
                                              _timeToCon.clear();
                                            }
                                          });
                                        }
                                      },
                                      child: Icon(
                                        Icons.access_time,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    hintText: 'Start time',
                                    hintStyle: TextStyle(
                                      fontSize: AppSize.textMedium,
                                      color: context.isDarkMode
                                          ? Colors.grey.shade300
                                          : Colors.black87,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.background),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: _timeToCon,
                                  decoration: InputDecoration(
                                    label: Text(
                                      'To',
                                      style: TextStyle(
                                        fontSize: AppSize.textMedium,
                                        color: context.isDarkMode
                                            ? Colors.grey.shade300
                                            : Colors.black87,
                                      ),
                                    ),
                                    suffixIcon: InkWell(
                                      onTap: () async {
                                        if (_selectedDate == null) {
                                          setModalState(() {
                                            errorMessage =
                                                'Please select a date first';
                                          });
                                          return;
                                        }

                                        if (_selectedTimeFrom == null) {
                                          setModalState(() {
                                            errorMessage =
                                                'Please select start time first';
                                          });
                                          return;
                                        }

                                        // Sử dụng TimePicker tùy chỉnh, bắt đầu từ thời gian "From" trở đi
                                        final time =
                                            await showCustomHourMinutePicker(
                                          context: context,
                                          initialTime: _selectedTimeFrom ??
                                              TimeOfDay.now(),
                                          startHour: _selectedTimeFrom!.hour,
                                          endHour: 20,
                                          minuteInterval: 15,
                                        );

                                        if (time != null) {
                                          // Kiểm tra timeTo phải sau timeFrom
                                          if (!_isTimeFromBeforeTimeTo(
                                              _selectedTimeFrom!, time)) {
                                            setModalState(() {
                                              errorMessage =
                                                  'End time must be after start time';
                                            });
                                            return;
                                          }

                                          setModalState(() {
                                            errorMessage =
                                                null; // Xóa lỗi nếu thành công
                                            _selectedTimeTo = time;
                                            _timeToCon.text =
                                                time.format(context);
                                          });
                                        }
                                      },
                                      child: Icon(
                                        Icons.access_time,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    hintText: 'End time',
                                    hintStyle: TextStyle(
                                      fontSize: AppSize.textMedium,
                                      color: context.isDarkMode
                                          ? Colors.grey.shade300
                                          : Colors.black87,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.background),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          ElevatedButton(
                            onPressed: () {
                              // Kiểm tra đã chọn đủ date, timeFrom, timeTo chưa
                              if (_selectedDate == null ||
                                  _selectedTimeFrom == null ||
                                  _selectedTimeTo == null) {
                                setModalState(() {
                                  errorMessage = 'Please select date and time';
                                });
                                return;
                              }

                              // Kiểm tra from < to
                              if (!_isTimeFromBeforeTimeTo(
                                  _selectedTimeFrom!, _selectedTimeTo!)) {
                                setModalState(() {
                                  errorMessage =
                                      'Start time must be before end time';
                                });
                                return;
                              }

                              // Kiểm tra thời gian hợp lệ (nếu ngày hôm nay thì giờ phải > giờ hiện tại)
                              if (!_isValidTimeForToday(
                                  _selectedDate!, _selectedTimeFrom!)) {
                                setModalState(() {
                                  errorMessage =
                                      'Cannot select time in the past';
                                });
                                return;
                              }

                              // Thêm vào danh sách lịch

                              _schedules.add(ScheduleModel(
                                date: _selectedDate!,
                                timeFrom: _selectedTimeFrom!,
                                timeTo: _selectedTimeTo!,
                              ));

                              bookingCubit.updateSchedules(_schedules);
                              // Thông báo ra bên ngoài nếu có callback
                              // if (widget.onSchedulesChanged != null) {
                              //   widget.onSchedulesChanged!(_schedules);
                              // }

                              setModalState(() {
                                errorMessage = null; // Xóa lỗi nếu thành công
                              });

                              // Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Add Schedule',
                              style: TextStyle(
                                  fontSize: AppSize.textLarge,
                                  fontWeight: FontWeight.bold,
                                  color: context.isDarkMode
                                      ? Colors.grey.shade300
                                      : Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: scheduleList(context, serviceId))
            ],
          );
        },
      ),
    );
  }

  Widget scheduleList(BuildContext context, int? serviceId) {
    var bookingCubit = context.read<BookingServiceCubit>();
    return Container(
      color: Colors.white,
      width: double.infinity,
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Schedules',
                  style: TextStyle(
                    fontSize: AppSize.textLarge,
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

          Divider(height: 1),

          Expanded(
            child: bookingCubit.schedules != null
                ? ListView.builder(
                    itemCount: bookingCubit.schedules!.length,
                    // padding: EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      final schedule = bookingCubit.schedules![index];
                      final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

                      return ListTile(
                        title: Text(
                          dateFormat.format(schedule.date!),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          '${schedule.timeFrom!.format(context)} - ${schedule.timeTo!.format(context)}',
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                            bookingCubit.schedules!.removeAt(index);

                            // if (widget.onSchedulesChanged != null) {
                            //   widget.onSchedulesChanged!(_schedules);
                            // }
                            // // Nếu xóa hết lịch thì đóng dialog
                            if (bookingCubit.schedules!.isEmpty) {
                              Navigator.pop(context);
                            }
                          }

                          // widget.deleteSchedule

                          ,
                        ),
                      );
                    },
                  )
                : Container(),
          ),
          // Center(

          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // widget.clearAll;

                    bookingCubit.schedules!.clear();

                    // if (widget.onSchedulesChanged != null) {
                    //   widget.onSchedulesChanged!(_schedules);
                    // }
                    Navigator.pop(context);
                  },
                  child: Text('Clear All'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.isDarkMode
                        ? AppColors.primary
                        : AppColors.secondBackground,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    List<int> rescheduleBooking = bookingCubit.reschedule;
                    // widget.confirm;
                    List<UserScheduleCreateDto> scheduleDtos =
                        bookingCubit.schedules!.map((schedule) {
                      return UserScheduleCreateDto(
                          date: schedule.date,
                          timeFrom: _formatTime(schedule.timeFrom!),
                          timeTo: _formatTime(schedule.timeTo!));
                    }).toList();

                    // If you have cart items, use bookingCartCreateDtos
                    if (bookingCubit.selectedServices.isNotEmpty) {
                      List<BookingCartCreateDto> bookingCartDtos =
                          bookingCubit.selectedServices.map((item) {
                        return BookingCartCreateDto(
                            bookingQueueId: item.itemId,
                            note: bookingCubit
                                    .serviceNotes[item.itemId.toString()] ??
                                "");
                      }).toList();

                      context.read<BookingServiceCubit>().bookingServie(
                          BookingServiceReq(
                              bookingCreateDto: null,
                              bookingCartCreateDtos: bookingCartDtos,
                              userScheduleCreateDtos: scheduleDtos));
                    } else if (serviceId != null) {
                      BookingCreateDto bookingCreateDto = BookingCreateDto(
                          serviceId: serviceId,
                          note:
                              bookingCubit.serviceNotes[serviceId.toString()]);
                      context.read<BookingServiceCubit>().bookingServie(
                          BookingServiceReq(
                              bookingCreateDto: bookingCreateDto,
                              bookingCartCreateDtos: null,
                              userScheduleCreateDtos: scheduleDtos));
                    } else if (rescheduleBooking.isNotEmpty) {
                      context.read<RescheduleBookingCubit>().rescheduleBooking(
                          RescheduleBookingModel(
                              bookingIds: rescheduleBooking,
                              userScheduleCreateDtos: scheduleDtos));
                    }
                    bookingCubit.reschedule.clear();
                    bookingCubit.schedules!.clear();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                        fontSize: AppSize.textMedium,
                        color: context.isDarkMode
                            ? Colors.grey.shade300
                            : Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Kiểm tra timeFrom < timeTo
  bool _isTimeFromBeforeTimeTo(TimeOfDay from, TimeOfDay to) {
    final now = DateTime.now();
    final timeFrom =
        DateTime(now.year, now.month, now.day, from.hour, from.minute);
    final timeTo = DateTime(now.year, now.month, now.day, to.hour, to.minute);

    return timeFrom.isBefore(timeTo);
  }

  // Kiểm tra thời gian hợp lệ cho ngày hôm nay
  bool _isValidTimeForToday(DateTime date, TimeOfDay time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(date.year, date.month, date.day);

    // Nếu không phải hôm nay thì luôn hợp lệ
    if (selectedDate.isAfter(today)) {
      return true;
    }

    final selectedTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return selectedTime.isAfter(now);
  }

  Future<DateTime?> pickDateTime(
      BuildContext context, List<ScheduleModel> currentSchedules) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      firstDate: today, 
      lastDate: DateTime(now.year + 1, now.month + 1),
      initialDate: now,
      selectableDayPredicate: (DateTime day) {
        final dayDate = DateTime(day.year, day.month, day.day);

        bool isAlreadySelected = false;
        for (var schedule in currentSchedules) {
          final scheduleDate = DateTime(
              schedule.date!.year, schedule.date!.month, schedule.date!.day);
          if (scheduleDate.year == dayDate.year &&
              scheduleDate.month == dayDate.month &&
              scheduleDate.day == dayDate.day) {
            isAlreadySelected = true;
            break;
          }
        }

        return !isAlreadySelected && !dayDate.isBefore(today);
      },
    );

    if (pickedDate == null) return null;

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
    );
  }
}

String _formatTime(TimeOfDay time) {
  // Định dạng thời gian theo định dạng "HH:mm"
  // Ví dụ: "14:30"
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return "$hour:$minute";
}
