import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/helper/rating_start.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/common/widget/common_card.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';

import '../../../core/configs/theme/assets/app_images.dart';
import '../../../core/constants/app_size.dart';

class DetailServicePage extends StatefulWidget {
  const DetailServicePage({super.key});

  @override
  State<DetailServicePage> createState() => _DetailServicePageState();
}

class _DetailServicePageState extends State<DetailServicePage> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            
            buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  buildImage(),
                  buildTitle(context),
                  SizedBox(
                    height: 10.h,
                  ),
                  Divider(
                    indent: 16,
                    endIndent: 16,
                    color: Colors.grey.shade200,
                    height: 1,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  buildDescription(context),
                  SizedBox(
                    height: 10.h,
                  ),
                  Divider(
                    indent: 16,
                    endIndent: 16,
                    color: Colors.grey.shade200,
                    height: 1,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  buildMaterial(),
                  SizedBox(
                    height: 10.h,
                  ),
                  buildButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildHeader(BuildContext context) {
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
        // IconButton(
        //   onPressed: () {},
        //   style: ButtonStyle(
        //     shape: WidgetStatePropertyAll(
        //       RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(12),
        //         side: BorderSide(color: Color(0xffECECEC), width: 1),
        //       ),
        //     ),
        //     fixedSize: WidgetStatePropertyAll(Size(40, 40)),
        //   ),
        //   icon: ImageIcon(
        //     AssetImage('assets/icons/more.png'),
        //     size: 24,
        //     color: Color(0xff000000),
        //   ),
        // ),
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

Padding buildTitle(BuildContext context) {
  var isDark = context.isDarkMode;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Name Service',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
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
              color: isDark ? AppColors.secondBackground : AppColors.background,
            ),
            Text(
              '30 minutes',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: AppSize.textLarge,
              ),
            ),
            SizedBox(
              width: 10.h,
            ),
            Icon(
              Icons.attach_money_rounded,
              color: isDark ? AppColors.secondBackground : AppColors.background,
            ),
            Text(
              '200.000 VND',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: AppSize.textLarge,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          children: [
            Icon(
              Icons.location_on_sharp,
              color: isDark ? AppColors.secondBackground : AppColors.background,
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

Padding buildDescription(BuildContext context) {
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
              color: isDark ? Colors.white : Colors.black),
        ),
        Text(
          'In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: AppSize.textLarge,
              color: isDark ? Colors.white : Colors.black),
        ),
      ],
    ),
  );
}

Padding buildMaterial() {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Material',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          'Structured to capture and store various attributes',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black45,
          ),
        ),
      ],
    ),
  );
}

Padding buildButton() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      width: double.infinity,
      height: 50,
      color: Colors.black12,
    ),
  );
}
