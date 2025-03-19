import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/helper/rating_start.dart';
import 'package:tracio_fe/common/widget/blog/header_information.dart';
import 'package:tracio_fe/common/widget/picture/circle_picture.dart';
import 'package:tracio_fe/core/configs/theme/assets/app_images.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/app_size.dart';

class ReviewServiceCard extends StatelessWidget {
  const ReviewServiceCard({super.key});

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            thickness: .5,
            indent: 16,
            endIndent: 16,
            color: isDark ? AppColors.darkGrey : Colors.grey.shade300,
            height: 1,
          ),
          HeaderInformation(
              title: Text(
                'An Xểm',
                style: TextStyle(
                  color: isDark ? Colors.grey.shade300 : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: AppSize.textLarge,
                ),
              ),
              subtitle: Text('2 day ago'),
              imageUrl: CirclePicture(
                  imageUrl: AppImages.man, imageSize: AppSize.iconMedium)),
          RatingStart.ratingStart(rating: 4.5),
          Text(
            'Service tốt jksfkjfskjhgsk skjfhsksf kjfhaskfh akfhaj hah h fafh asfh askfh alfha jalkf half hs',
            style: TextStyle(
                color:
                    context.isDarkMode ? Colors.grey.shade300 : Colors.black87,
                fontSize: AppSize.textMedium.sp,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: AppSize.imageMedium.h,
            width: AppSize.imageMedium.w,
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    AppImages.picture,
                    fit: BoxFit.cover,
                    errorBuilder: (context, url, error) => Icon(
                      Icons.error,
                      color: context.isDarkMode
                          ? AppColors.primary
                          : AppColors.background,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
