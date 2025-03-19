import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/helper/rating_start.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/common/widget/button/text_button.dart';
import 'package:tracio_fe/common/widget/picture/circle_picture.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/presentation/service/widget/review_service.dart';

import '../../../common/widget/button/button.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import '../../../core/constants/app_size.dart';
import '../../../domain/shop/shop_service_entity.dart';

class DetailServicePage extends StatefulWidget {
  const DetailServicePage({super.key, required this.service});
  final ShopServiceEntity service;

  @override
  State<DetailServicePage> createState() => _DetailServicePageState();
}

class _DetailServicePageState extends State<DetailServicePage> {
  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          'Detail',
          style: TextStyle(
              color: context.isDarkMode ? Colors.grey.shade200 : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: AppSize.textHeading.sp),
        ),
        // height: 100.h,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // buildHeader(),
            Expanded(
              child: Stack(
                children: [
                  // Main scrollable content
                  ListView(
                    padding: const EdgeInsets.only(
                        bottom:
                            70), // Add padding to prevent content from being hidden behind the button
                    children: [
                      buildImage(),
                      SizedBox(
                        height: 10.h,
                      ),
                      buildTitle(),
                      SizedBox(
                        height: 10.h,
                      ),
                      Divider(
                        thickness: 4,
                        indent: 16,
                        endIndent: 16,
                        color:
                            isDark ? AppColors.darkGrey : Colors.grey.shade300,
                        height: 1,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      shopInformation(),
                      SizedBox(
                        height: 10.h,
                      ),
                      Divider(
                        thickness: 4,
                        indent: 16,
                        endIndent: 16,
                        color:
                            isDark ? AppColors.darkGrey : Colors.grey.shade300,
                        height: 1,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      buildDescription(),
                      SizedBox(
                        height: 20.h,
                      ),
                      Divider(
                        thickness: 4,
                        indent: 16,
                        endIndent: 16,
                        color:
                            isDark ? AppColors.darkGrey : Colors.grey.shade300,
                        height: 1,
                      ),
                      ReviewService()
                    ],
                  ),

                  // Fixed button at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: context.isDarkMode
                            ? AppColors.darkGrey
                            : Colors.grey.shade200,
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black,
                        //     blurRadius: 5,
                        //     offset: const Offset(0, -3),
                        //   ),
                        // ],
                      ),
                      child: buildButton(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    var isDark = context.isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                        color: context.isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade700,
                        width: 1),
                  ),
                ),
                fixedSize: WidgetStatePropertyAll(Size(40, 40)),
              ),
              icon: Icon(Icons.arrow_back_ios_new_outlined)),
          SizedBox(
            width: 20.h,
          ),
          Text(
            'Detail',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: AppSize.textExtraLarge,
              color: context.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          IconButton(
              onPressed: () {},
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Color(0xffECECEC), width: 1),
                  ),
                ),
                fixedSize: WidgetStatePropertyAll(Size(40, 40)),
              ),
              icon: Icon(Icons.playlist_add_check_outlined)),
        ],
      ),
    );
  }

  Widget buildImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
            aspectRatio: 1.4,
            child: Image.asset(
              AppImages.picture,
              fit: BoxFit.cover,
            )),
      ),
    );
  }

  Padding buildTitle() {
    var isDark = context.isDarkMode;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.service.serviceName,
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade300 : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: AppSize.textHeading,
                  ),
                ),
              ),
              RatingStart.ratingStart(rating: 5)
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              Icon(
                Icons.access_time_sharp,
                color:
                    isDark ? AppColors.secondBackground : AppColors.background,
              ),
              Text(
                widget.service.formattedDuration,
                style: TextStyle(
                  color: isDark ? Colors.grey.shade300 : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: AppSize.textLarge,
                ),
              ),
              SizedBox(
                width: 10.h,
              ),
              Icon(
                Icons.attach_money_rounded,
                color:
                    isDark ? AppColors.secondBackground : AppColors.background,
              ),
              Text(
                widget.service.formattedPrice,
                style: TextStyle(
                  color: isDark ? Colors.grey.shade300 : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: AppSize.textLarge,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on_sharp,
                    color: isDark
                        ? AppColors.secondBackground
                        : AppColors.background,
                  ),
                  Text(
                    '2 km',
                    style: TextStyle(
                      color: isDark ? Colors.grey.shade300 : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: AppSize.textLarge,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Padding buildDescription() {
    var isDark = context.isDarkMode;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppSize.textHeading,
                color: isDark ? Colors.grey.shade300 : Colors.black87),
          ),
          Text(
            'In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: AppSize.textMedium,
                color: isDark ? Colors.grey.shade300 : Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget shopInformation() {
    var isDark = context.isDarkMode;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CirclePicture(
                  imageUrl:
                      'https://bizweb.dktcdn.net/100/481/209/products/img-5958-jpeg.jpg?v=1717069788060',
                  imageSize: AppSize.iconLarge),
              SizedBox(
                width: 10.w,
              ),
              Column(
                children: [
                  Text(
                    'An Xểm',
                    style: TextStyle(
                      color: isDark ? Colors.grey.shade300 : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: AppSize.textLarge,
                    ),
                  ),
                  Container(
                    height: 28,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: AppColors.secondBackground),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          color: isDark
                              ? AppColors.secondBackground
                              : AppColors.background,
                          size: AppSize.iconSmall,
                        ),
                        Text(
                          '7h - 22h',
                          style: TextStyle(
                            color:
                                isDark ? Colors.grey.shade300 : Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: AppSize.textSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              BasicTextButton(
                fontSize: AppSize.textSmall,
                onPress: () {},
                text: 'View Shop',
                borderColor:
                    isDark ? AppColors.secondBackground : AppColors.background,
              )
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              Icon(
                Icons.location_on_sharp,
                color:
                    isDark ? AppColors.secondBackground : AppColors.background,
              ),
              Text(
                'Gò vấp, Hồ Chí Minh',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: AppSize.textLarge,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ButtonDesign(
          height: 40.h,
          width: 140.w,
          ontap: () {},
          text: 'Add To Plan',
          // image: AppImages.draft,
          fillColor: Colors.transparent,
          textColor: context.isDarkMode ? Colors.grey.shade200 : Colors.black87,
          borderColor:
              context.isDarkMode ? Colors.grey.shade200 : Colors.black87,
          fontSize: AppSize.textMedium,
        ),
        ButtonDesign(
          height: 40.h,
          width: 140.w,
          ontap: () {},
          text: 'Booking',
          // image: AppImages.share,
          fillColor: AppColors.secondBackground,
          textColor: context.isDarkMode ? Colors.grey.shade200 : Colors.black87,
          borderColor:
              context.isDarkMode ? Colors.grey.shade200 : Colors.black87,
          fontSize: AppSize.textMedium,
        )
      ],
    );
  }
}
