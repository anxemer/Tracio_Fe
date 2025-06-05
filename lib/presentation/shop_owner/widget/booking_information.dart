import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:Tracio/common/widget/input_text_form_field.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/presentation/shop_owner/bloc/resolve_booking/resolve_booking_cubit.dart';
import 'package:Tracio/presentation/shop_owner/bloc/resolve_booking/resolve_booking_state.dart';

import '../../../core/constants/app_size.dart';

class BookingInformation extends StatefulWidget {
  const BookingInformation(
      {super.key,
      this.start,
      this.duration,
      this.price,
      this.userNote,
      this.bookedDate,
      required this.status,
      this.shopNote,
      this.adjPrice});
  final DateTime? start;
  final String? duration;
  final String? price;
  final String? userNote;
  final DateTime? bookedDate;
  final String status;
  final String? shopNote;
  final String? adjPrice;
  @override
  State<BookingInformation> createState() => _BookingInformationState();
}

class _BookingInformationState extends State<BookingInformation> {
  final TextEditingController shopNoteCon = TextEditingController();
  final TextEditingController priceAdjust = TextEditingController();
  final TextEditingController reason = TextEditingController();
  final TextEditingController adjPriceCon = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: AppSize.apHorizontalPadding,
            vertical: AppSize.apVerticalPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: BlocBuilder<ResolveBookingShopCubit, ResolveBookingShopState>(
          builder: (context, state) {
            if (state is UpdateParamsWaitingBooking) {
              return buildBookingInformation(
                isEditable: ['Pending', 'Reschedule'].contains(widget.status),
                newPrice: state.price,
                start: state.bookedDate,
                duration: widget.duration,
                price: widget.price,
                note: state.shopNote,
                reason: state.reason,
                adjPriceReason: state.adjPrice,
                isUpdated: true,
              );
            } else {
              return buildBookingInformation(
                shopNote: widget.shopNote,
                isEditable: ['Pending', 'Reschedule'].contains(widget.status),
                start: widget.start,
                duration: widget.duration,
                price: widget.price,
                note: widget.userNote,
                adjPriceReason: widget.adjPrice,
                isUpdated: false,
              );
            }
          },
        ));
  }

  void showDialogConfirmation() async {
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(20),
          children: [
            Icon(Icons.price_change_outlined,
                size: AppSize.iconLarge, color: AppColors.secondBackground),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'price adjustment',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: AppSize.textLarge,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            InputTextFormField(
              hint: 'New Price',
              controller: priceAdjust,
              labelText: 'New Price',
              keyBoardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(
              height: 10.h,
            ),
            InputTextFormField(
              controller: adjPriceCon,
              labelText: 'reason',
              hint: 'Reason for price adjustment',
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      context
                          .read<ResolveBookingShopCubit>()
                          .updatePrice(priceAdjust.text, adjPriceCon.text);
                      Navigator.pop(context);
                    },
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
                    child: const Text('Change Price'),
                  ),
                ),
                SizedBox(
                  width: 10.w,
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
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget buildBookingInformation({
    required DateTime? start,
    required String? duration,
    required String? price,
    String? newPrice,
    String? shopNote,
    String? note,
    String? reason,
    String? adjPriceReason,
    required bool isUpdated,
    required bool isEditable, // ✅ Truyền status ở đây
  }) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    final DateFormat timeFormat = DateFormat('HH:mm');
    final String startDateString =
        start != null ? dateFormat.format(start) : 'Choose In User Free Time';
    final String startTimeString =
        start != null ? timeFormat.format(start) : '--:--';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Repair Start
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Repair Start:',
              style:
                  TextStyle(color: Colors.grey, fontSize: AppSize.textMedium),
            ),
            SizedBox(width: 10.w),
            Text(
              startDateString,
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: AppSize.textMedium),
            ),
            SizedBox(width: 10.w),
            Text(
              startTimeString,
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: AppSize.textMedium),
            ),
          ],
        ),
        SizedBox(height: 10.h),

        // Duration
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Duration:',
              style:
                  TextStyle(color: Colors.grey, fontSize: AppSize.textMedium),
            ),
            SizedBox(width: 10.w),
            Text(
              duration ?? '--',
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: AppSize.textMedium),
            ),
          ],
        ),
        SizedBox(height: 10.h),

        // Customer Note
        if (note != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Customer Note:',
                style:
                    TextStyle(color: Colors.grey, fontSize: AppSize.textMedium),
              ),
              SizedBox(width: 10.w),
              Text(
                note,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: AppSize.textMedium),
              ),
            ],
          ),
        SizedBox(height: 10.h),

        // ✅ Shop Note (Editable hoặc chỉ hiển thị)
        isEditable
            ? SizedBox(
                height: 80,
                child: InputTextFormField(
                  controller: shopNote != null
                      ? TextEditingController(text: shopNote)
                      : shopNoteCon,
                  labelText: 'Shop Note',
                  hint: 'Note for Customer',
                  onFieldSubmitted: (value) {
                    // handle logic update here
                  },
                ),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Shop Note:',
                    style: TextStyle(
                        color: Colors.grey, fontSize: AppSize.textMedium),
                  ),
                  SizedBox(width: 10.w),
                  Flexible(
                    child: Text(
                      shopNote ?? '--',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: AppSize.textMedium,
                      ),
                    ),
                  ),
                ],
              ),

        SizedBox(height: 10.h),

        // Price section
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: isEditable
                ? () {
                    showDialogConfirmation();
                  }
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isUpdated && newPrice != null && newPrice != price) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Initial Price:',
                          style: TextStyle(
                              fontSize: AppSize.textMedium,
                              color: Colors.grey)),
                      Text(
                        '$price \VNĐ',
                        style: const TextStyle(
                          fontSize: AppSize.textMedium,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('New Price:',
                          style: TextStyle(
                              fontSize: AppSize.textMedium,
                              color: Colors.grey)),
                      Text(
                        '$newPrice \VNĐ',
                        style: TextStyle(
                          fontSize: AppSize.textLarge,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Price:',
                          style: TextStyle(
                              fontSize: AppSize.textMedium,
                              color: Colors.grey)),
                      Text(
                        '$newPrice \VNĐ',
                        style: TextStyle(
                          fontSize: AppSize.textLarge,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Reason: $adjPriceReason',
                    style: TextStyle(
                      fontSize: AppSize.textLarge,
                      color: Colors.black87,
                    ),
                  ),
                ] else ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Price:',
                              style: TextStyle(
                                  fontSize: AppSize.textMedium,
                                  color: Colors.grey)),
                          Text(
                            '$price VNĐ',
                            style: TextStyle(
                              fontSize: AppSize.textLarge,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: 4),
                      // Text(
                      //   'Reason: $adjPriceReason',
                      //   style: TextStyle(
                      //     fontSize: AppSize.textLarge,
                      //     color: Colors.black87,
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
