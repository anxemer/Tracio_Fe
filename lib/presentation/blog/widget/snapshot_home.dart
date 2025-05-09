import 'package:Tracio/domain/user/entities/daily_activity_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/core/constants/app_size.dart'; // For number formatting (optional but good)

class WeeklySnapshotCard extends StatelessWidget {
  final DailyActivityEntity activity; // in meters, for example

  const WeeklySnapshotCard({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    // Define text styles for consistency (optional, can use Theme.of(context))
    final valueStyle = TextStyle(
      fontSize: AppSize.textLarge.sp,
      fontWeight: FontWeight.bold,
      color: isDark ? Colors.white70 : Colors.black87,
    );
    final labelStyle = TextStyle(
      fontSize: AppSize.textMedium.sp,
      color: isDark ? Colors.white70 : Colors.black87,
    );

    return Card(
      margin: const EdgeInsets.all(12.0),
      // elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Title ---
            Text(
              'Your Daily Snapshot',
              style: TextStyle(
                fontSize: AppSize.textLarge.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            SizedBox(height: 8.h), // Spacer

            // --- Stats Row ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // spacing: 20.w,
              // Distribute space
              children: [
                // --- Distance ---
                statItem(
                  'Distance',
                  ' ${activity.formatDistanceFlexible()}', // Format distance
                  'Km', // Use the provided unit
                  valueStyle,
                  labelStyle,
                ),

                // --- Duration ---
                statItem(
                  'Time',
                  activity.formatDuration(), // Format distance
                  'Hour', // Use the provided unit
                  valueStyle,
                  labelStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget statItem(String title, String value, String label,
      TextStyle valueStyle, TextStyle labelStyle) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Take minimum space
      crossAxisAlignment: CrossAxisAlignment.center, // Center items
      children: [
        Text(title, style: labelStyle),
        SizedBox(height: 4.h), // Small space between value and label

        Row(
          spacing: 8.w,
          children: [
            Text(value, style: valueStyle),
            // Text(label, style: valueStyle),
          ],
        ),
        // SizedBox(height: 4.h), // Small space between value and label
        // Text(label, style: labelStyle),
      ],
    );
  }
}
