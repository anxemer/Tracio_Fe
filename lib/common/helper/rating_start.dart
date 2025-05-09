import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';

class RatingStart {
  static Widget ratingStart({double rating = 4.5}) {
    return RatingBarIndicator(
      rating: rating,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: context.isDarkMode
            ? AppColors.secondBackground
            : AppColors.background,
      ),
      itemCount: 5,
      unratedColor: AppColors.darkGrey,
      itemSize: AppSize.iconSmall,
      direction: Axis.horizontal,
    );
  }
}
