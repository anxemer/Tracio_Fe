import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/data/shop/models/booking_service_req.dart';
import 'package:tracio_fe/domain/shop/entities/booking_card_view.dart';
import 'package:tracio_fe/domain/shop/entities/cart_item_entity.dart';
import 'package:tracio_fe/domain/shop/entities/shop_service_entity.dart';
import 'package:tracio_fe/presentation/service/bloc/bookingservice/booking_service_cubit.dart';
import 'package:tracio_fe/presentation/service/page/my_booking.dart';
import 'package:tracio_fe/presentation/service/page/service.dart';
import 'package:tracio_fe/presentation/service/widget/custom_time_picker.dart';

import '../../../common/helper/schedule_model.dart';
import '../../../common/widget/blog/custom_bottomsheet.dart';
import '../../../common/widget/button/text_button.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import '../../../core/constants/app_size.dart';
import '../bloc/bookingservice/booking_service_state.dart';

// GlobalKey cho navigatorKey
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AddSchedule extends StatefulWidget {
  const AddSchedule({
    super.key,
    this.onSchedulesChanged,
    this.cartItem,
    this.service,
  });
  // final List<BookingCardViewModel> bookingModel;
  final List<CartItemEntity>? cartItem;
  final ShopServiceEntity? service;
  final Function(List<ScheduleModel>)? onSchedulesChanged;

  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  TextEditingController _timeFromCon = TextEditingController();
  TextEditingController _timeToCon = TextEditingController();
  TextEditingController _dateCon = TextEditingController();

  // Thêm các biến để lưu trữ giá trị thực tế
  DateTime? _selectedDate;
  TimeOfDay? _selectedTimeFrom;
  TimeOfDay? _selectedTimeTo;

  // Danh sách lịch đã đặt
  List<ScheduleModel> _schedules = [];

  // Kiểm tra xem ngày đã được chọn chưa
  // bool _isDateSelected(DateTime date) {
  //   // Chuẩn hóa date bằng cách loại bỏ thời gian, chỉ giữ lại ngày/tháng/năm
  //   final targetDate = DateTime(date.year, date.month, date.day);

  //   // So sánh với từng ngày trong danh sách lịch đã đặt
  //   for (var schedule in _schedules) {
  //     final scheduleDate =
  //         DateTime(schedule.date.year, schedule.date.month, schedule.date.day);

  //     // So sánh năm, tháng, ngày
  //     if (scheduleDate.year == targetDate.year &&
  //         scheduleDate.month == targetDate.month &&
  //         scheduleDate.day == targetDate.day) {
  //       return true;
  //     }
  //   }

  //   return false;
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingServiceCubit, BookingServiceState>(
        listener: (context, state) {
      if (state is BookingServiceLoading) {
        EasyLoading.show(status: 'Loading...');
      } else if (state is BookingServiceSuccess) {
        context.read<BookingServiceCubit>().clearBookingItem();
        EasyLoading.dismiss();
        AppNavigator.push(context, MyBookingPage());
      } else if (state is BookingServiceFailure) {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking failed: ${state.message}')),
        );
      }
    }, builder: (context, state) {
      final bookingCubit = context.watch<BookingServiceCubit>();
      return Column(
        // mainAxisSize: MainAxisSize.min, // Đảm bảo chỉ chiếm không gian cần thiết
        children: [
          // ShowScheduleBottom(cartItem: widget.cartItem),
          BasicTextButton(
            text: 'Schedule ${bookingCubit.selectedServices.length} service',
            onPress: () {
              if ((bookingCubit.selectedServices.isEmpty) &&
                  widget.service == null) {
                _showErrorSnackBar(context, 'Please Select Service');
              } else {
                _showScheduleBottomSheet(context);
              }
            },
            borderColor: Colors.black,
          ),

          // Hiển thị danh sách lịch đã đặt trong dialogbox riêng thay vì mở rộng trực tiếp
          if (bookingCubit.schedules != null &&
              bookingCubit.schedules!.isNotEmpty)
            InkWell(
              onTap: () {
                _showScheduleListDialog(context);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ),
                child: Row(
                  children: [
                    Icon(Icons.event_note,
                        color: Colors.blue, size: AppSize.iconSmall),
                    SizedBox(width: 4.w),
                    Text(
                      '${bookingCubit.schedules!.length} schedules selected',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios,
                        size: AppSize.iconSmall, color: Colors.blue),
                  ],
                ),
              ),
            ),
        ],
      );
    });
  }

  // Hiển thị dialog danh sách lịch đã đặt
  void _showScheduleListDialog(BuildContext context) {
    final bookingCubit = context.read<BookingServiceCubit>();

    var isDark = context.isDarkMode;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.borderRadiusLarge)),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Phần tiêu đề Services
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Services',
                        style: TextStyle(
                          fontSize: AppSize.textLarge,
                          fontWeight: FontWeight.bold,
                          color: context.isDarkMode
                              ? Colors.grey.shade300
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                // Danh sách services - có chiều cao cố định
                Container(
                  height: AppSize
                      .cardHeight.h, // Chiều cao cố định cho phần services
                  child: ListView.builder(
                    itemCount: widget.cartItem?.length ?? 1,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.all(4),
                        // height: 80,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(
                                AppSize.borderRadiusMedium)),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                AppImages.picture,
                                width: AppSize.imageSmall.w,
                                height: AppSize.imageSmall.h * .8,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        (widget.cartItem != null &&
                                                widget.cartItem!.length > index)
                                            ? widget
                                                .cartItem![index].serviceName!
                                            : widget.service!.name!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppSize.textMedium.sp,
                                          color: isDark
                                              ? Colors.grey.shade300
                                              : Colors.black87,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.attach_money_outlined,
                                            size: AppSize.iconSmall,
                                            color: isDark
                                                ? AppColors.secondBackground
                                                : AppColors.background,
                                          ),
                                          Text(
                                            (widget.cartItem != null &&
                                                    widget.cartItem!.length >
                                                        index)
                                                ? widget.cartItem![index].price
                                                    .toString()
                                                : widget.service!.price
                                                    .toString(),
                                            style: TextStyle(
                                                fontSize: AppSize.textSmall,
                                                color: isDark
                                                    ? Colors.grey.shade300
                                                    : Colors.black87),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Phần tiêu đề Schedules
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

                // Danh sách lịch trình - chiếm phần không gian còn lại
                Expanded(
                  child: ListView.builder(
                    itemCount: bookingCubit.schedules!.length,
                    // padding: EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      final schedule = bookingCubit.schedules![index];
                      final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

                      return ListTile(
                        title: Text(
                          dateFormat.format(schedule.date),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          '${schedule.timeFrom.format(context)} - ${schedule.timeTo.format(context)}',
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                            bookingCubit.removeSchedules(
                                bookingCubit.schedules![index]);
                            setState(() {
                              _schedules = List.from(bookingCubit.schedules!);
                            });
                            if (widget.onSchedulesChanged != null) {
                              widget.onSchedulesChanged!(_schedules);
                            }
                            // Nếu xóa hết lịch thì đóng dialog
                            if (_schedules.isEmpty) {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                // Center(
                //     child: BasicTextButton(
                //   text: 'Add more schedule',
                //   onPress: () {
                //     Navigator.pop(context);
                //     _showScheduleBottomSheet(context);
                //     if (widget.onSchedulesChanged != null) {
                //       widget.onSchedulesChanged!(_schedules);
                //     }
                //     if (_schedules.isNotEmpty) {
                //       _showScheduleListDialog(context);
                //     }
                //   },
                //   borderColor: Colors.white,
                // )),
                // Phần nút bấm
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _schedules.clear();
                          });
                          if (widget.onSchedulesChanged != null) {
                            widget.onSchedulesChanged!(_schedules);
                          }
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
                          List<UserScheduleCreateDto> scheduleDtos =
                              bookingCubit.schedules!.map((schedule) {
                            return UserScheduleCreateDto(
                                date: schedule.date,
                                timeFrom: _formatTime(schedule.timeFrom),
                                timeTo: _formatTime(schedule.timeTo));
                          }).toList();

                          // If you have cart items, use bookingCartCreateDtos
                          if (bookingCubit.selectedServices.isNotEmpty) {
                            List<BookingCartCreateDto> bookingCartDtos =
                                widget.cartItem!.map((item) {
                              return BookingCartCreateDto(
                                  bookingQueueId: item.itemId,
                                  note: bookingCubit.serviceNotes[
                                          item.itemId.toString()] ??
                                      "");
                            }).toList();

                            context.read<BookingServiceCubit>().bookingServie(
                                BookingServiceReq(
                                    bookingCreateDto: null,
                                    bookingCartCreateDtos: bookingCartDtos,
                                    userScheduleCreateDtos: scheduleDtos));
                          } else if (widget.service != null) {
                            BookingCreateDto bookingCreateDto =
                                BookingCreateDto(
                                    serviceId: widget.service!.serviceId,
                                    note: bookingCubit.serviceNotes[
                                        widget.service!.serviceId.toString()]);
                            context.read<BookingServiceCubit>().bookingServie(
                                BookingServiceReq(
                                    bookingCreateDto: bookingCreateDto,
                                    bookingCartCreateDtos: null,
                                    userScheduleCreateDtos: scheduleDtos));
                          }
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
          ),
        ),
      ),
    );
  }

  void _showScheduleBottomSheet(BuildContext context) {
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
      initialSize: .5,
      context: context,
      child: StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.all(16),
            color: context.isDarkMode ? AppColors.darkGrey : Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Schedule',
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
                              final pickedDate =
                                  await pickDateTime(context, currentSchedules);
                              if (pickedDate != null) {
                                setModalState(() {
                                  errorMessage = null; // Xóa lỗi nếu thành công
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
                            borderSide: BorderSide(color: AppColors.background),
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
                                  borderSide:
                                      BorderSide(color: AppColors.background),
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
                                      initialTime:
                                          _selectedTimeFrom ?? TimeOfDay.now(),
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
                                        _timeToCon.text = time.format(context);
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
                                  borderSide:
                                      BorderSide(color: AppColors.background),
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
                              errorMessage = 'Cannot select time in the past';
                            });
                            return;
                          }

                          // Thêm vào danh sách lịch
                          setState(() {
                            _schedules.add(ScheduleModel(
                              date: _selectedDate!,
                              timeFrom: _selectedTimeFrom!,
                              timeTo: _selectedTimeTo!,
                            ));
                          });
                          bookingCubit.updateSchedules(_schedules);
                          // Thông báo ra bên ngoài nếu có callback
                          if (widget.onSchedulesChanged != null) {
                            widget.onSchedulesChanged!(_schedules);
                          }

                          setModalState(() {
                            errorMessage = null; // Xóa lỗi nếu thành công
                          });
                          Navigator.pop(context);
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
          );
        },
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

    // Nếu là hôm nay, kiểm tra giờ phải lớn hơn giờ hiện tại
    final selectedTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return selectedTime.isAfter(now);
  }

  // Hiển thị thông báo lỗi
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red.shade50,
        content: Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: Colors.red,
            ),
            const SizedBox(width: 8),
            Text(
              message,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: AppSize.textMedium,
                color: Colors.red,
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'Close',
          textColor: Colors.red,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  Future<DateTime?> pickDateTime(
      BuildContext context, List<ScheduleModel> currentSchedules) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      firstDate: today, // Từ ngày hiện tại trở đi
      lastDate: DateTime(now.year + 1, now.month + 1),
      initialDate: now,
      // Tùy chỉnh ngày không được chọn (ngày đã có trong lịch hoặc ngày trong quá khứ)
      selectableDayPredicate: (DateTime day) {
        // Ngày phải từ hôm nay trở đi và chưa được chọn
        final dayDate = DateTime(day.year, day.month, day.day);

        // Kiểm tra ngày đã được chọn trong danh sách lịch hiện tại
        bool isAlreadySelected = false;
        for (var schedule in currentSchedules) {
          final scheduleDate = DateTime(
              schedule.date.year, schedule.date.month, schedule.date.day);
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
    if (!mounted) return null;

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
