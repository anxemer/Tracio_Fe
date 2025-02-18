import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/configs/theme/assets/app_images.dart';

class HeaderInformation extends StatelessWidget {
  const HeaderInformation(
      {super.key,
      required this.title,
      required this.imageUrl,
      this.subtitle,
      required this.trailling,
      this.widthImage});
  final Text title;
  final Widget imageUrl;
  final Text? subtitle;
  final Widget trailling;
  final double? widthImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 750.w,
        height: 100.h,
        child: Center(
          child: ListTile(
            leading: ClipOval(
              child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(60.sp)),
                  width: widthImage ?? 80.w,
                  // height: 100.h,
                  child: imageUrl),
            ),
            title: title,
            subtitle: subtitle ?? Text(''),
            // Text(
            //   subtitle ?? '',
            //   style: TextStyle(
            //       color: Colors.black,
            //       fontWeight: FontWeight.w400,
            //       fontSize: 20.sp),
            // ),
            trailing: trailling,
          ),
        ));
  }
}
