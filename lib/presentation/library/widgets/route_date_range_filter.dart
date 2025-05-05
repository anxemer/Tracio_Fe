import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tracio_fe/common/widget/drag_handle/drag_handle.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/data/map/models/request/get_route_req.dart';
import 'package:tracio_fe/presentation/library/bloc/route_filter_cubit.dart';
import 'package:tracio_fe/presentation/library/bloc/route_filter_state.dart';
import 'package:tracio_fe/presentation/map/bloc/route_cubit.dart';

class RouteDateRangeFilter extends StatefulWidget {
  const RouteDateRangeFilter({super.key});

  @override
  State<RouteDateRangeFilter> createState() => _RouteDateRangeFilterState();
}

class _RouteDateRangeFilterState extends State<RouteDateRangeFilter> {
  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    final state = context.read<RouteFilterCubit>().state;

    fromDate = state.fromDate;
    toDate = state.toDate;
  }

  /// **Date Formatting Helper**
  String formatDate(DateTime date) {
    return DateFormat("MMM d, yyyy").format(date);
  }

  /// **Validation & Display Helper**
  String getDateRangeText() {
    if (fromDate != null && toDate != null) {
      if (fromDate == toDate) {
        return formatDate(fromDate!);
      }
      return "${formatDate(fromDate!)} - ${formatDate(toDate!)}";
    } else if (fromDate != null) {
      return "After ${formatDate(fromDate!)}";
    } else if (toDate != null) {
      return "Before ${formatDate(toDate!)}";
    } else {
      return "Any date";
    }
  }

  /// **Handles Date Selection**
  Future<void> _pickDate(BuildContext context, bool isFrom) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
          isFrom ? fromDate ?? DateTime.now() : toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.orange,
            hintColor: Colors.orange,
            colorScheme: ColorScheme.light(primary: Colors.orange),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isFrom) {
          fromDate = pickedDate;
          if (toDate != null && fromDate!.isAfter(toDate!)) {
            toDate = fromDate;
          }
        } else {
          toDate = pickedDate;
          if (fromDate != null && toDate!.isBefore(fromDate!)) {
            fromDate = toDate;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RouteFilterCubit, RouteFilterState>(
        builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSize.apHorizontalPadding,
            AppSize.apVerticalPadding / 2,
            AppSize.apHorizontalPadding,
            AppSize.apVerticalPadding * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// **Drag Handle**
            DragHandle(height: 6, color: Colors.grey.shade400),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      fromDate = null;
                      toDate = null;
                    });
                  },
                  child: const Text("Reset",
                      style: TextStyle(color: AppColors.primary)),
                ),
                Text("Date",
                    style: const TextStyle(
                      fontSize: AppSize.textMedium,
                      fontWeight: FontWeight.w500,
                    )),
                TextButton(
                  onPressed: () {
                    context
                        .read<RouteFilterCubit>()
                        .setDateRange(fromDate, toDate, getDateRangeText());
                    GetRouteReq request = GetRouteReq(
                        pageNumber: 1,
                        pageSize: 10,
                        isPlanned: state.isPlanned.toString());
                    context.read<RouteCubit>().getRoutes(request);
                    Navigator.pop(context);
                  },
                  child:
                      const Text("Save", style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),

            /// **Date Display**
            Text(getDateRangeText()),

            /// **From Date Picker**
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Colors.grey.shade300)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("From", style: TextStyle(color: Colors.black54)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _pickDate(context, true),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        fromDate != null
                            ? formatDate(fromDate!)
                            : "Select Date",
                        style: TextStyle(
                            color: fromDate != null
                                ? Colors.black
                                : Colors.black54),
                      ),
                    ),
                  )
                ],
              ),
            ),

            /// **To Date Picker**
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Colors.grey.shade300)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("To", style: TextStyle(color: Colors.black54)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _pickDate(context, false),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        toDate != null ? formatDate(toDate!) : "Select Date",
                        style: TextStyle(
                            color:
                                toDate != null ? Colors.black : Colors.black54),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
