import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';

class SnapshotReviewSection extends StatelessWidget {
  final Widget metricsSection;
  final VoidCallback onEdit;

  const SnapshotReviewSection({
    super.key,
    required this.metricsSection,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        metricsSection,
        const SizedBox(height: 10),
        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                          color: AppColors.secondBackground, width: 1),
                    ),
                  ),
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context, 'canceled');
                    }
                  },
                  child: Text("Navigate",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: AppSize.textMedium.sp)),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.secondBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onEdit,
                  child: Text("Save",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: AppSize.textMedium.sp)),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
