import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/common/helper/rating_start.dart';
import 'package:Tracio/common/widget/blog/header_information.dart';
import 'package:Tracio/common/widget/blog/picture_card.dart';
import 'package:Tracio/common/widget/picture/circle_picture.dart';
import 'package:Tracio/domain/shop/entities/response/review_service_entity.dart';

import '../../../core/constants/app_size.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReviewServiceCard extends StatelessWidget {
  const ReviewServiceCard({super.key, required this.review, this.moreWidget});
  final ReviewServiceEntity review;
  final Widget? moreWidget;

  @override
  Widget build(BuildContext context) {
    List<String> mediaUrls =
        review.mediaFiles.map((file) => file.mediaUrl ?? "").toList();
    var isDark = context.isDarkMode;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          thickness: .5,
          indent: 16,
          endIndent: 16,
          color: isDark ? Colors.black26 : Colors.grey.shade300,
          height: 1,
        ),
        HeaderInformation(
            title: Text(
              review.cyclistName!,
              style: TextStyle(
                color: isDark ? Colors.grey.shade300 : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: AppSize.textLarge,
              ),
            ),
            subtitle: Text(timeago.format(review.createdAt!)),
            imageUrl: CirclePicture(
                imageUrl: review.cyclistAvatar!,
                imageSize: AppSize.iconMedium)),
        RatingStart.ratingStart(rating: review.rating!),
        Text(
          review.content!,
          style: TextStyle(
              color: context.isDarkMode ? Colors.grey.shade300 : Colors.black87,
              fontSize: AppSize.textMedium.sp,
              fontWeight: FontWeight.w400),
        ),
        Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            width: MediaQuery.of(context).size.width * .6,
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: PictureCard(
                    imageWidth: AppSize.imageExtraLarge.w,
                    imageheight: AppSize.imageExtraLarge * .8.h,
                    listImageUrl: mediaUrls)
                //  Image.asset(
                //   AppImages.picture,
                //   fit: BoxFit.cover,
                //   errorBuilder: (context, url, error) => Icon(
                //     Icons.error,
                //     color: context.isDarkMode
                //         ? AppColors.primary
                //         : AppColors.background,
                //   ),
                // ),
                )),
        SizedBox(
          height: 4.h,
        ),
        review.reply == null
            ? SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSize.apHorizontalPadding * .2.h,
                        vertical: AppSize.apVerticalPadding * .2.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius:
                          BorderRadius.circular(AppSize.borderRadiusLarge),
                    ),
                    child: Row(
                      children: [
                        CirclePicture(
                            imageUrl: review.reply!.shopPictureProfile!,
                            imageSize: AppSize.iconSmall * .8.sp),
                        SizedBox(
                          width: 10.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          spacing: 2,
                          children: [
                            Text(
                              review.reply!.shopName!,
                              style: TextStyle(
                                  color:
                                      isDark ? Colors.white70 : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppSize.textMedium),
                            ),
                            Text(
                              review.reply!.content!,
                              style: TextStyle(
                                  color:
                                      isDark ? Colors.white70 : Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontSize: AppSize.textSmall),
                            ),
                          ],
                        )
                      ],
                    )
                    //   ListTile(
                    //     leading: CirclePicture(
                    //         imageUrl: review.reply!.shopPictureProfile!,
                    //         imageSize: AppSize.iconSmall * .8.sp),
                    //     title: Text(
                    //       review.reply!.shopName!,
                    //       style: TextStyle(
                    //           color: isDark ? Colors.white70 : Colors.black87,
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: AppSize.textMedium),
                    //     ),
                    //     subtitle: Text(
                    //       review.reply!.content!,
                    //       style: TextStyle(
                    //           color: isDark ? Colors.white70 : Colors.black87,
                    //           fontWeight: FontWeight.w600,
                    //           fontSize: AppSize.textSmall),
                    //     ),
                    //   ),
                    // ),
                    )),
        moreWidget ?? SizedBox.shrink()
      ],
    );
  }
}
