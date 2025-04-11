import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/data/shop/models/reschedule_booking_model.dart';
import 'package:tracio_fe/domain/shop/entities/response/booking_card_view.dart';
import 'package:tracio_fe/presentation/service/bloc/bookingservice/booking_service_cubit.dart';
import 'package:tracio_fe/presentation/service/bloc/bookingservice/reschedule_booking/cubit/reschedule_booking_cubit.dart';
import 'package:tracio_fe/presentation/service/widget/show_schedule_bottom.dart';

import '../../../common/widget/button/text_button.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import '../../../core/constants/app_size.dart';
import '../../../data/shop/models/booking_service_req.dart';
import '../../../domain/shop/entities/response/shop_service_entity.dart';

class ConfirmInformationBooking extends StatefulWidget {
  const ConfirmInformationBooking({
    super.key,
    this.service,
    this.booking,
  });
  // final VoidCallback clearAll;
  final ShopServiceEntity? service;
  final List<BookingCardViewModel>? booking;
  // final VoidCallback deleteSchedule;

  @override
  State<ConfirmInformationBooking> createState() =>
      _ConfirmInformationBookingState();
}

class _ConfirmInformationBookingState extends State<ConfirmInformationBooking> {
  @override
  Widget build(BuildContext context) {
    var bookingCubit = context.read<BookingServiceCubit>();

    var isDark = context.isDarkMode;
    return InkWell(
        onTap: () {
          showScheduleList(context, isDark, bookingCubit);
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
        ));
  }

  void showScheduleList(
      BuildContext context, bool isDark, BookingServiceCubit bookingCubit) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.borderRadiusLarge)),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Padding(
              //   padding: EdgeInsets.all(8),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         'Your Services',
              //         style: TextStyle(
              //           fontSize: AppSize.textLarge,
              //           fontWeight: FontWeight.bold,
              //           color: context.isDarkMode
              //               ? Colors.grey.shade300
              //               : Colors.black87,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // SizedBox(
              //   height: AppSize.cardHeight.h,
              //   child: ListView.builder(
              //     itemCount: bookingCubit.selectedServices.length,
              //     itemBuilder: (context, index) {
              //       return Container(
              //         padding: EdgeInsets.all(4),
              //         margin: EdgeInsets.all(4),
              //         // height: 80,
              //         decoration: BoxDecoration(
              //             color: Colors.black12,
              //             borderRadius: BorderRadius.circular(
              //                 AppSize.borderRadiusMedium)),
              //         child: Row(
              //           children: [
              //             ClipRRect(
              //               borderRadius: BorderRadius.circular(8),
              //               child: Image.asset(
              //                 AppImages.picture,
              //                 width: AppSize.imageSmall.w,
              //                 height: AppSize.imageSmall.h * .8,
              //                 fit: BoxFit.cover,
              //               ),
              //             ),
              //             SizedBox(
              //               width: 4.w,
              //             ),
              //             Expanded(
              //               child: Column(
              //                 children: [
              //                   Row(
              //                     mainAxisAlignment:
              //                         MainAxisAlignment.spaceBetween,
              //                     children: [
              //                       Text(
              //                         bookingCubit
              //                             .selectedServices[index].serviceName!,
              //                         style: TextStyle(
              //                           fontWeight: FontWeight.bold,
              //                           fontSize: AppSize.textMedium.sp,
              //                           color: isDark
              //                               ? Colors.grey.shade300
              //                               : Colors.black87,
              //                         ),
              //                       ),
              //                       Row(
              //                         children: [
              //                           Icon(
              //                             Icons.attach_money_outlined,
              //                             size: AppSize.iconSmall,
              //                             color: isDark
              //                                 ? AppColors.secondBackground
              //                                 : AppColors.background,
              //                           ),
              //                           Text(
              //                             bookingCubit
              //                                 .selectedServices[index].price
              //                                 .toString(),
              //                             style: TextStyle(
              //                                 fontSize: AppSize.textSmall,
              //                                 color: isDark
              //                                     ? Colors.grey.shade300
              //                                     : Colors.black87),
              //                           )
              //                         ],
              //                       )
              //                     ],
              //                   ),
              //                 ],
              //               ),
              //             )
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // ),

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
                child: ListView.builder(
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
                          setState(() {
                            bookingCubit.schedules!.removeAt(index);
                          });
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
                ),
              ),
              // Center(
              //     child: BasicTextButton(
              //   text: 'Add more schedule',
              //   onPress: () {
              //     // Navigator.pop(context);
              //     ShowScheduleBottom();
              //     // if (widget.onSchedulesChanged != null) {
              //     //   widget.onSchedulesChanged!(_schedules);
              //     // }
              //     // if (_schedules.isNotEmpty) {
              //     //   _showScheduleListDialog(context);
              //     // }
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
                        // widget.clearAll;
                        setState(() {
                          bookingCubit.schedules!.clear();
                        });
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
                        } else if (widget.service != null) {
                          BookingCreateDto bookingCreateDto = BookingCreateDto(
                              serviceId: widget.service!.serviceId,
                              note: bookingCubit.serviceNotes[
                                  widget.service!.serviceId.toString()]);
                          context.read<BookingServiceCubit>().bookingServie(
                              BookingServiceReq(
                                  bookingCreateDto: bookingCreateDto,
                                  bookingCartCreateDtos: null,
                                  userScheduleCreateDtos: scheduleDtos));
                        } else if (rescheduleBooking.isNotEmpty) {
                          context
                              .read<RescheduleBookingCubit>()
                              .rescheduleBooking(RescheduleBookingModel(
                                  bookingIds: rescheduleBooking,
                                  userScheduleCreateDtos: scheduleDtos));
                        }
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
        ),
      ),
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
