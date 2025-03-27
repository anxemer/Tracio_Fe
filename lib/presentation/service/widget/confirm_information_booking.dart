// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:tracio_fe/common/helper/is_dark_mode.dart';
// import 'package:tracio_fe/domain/shop/entities/booking_card_view.dart';
// import 'package:tracio_fe/presentation/service/widget/add_schedule.dart';

// import '../../../common/helper/schedule_model.dart';
// import '../../../core/configs/theme/app_colors.dart';
// import '../../../core/configs/theme/assets/app_images.dart';
// import '../../../core/constants/app_size.dart';
// import 'show_schedule_bottom.dart';

// class ConfirmInformationBooking extends StatefulWidget {
//   ConfirmInformationBooking(
//       {super.key,
     
//       required this.schedules,
//       required this.cartItem, required this.confirm,
//      });
//   // final VoidCallback clearAll;
//   final VoidCallback confirm;
//   // final VoidCallback deleteSchedule;
//   List<ScheduleModel> schedules = [];
//   final List<BookingCardViewModel> cartItem;

//   @override
//   State<ConfirmInformationBooking> createState() =>
//       _ConfirmInformationBookingState();
// }

// class _ConfirmInformationBookingState extends State<ConfirmInformationBooking> {
//   @override
//   Widget build(BuildContext context) {
//     var isDark = context.isDarkMode;
//     return InkWell(
//         onTap: () {
//           showScheduleList(context, isDark);
//         },
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             vertical: 8,
//             horizontal: 8,
//           ),
//           child: Row(
//             children: [
//               Icon(Icons.event_note,
//                   color: Colors.blue, size: AppSize.iconSmall),
//               SizedBox(width: 4.w),
//               Text(
//                 '${widget.schedules.length} schedules selected',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w500,
//                   color: Colors.blue,
//                 ),
//               ),
//               Spacer(),
//               Icon(Icons.arrow_forward_ios,
//                   size: AppSize.iconSmall, color: Colors.blue),
//             ],
//           ),
//         ));
//   }

//   void showScheduleList(BuildContext context, bool isDark) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppSize.borderRadiusLarge)),
//         child: Container(
//           width: double.infinity,
//           constraints: BoxConstraints(
//               maxHeight: MediaQuery.of(context).size.height * 0.7),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Phần tiêu đề Services
//               Padding(
//                 padding: EdgeInsets.all(8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Your Services',
//                       style: TextStyle(
//                         fontSize: AppSize.textLarge,
//                         fontWeight: FontWeight.bold,
//                         color: context.isDarkMode
//                             ? Colors.grey.shade300
//                             : Colors.black87,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Danh sách services - có chiều cao cố định
//               SizedBox(
//                 height:
//                     AppSize.cardHeight.h, // Chiều cao cố định cho phần services
//                 child: ListView.builder(
//                   itemCount: widget.cartItem.length,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       padding: EdgeInsets.all(4),
//                       margin: EdgeInsets.all(4),
//                       // height: 80,
//                       decoration: BoxDecoration(
//                           color: Colors.black12,
//                           borderRadius: BorderRadius.circular(
//                               AppSize.borderRadiusMedium)),
//                       child: Row(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.asset(
//                               AppImages.picture,
//                               width: AppSize.imageSmall.w,
//                               height: AppSize.imageSmall.h * .8,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           SizedBox(
//                             width: 4.w,
//                           ),
//                           Expanded(
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       widget.cartItem[index].nameService!,
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: AppSize.textMedium.sp,
//                                         color: isDark
//                                             ? Colors.grey.shade300
//                                             : Colors.black87,
//                                       ),
//                                     ),
//                                     Row(
//                                       children: [
//                                         Icon(
//                                           Icons.attach_money_outlined,
//                                           size: AppSize.iconSmall,
//                                           color: isDark
//                                               ? AppColors.secondBackground
//                                               : AppColors.background,
//                                         ),
//                                         Text(
//                                           widget.cartItem[index].price
//                                               .toString(),
//                                           style: TextStyle(
//                                               fontSize: AppSize.textSmall,
//                                               color: isDark
//                                                   ? Colors.grey.shade300
//                                                   : Colors.black87),
//                                         )
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),

//               // Phần tiêu đề Schedules
//               Padding(
//                 padding: EdgeInsets.all(4),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Your Schedules',
//                       style: TextStyle(
//                         fontSize: AppSize.textLarge,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.close),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//               ),

//               Divider(height: 1),

//               // Danh sách lịch trình - chiếm phần không gian còn lại
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: widget.schedules.length,
//                   // padding: EdgeInsets.symmetric(vertical: 8),
//                   itemBuilder: (context, index) {
//                     final schedule = widget.schedules[index];
//                     final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

//                     return ListTile(
//                       title: Text(
//                         dateFormat.format(schedule.date),
//                         style: TextStyle(fontWeight: FontWeight.w500),
//                       ),
//                       subtitle: Text(
//                         '${schedule.timeFrom.format(context)} - ${schedule.timeTo.format(context)}',
//                       ),
//                       trailing: IconButton(
//                         icon: Icon(Icons.delete_outline, color: Colors.red),
//                         onPressed: () {
//                           setState(() {
//                             widget.schedules.removeAt(index);
//                           });
//                           // if (widget.onSchedulesChanged != null) {
//                           //   widget.onSchedulesChanged!(_schedules);
//                           // }
//                           // // Nếu xóa hết lịch thì đóng dialog
//                           if (widget.schedules.isEmpty) {
//                             Navigator.pop(context);
//                           }
//                         }

//                         // widget.deleteSchedule

//                         ,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               // Center(
//               //     child: BasicTextButton(
//               //   text: 'Add more schedule',
//               //   onPress: () {
//               //     Navigator.pop(context);
//               //     _showScheduleBottomSheet(context);
//               //     if (widget.onSchedulesChanged != null) {
//               //       widget.onSchedulesChanged!(_schedules);
//               //     }
//               //     if (_schedules.isNotEmpty) {
//               //       _showScheduleListDialog(context);
//               //     }
//               //   },
//               //   borderColor: Colors.white,
//               // )),
//               // Phần nút bấm
//               Padding(
//                 padding: EdgeInsets.all(8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     OutlinedButton(
//                       onPressed: () {
//                         // widget.clearAll;
//                         setState(() {
//                           widget.schedules.clear();
//                         });
//                         // if (widget.onSchedulesChanged != null) {
//                         //   widget.onSchedulesChanged!(_schedules);
//                         // }
//                         Navigator.pop(context);
//                       },
//                       child: Text('Clear All'),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: context.isDarkMode
//                             ? AppColors.primary
//                             : AppColors.secondBackground,
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         widget.confirm;
//                         // List<UserScheduleCreateDto> scheduleDtos =
//                         //     _schedules.map((schedule) {
//                         //   return UserScheduleCreateDto(
//                         //       date: schedule.date,
//                         //       timeFrom: _formatTime(schedule.timeFrom),
//                         //       timeTo: _formatTime(schedule.timeTo));
//                         // }).toList();

//                         // // If you have cart items, use bookingCartCreateDtos
//                         // if (widget.cartItem.isNotEmpty) {
//                         //   List<BookingCartCreateDto> bookingCartDtos =
//                         //       widget.cartItem.map((item) {
//                         //     return BookingCartCreateDto(
//                         //         bookingQueueId: item.bookingQueueId, note: "");
//                         //   }).toList();

//                         //   context.read<BookingServiceCubit>().bookingServie(
//                         //       BookingServiceReq(
//                         //           bookingCreateDto: null,
//                         //           bookingCartCreateDtos: bookingCartDtos,
//                         //           userScheduleCreateDtos: scheduleDtos));
//                         // }
//                       },
//                       child: Text(
//                         'Confirm',
//                         style: TextStyle(
//                             fontSize: AppSize.textMedium,
//                             color: context.isDarkMode
//                                 ? Colors.grey.shade300
//                                 : Colors.black87),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
