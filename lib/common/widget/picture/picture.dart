import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PictureCustom extends StatelessWidget {
  const PictureCustom({
    super.key,
    required this.imageUrl,
    this.borderRadius = 12.0,
    required this.width,
    required this.height,
  });

  final String imageUrl;
  final double borderRadius;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius.r),
        child: Image(
          image: imageProvider,
          fit: BoxFit.cover,
          width: width.w,
          height: height.h,
        ),
      ),
      placeholder: (context, url) => ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius.r),
        child: Container(
          width: width.w,
          height: height.h,
          color: Colors.grey.shade300,
          child: Icon(
            Icons.photo_size_select_actual_rounded,
            color: Colors.white,
            size: 30.sp,
          ),
        ),
      ),
      errorWidget: (context, url, error) => ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius.r),
        child: Container(
          width: width.w,
          height: height.h,
          color: Colors.grey.shade300,
          child: Icon(
            Icons.error_outline_outlined,
            size: 30.sp,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
