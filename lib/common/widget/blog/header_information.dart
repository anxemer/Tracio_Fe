import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/core/constants/app_size.dart';

class HeaderInformation extends StatelessWidget {
  const HeaderInformation(
      {super.key,
      required this.title,
      required this.imageUrl,
      this.subtitle,
      this.trailling,
      this.widthImage});
  final Text title;
  final Widget imageUrl;
  final Text? subtitle;
  final Widget? trailling;
  final double? widthImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: AppSize.bannerHeight.h,
        child: Center(
          child: ListTile(
            leading: CircleAvatar(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(double.infinity)),
                  width: widthImage ?? AppSize.imageMedium.w,
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
