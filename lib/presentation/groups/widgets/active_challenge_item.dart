import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/widget/picture/circle_picture.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';

class ActiveChallengeItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double progression;

  // Constructor to accept arguments
  const ActiveChallengeItem({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.progression,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 40.w,
          height: 48.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progression,
                strokeWidth: 14.sp,
                strokeCap: StrokeCap.round,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              ClipOval(
                child: CirclePicture(
                    imageUrl: imageUrl, imageSize: AppSize.iconMedium.sp),
                // Image.network(
                //   imageUrl,
                //   width: 30,
                //   height: 30,
                //   fit: BoxFit.cover,
                // ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        // Title below the image
        Text(
          title, // Dynamic title
          style: TextStyle(
              fontSize: AppSize.textMedium * 0.8.sp,
              fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
