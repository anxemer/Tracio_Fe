// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:tracio_fe/common/helper/is_dark_mode.dart';
// import 'package:tracio_fe/common/widget/button/text_button.dart';

// import '../../../common/widget/blog/custom_bottomsheet.dart';
// import '../../../core/configs/theme/app_colors.dart';
// import '../../../core/constants/app_size.dart';
// import '../../../domain/shop/entities/cart_item_entity.dart';
// import 'custom_time_picker.dart';

// class ShowScheduleBottom extends StatefulWidget {
//   const ShowScheduleBottom({super.key, required this.cartItem, this.onSchedulesChanged});
//   final List<CartItemEntity> cartItem;
//   final Function(List<ScheduleModel>)? onSchedulesChanged;


//   @override
//   State<ShowScheduleBottom> createState() => _ShowScheduleBottomState();
// }

// class _ShowScheduleBottomState extends State<ShowScheduleBottom> {
//   TextEditingController _timeFromCon = TextEditingController();
//   TextEditingController _timeToCon = TextEditingController();
//   TextEditingController _dateCon = TextEditingController();
//   DateTime? _selectedDate;
//   TimeOfDay? _selectedTimeFrom;
//   TimeOfDay? _selectedTimeTo;

//   List<ScheduleModel> _schedules = [];
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         BasicTextButton(
//           text: 'Schedule ${widget.cartItem.length} service',
//           onPress: () {
//             if (widget.cartItem.isEmpty) {
//               _showErrorSnackBar(context, 'Please Select Service');
//             } else {
//               _showScheduleBottomSheet(context);
//             }
//           },
//           borderColor: Colors.black,
//         ),
        
//       ],
//     );
//   }

//   void _showScheduleBottomSheet(BuildContext context) {
//     _timeFromCon = TextEditingController();
//     _timeToCon = TextEditingController();
//     _dateCon = TextEditingController();
//     _selectedDate = null;
//     _selectedTimeFrom = null;
//     _selectedTimeTo = null;

//     // Biến để theo dõi lỗi
//     String? errorMessage;

//     CustomModalBottomSheet.show(
//       maxSize: 1,
//       initialSize: .5,
//       context: context,
//       child: StatefulBuilder(
//         builder: (context, setModalState) {
//           return Container(
//             padding: EdgeInsets.all(16),
//             color: context.isDarkMode ? AppColors.darkGrey : Colors.white,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Add Schedule',
//                       style: TextStyle(
//                         fontSize: AppSize.textHeading,
//                         color: context.isDarkMode
//                             ? Colors.grey.shade300
//                             : Colors.black87,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.close),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),

//                 // Hiển thị thông báo lỗi nếu có
//                 if (errorMessage != null)
//                   Container(
//                     margin: EdgeInsets.only(bottom: 16.h),
//                     padding: EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.red.shade50,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.red.shade200),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.error_outline, color: Colors.red),
//                         SizedBox(width: 8.w),
//                         Expanded(
//                           child: Text(
//                             errorMessage!,
//                             style: TextStyle(
//                               color: Colors.red,
//                               fontSize: AppSize.textSmall,
//                             ),
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             setModalState(() {
//                               errorMessage = null;
//                             });
//                           },
//                           child: Icon(Icons.close,
//                               color: Colors.red, size: AppSize.iconLarge),
//                         ),
//                       ],
//                     ),
//                   ),

//                 SizedBox(height: 8.h),
//                 Form(
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         readOnly: true,
//                         controller: _dateCon,
//                         decoration: InputDecoration(
//                           label: Text(
//                             'Date',
//                             style: TextStyle(
//                               fontSize: AppSize.textMedium,
//                               color: context.isDarkMode
//                                   ? Colors.grey.shade300
//                                   : Colors.black87,
//                             ),
//                           ),
//                           suffixIcon: InkWell(
//                             onTap: () async {
//                               // Tạo một bản sao của danh sách lịch để truyền vào hàm pickDateTime
//                               final currentSchedules =
//                                   List<ScheduleModel>.from(_schedules);
//                               final pickedDate =
//                                   await pickDateTime(context, currentSchedules);
//                               if (pickedDate != null) {
//                                 setModalState(() {
//                                   errorMessage = null; // Xóa lỗi nếu thành công
//                                   _selectedDate = pickedDate;
//                                   _dateCon.text = DateFormat('dd-MM-yyyy')
//                                       .format(pickedDate);
//                                 });
//                               }
//                             },
//                             child: Icon(
//                               Icons.calendar_today,
//                               color: Theme.of(context).primaryColor,
//                             ),
//                           ),
//                           hintText: 'Select date',
//                           hintStyle: TextStyle(
//                             fontSize: AppSize.textMedium,
//                             color: context.isDarkMode
//                                 ? Colors.grey.shade300
//                                 : Colors.black87,
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: AppColors.background),
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 16.h),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               readOnly: true,
//                               controller: _timeFromCon,
//                               decoration: InputDecoration(
//                                 label: Text(
//                                   'From',
//                                   style: TextStyle(
//                                     fontSize: AppSize.textMedium,
//                                     color: context.isDarkMode
//                                         ? Colors.grey.shade300
//                                         : Colors.black87,
//                                   ),
//                                 ),
//                                 suffixIcon: InkWell(
//                                   onTap: () async {
//                                     if (_selectedDate == null) {
//                                       setModalState(() {
//                                         errorMessage =
//                                             'Please select a date first';
//                                       });
//                                       return;
//                                     }

//                                     // Sử dụng TimePicker tùy chỉnh
//                                     final time =
//                                         await showCustomHourMinutePicker(
//                                       context: context,
//                                       initialTime: TimeOfDay.now(),
//                                       startHour: 9,
//                                       endHour: 20,
//                                       minuteInterval: 15,
//                                     );

//                                     if (time != null) {
//                                       // Kiểm tra thời gian hợp lệ nếu là ngày hôm nay
//                                       if (!_isValidTimeForToday(
//                                           _selectedDate!, time)) {
//                                         setModalState(() {
//                                           errorMessage =
//                                               'Cannot select time in the past';
//                                         });
//                                         return;
//                                       }

//                                       setModalState(() {
//                                         errorMessage =
//                                             null; // Xóa lỗi nếu thành công
//                                         _selectedTimeFrom = time;
//                                         _timeFromCon.text =
//                                             time.format(context);

//                                         // Reset timeTo nếu không còn hợp lệ
//                                         if (_selectedTimeTo != null &&
//                                             !_isTimeFromBeforeTimeTo(
//                                                 time, _selectedTimeTo!)) {
//                                           _selectedTimeTo = null;
//                                           _timeToCon.clear();
//                                         }
//                                       });
//                                     }
//                                   },
//                                   child: Icon(
//                                     Icons.access_time,
//                                     color: Theme.of(context).primaryColor,
//                                   ),
//                                 ),
//                                 hintText: 'Start time',
//                                 hintStyle: TextStyle(
//                                   fontSize: AppSize.textMedium,
//                                   color: context.isDarkMode
//                                       ? Colors.grey.shade300
//                                       : Colors.black87,
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide:
//                                       BorderSide(color: AppColors.background),
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(16),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 10.w),
//                           Expanded(
//                             child: TextFormField(
//                               readOnly: true,
//                               controller: _timeToCon,
//                               decoration: InputDecoration(
//                                 label: Text(
//                                   'To',
//                                   style: TextStyle(
//                                     fontSize: AppSize.textMedium,
//                                     color: context.isDarkMode
//                                         ? Colors.grey.shade300
//                                         : Colors.black87,
//                                   ),
//                                 ),
//                                 suffixIcon: InkWell(
//                                   onTap: () async {
//                                     if (_selectedDate == null) {
//                                       setModalState(() {
//                                         errorMessage =
//                                             'Please select a date first';
//                                       });
//                                       return;
//                                     }

//                                     if (_selectedTimeFrom == null) {
//                                       setModalState(() {
//                                         errorMessage =
//                                             'Please select start time first';
//                                       });
//                                       return;
//                                     }

//                                     // Sử dụng TimePicker tùy chỉnh, bắt đầu từ thời gian "From" trở đi
//                                     final time =
//                                         await showCustomHourMinutePicker(
//                                       context: context,
//                                       initialTime:
//                                           _selectedTimeFrom ?? TimeOfDay.now(),
//                                       startHour: _selectedTimeFrom!.hour,
//                                       endHour: 20,
//                                       minuteInterval: 15,
//                                     );

//                                     if (time != null) {
//                                       // Kiểm tra timeTo phải sau timeFrom
//                                       if (!_isTimeFromBeforeTimeTo(
//                                           _selectedTimeFrom!, time)) {
//                                         setModalState(() {
//                                           errorMessage =
//                                               'End time must be after start time';
//                                         });
//                                         return;
//                                       }

//                                       setModalState(() {
//                                         errorMessage =
//                                             null; // Xóa lỗi nếu thành công
//                                         _selectedTimeTo = time;
//                                         _timeToCon.text = time.format(context);
//                                       });
//                                     }
//                                   },
//                                   child: Icon(
//                                     Icons.access_time,
//                                     color: Theme.of(context).primaryColor,
//                                   ),
//                                 ),
//                                 hintText: 'End time',
//                                 hintStyle: TextStyle(
//                                   fontSize: AppSize.textMedium,
//                                   color: context.isDarkMode
//                                       ? Colors.grey.shade300
//                                       : Colors.black87,
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide:
//                                       BorderSide(color: AppColors.background),
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(16),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 24.h),
//                       ElevatedButton(
//                         onPressed: () {
//                           // Kiểm tra đã chọn đủ date, timeFrom, timeTo chưa
//                           if (_selectedDate == null ||
//                               _selectedTimeFrom == null ||
//                               _selectedTimeTo == null) {
//                             setModalState(() {
//                               errorMessage = 'Please select date and time';
//                             });
//                             return;
//                           }

//                           // Kiểm tra from < to
//                           if (!_isTimeFromBeforeTimeTo(
//                               _selectedTimeFrom!, _selectedTimeTo!)) {
//                             setModalState(() {
//                               errorMessage =
//                                   'Start time must be before end time';
//                             });
//                             return;
//                           }

//                           // Kiểm tra thời gian hợp lệ (nếu ngày hôm nay thì giờ phải > giờ hiện tại)
//                           if (!_isValidTimeForToday(
//                               _selectedDate!, _selectedTimeFrom!)) {
//                             setModalState(() {
//                               errorMessage = 'Cannot select time in the past';
//                             });
//                             return;
//                           }

//                           // Thêm vào danh sách lịch
//                           setState(() {
//                             _schedules.add(ScheduleModel(
//                               date: _selectedDate!,
//                               timeFrom: _selectedTimeFrom!,
//                               timeTo: _selectedTimeTo!,
//                             ));
//                           });

//                           // Thông báo ra bên ngoài nếu có callback
//                           if (widget.onSchedulesChanged != null) {
//                             widget.onSchedulesChanged!(_schedules);
//                           }

//                           setModalState(() {
//                             errorMessage = null; // Xóa lỗi nếu thành công
//                           });
//                           Navigator.pop(context);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           minimumSize: Size(double.infinity, 50.h),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                         ),
//                         child: Text(
//                           'Add Schedule',
//                           style: TextStyle(
//                               fontSize: AppSize.textLarge,
//                               fontWeight: FontWeight.bold,
//                               color: context.isDarkMode
//                                   ? Colors.grey.shade300
//                                   : Colors.black87),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // Kiểm tra timeFrom < timeTo
//   bool _isTimeFromBeforeTimeTo(TimeOfDay from, TimeOfDay to) {
//     final now = DateTime.now();
//     final timeFrom =
//         DateTime(now.year, now.month, now.day, from.hour, from.minute);
//     final timeTo = DateTime(now.year, now.month, now.day, to.hour, to.minute);

//     return timeFrom.isBefore(timeTo);
//   }

//   // Kiểm tra thời gian hợp lệ cho ngày hôm nay
//   bool _isValidTimeForToday(DateTime date, TimeOfDay time) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final selectedDate = DateTime(date.year, date.month, date.day);

//     // Nếu không phải hôm nay thì luôn hợp lệ
//     if (selectedDate.isAfter(today)) {
//       return true;
//     }

//     // Nếu là hôm nay, kiểm tra giờ phải lớn hơn giờ hiện tại
//     final selectedTime =
//         DateTime(now.year, now.month, now.day, time.hour, time.minute);
//     return selectedTime.isAfter(now);
//   }

//   // Hiển thị thông báo lỗi
//   void _showErrorSnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         backgroundColor: Colors.red.shade50,
//         content: Row(
//           children: [
//             const Icon(
//               Icons.info_outline_rounded,
//               color: Colors.red,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               message,
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: AppSize.textMedium,
//                 color: Colors.red,
//               ),
//             ),
//           ],
//         ),
//         action: SnackBarAction(
//           label: 'Close',
//           textColor: Colors.red,
//           onPressed: () {
//             ScaffoldMessenger.of(context).hideCurrentSnackBar();
//           },
//         ),
//       ),
//     );
//   }

//   Future<DateTime?> pickDateTime(
//       BuildContext context, List<ScheduleModel> currentSchedules) async {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);

//     final pickedDate = await showDatePicker(
//       context: context,
//       firstDate: today, // Từ ngày hiện tại trở đi
//       lastDate: DateTime(now.year + 1, now.month + 1),
//       initialDate: now,
//       // Tùy chỉnh ngày không được chọn (ngày đã có trong lịch hoặc ngày trong quá khứ)
//       selectableDayPredicate: (DateTime day) {
//         // Ngày phải từ hôm nay trở đi và chưa được chọn
//         final dayDate = DateTime(day.year, day.month, day.day);

//         // Kiểm tra ngày đã được chọn trong danh sách lịch hiện tại
//         bool isAlreadySelected = false;
//         for (var schedule in currentSchedules) {
//           final scheduleDate = DateTime(
//               schedule.date.year, schedule.date.month, schedule.date.day);
//           if (scheduleDate.year == dayDate.year &&
//               scheduleDate.month == dayDate.month &&
//               scheduleDate.day == dayDate.day) {
//             isAlreadySelected = true;
//             break;
//           }
//         }

//         return !isAlreadySelected && !dayDate.isBefore(today);
//       },
//     );

//     if (pickedDate == null) return null;
//     if (!mounted) return null;

//     return DateTime(
//       pickedDate.year,
//       pickedDate.month,
//       pickedDate.day,
//     );
//   }
// }

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// class ScheduleModel {
//   final DateTime date;
//   final TimeOfDay timeFrom;
//   final TimeOfDay timeTo;

//   ScheduleModel({
//     required this.date,
//     required this.timeFrom,
//     required this.timeTo,
//   });

//   @override
//   String toString() {
//     final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
//     return '${dateFormat.format(date)}: ${timeFrom.format(navigatorKey.currentContext!)} - ${timeTo.format(navigatorKey.currentContext!)}';
//   }
// }
