import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CirclePicture extends StatelessWidget {
  const CirclePicture(
      {super.key, required this.imageUrl, required this.imageSize});
  final String imageUrl;
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        backgroundImage: imageProvider,
        radius: imageSize.w,
      ),
      placeholder: (context, url) => CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        radius: imageSize.w,
        child: Icon(
          Icons.person,
          color: Colors.white,
          size: imageSize.w,
        ),
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        radius: imageSize.w,
        child: Icon(
          Icons.image_outlined,
          size: imageSize.w,
        ),
      ),
    );
  }
}
