import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';

class FeatureSection extends StatelessWidget {
  final Image banner;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;
  const FeatureSection({
    super.key,
    required this.banner,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppSize.apHorizontalPadding, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          banner,
          SizedBox(height: AppSize.apVerticalPadding * 0.5.h),
          Text(title,
              style: TextStyle(
                  fontSize: AppSize.textLarge.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: AppSize.apVerticalPadding * 0.5.h),
          Text(description, style: TextStyle(fontSize: AppSize.textMedium.sp)),
          SizedBox(height: AppSize.apVerticalPadding * 0.5.h),
          buildActionButton(buttonText, onPressed),
          SizedBox(height: AppSize.apSectionPadding.h),
        ],
      ),
    );
  }

  Widget buildActionButton(String text, VoidCallback onPressed) {
    return Center(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: AppColors.secondBackground),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding:
                EdgeInsets.symmetric(vertical: AppSize.apVerticalPadding * 0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onPressed,
          child:
              Text(text, style: TextStyle(color: Colors.black87, fontSize: 16)),
        ),
      ),
    );
  }
}
