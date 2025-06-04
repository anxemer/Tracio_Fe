import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogConfirmBooking {
  void showDialogConfirmation(BuildContext context, VoidCallback yes) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(20),
          children: [
            const Icon(Icons.info_outline_rounded,
                size: 50, color: Colors.black38),
            SizedBox(
              height: 10.h,
            ),
            const Text(
              'Would you like to reschedule this service?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: yes
                    // Navigator.pop(context);
                    ,
                    style: ButtonStyle(
                      backgroundColor: const WidgetStatePropertyAll(Colors.red),
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.white),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    child: const Text('Yes'),
                  ),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.black54),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    child: const Text('No'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Widget scheduleList(BuildContext context) {
  //   var bookingCubit = context.read<BookingServiceCubit>();
  //   return Container(
  //     color: Colors.white,
  //     width: double.infinity,
  //     constraints:
  //         BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Padding(
  //           padding: EdgeInsets.all(4),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 'Your Schedules',
  //                 style: TextStyle(
  //                   fontSize: AppSize.textLarge,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               IconButton(
  //                 icon: Icon(Icons.close),
  //                 onPressed: () => Navigator.pop(context),
  //               ),
  //             ],
  //           ),
  //         ),

  //         Divider(height: 1),

  //         Expanded(
  //           child: ListView.builder(
  //             itemCount: bookingCubit.schedules!.length,
  //             // padding: EdgeInsets.symmetric(vertical: 8),
  //             itemBuilder: (context, index) {
  //               final schedule = bookingCubit.schedules![index];
  //               final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  //               return ListTile(
  //                 title: Text(
  //                   dateFormat.format(schedule.date!),
  //                   style: TextStyle(fontWeight: FontWeight.w500),
  //                 ),
  //                 subtitle: Text(
  //                   '${schedule.timeFrom!.format(context)} - ${schedule.timeTo!.format(context)}',
  //                 ),
  //                 trailing: IconButton(
  //                   icon: Icon(Icons.delete_outline, color: Colors.red),
  //                   onPressed: () {
  //                     bookingCubit.schedules!.removeAt(index);

  //                     // if (widget.onSchedulesChanged != null) {
  //                     //   widget.onSchedulesChanged!(_schedules);
  //                     // }
  //                     // // Nếu xóa hết lịch thì đóng dialog
  //                     if (bookingCubit.schedules!.isEmpty) {
  //                       Navigator.pop(context);
  //                     }
  //                   }

  //                   // widget.deleteSchedule

  //                   ,
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //         // Center(

  //         Padding(
  //           padding: EdgeInsets.all(8),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               OutlinedButton(
  //                 onPressed: () {
  //                   // widget.clearAll;

  //                   bookingCubit.schedules!.clear();

  //                   // if (widget.onSchedulesChanged != null) {
  //                   //   widget.onSchedulesChanged!(_schedules);
  //                   // }
  //                   Navigator.pop(context);
  //                 },
  //                 child: Text('Clear All'),
  //                 style: OutlinedButton.styleFrom(
  //                   foregroundColor: context.isDarkMode
  //                       ? AppColors.primary
  //                       : AppColors.secondBackground,
  //                 ),
  //               ),
  //               ElevatedButton(
  //                 onPressed: () {
  //                   List<int> rescheduleBooking = bookingCubit.reschedule;
  //                   // widget.confirm;
  //                   List<UserScheduleCreateDto> scheduleDtos =
  //                       bookingCubit.schedules!.map((schedule) {
  //                     return UserScheduleCreateDto(
  //                         date: schedule.date,
  //                         timeFrom: _formatTime(schedule.timeFrom!),
  //                         timeTo: _formatTime(schedule.timeTo!));
  //                   }).toList();

  //                   // If you have cart items, use bookingCartCreateDtos
  //                   if (bookingCubit.selectedServices.isNotEmpty) {
  //                     List<BookingCartCreateDto> bookingCartDtos =
  //                         bookingCubit.selectedServices.map((item) {
  //                       return BookingCartCreateDto(
  //                           bookingQueueId: item.itemId,
  //                           note: bookingCubit
  //                                   .serviceNotes[item.itemId.toString()] ??
  //                               "");
  //                     }).toList();

  //                     context.read<BookingServiceCubit>().bookingServie(
  //                         BookingServiceReq(
  //                             bookingCreateDto: null,
  //                             bookingCartCreateDtos: bookingCartDtos,
  //                             userScheduleCreateDtos: scheduleDtos));
  //                   }
  //                   // else if (service != null) {
  //                   //   BookingCreateDto bookingCreateDto = BookingCreateDto(
  //                   //       serviceId: widget.service!.serviceId,
  //                   //       note: bookingCubit.serviceNotes[
  //                   //           widget.service!.serviceId.toString()]);
  //                   //   context.read<BookingServiceCubit>().bookingServie(
  //                   //       BookingServiceReq(
  //                   //           bookingCreateDto: bookingCreateDto,
  //                   //           bookingCartCreateDtos: null,
  //                   //           userScheduleCreateDtos: scheduleDtos));
  //                   // }
  //                   else if (rescheduleBooking.isNotEmpty) {
  //                     context.read<RescheduleBookingCubit>().rescheduleBooking(
  //                         RescheduleBookingModel(
  //                             bookingIds: rescheduleBooking,
  //                             userScheduleCreateDtos: scheduleDtos));
  //                   }
  //                   Navigator.pop(context);
  //                 },
  //                 child: Text(
  //                   'Confirm',
  //                   style: TextStyle(
  //                       fontSize: AppSize.textMedium,
  //                       color: context.isDarkMode
  //                           ? Colors.grey.shade300
  //                           : Colors.black87),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}// Kiểm tra timeFrom < timeTo
  