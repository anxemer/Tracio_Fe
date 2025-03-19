import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/helper/rating_start.dart';
import 'package:tracio_fe/presentation/service/widget/review_service_card.dart';

import '../../../core/constants/app_size.dart';

class ReviewService extends StatelessWidget {
  const ReviewService({super.key});

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              title: Text(
                'Review (50)',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: AppSize.textLarge,
                ),
              ),
              subtitle: Row(
                children: [Text('4.7/5'), RatingStart.ratingStart(rating: 4.7)],
              ),
              trailing: SizedBox(
                width: 100.w,
                child: Row(
                  children: [
                    Text(
                      'View more',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: AppSize.textMedium,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: AppSize.iconSmall,
                      color: isDark ? Colors.white : Colors.black,
                    )
                  ],
                ),
              ),
            )),
        ListView.builder(
          itemCount: 3,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(),
              margin: EdgeInsets.only(top: index == 0 ? 12 : 16),
              // height: 120,
              child: ReviewServiceCard(),
            );
          },
        ),
      ],
    );
  }
}
