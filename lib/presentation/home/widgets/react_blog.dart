import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReactBlog extends StatefulWidget {
  const ReactBlog({super.key});

  @override
  State<ReactBlog> createState() => _ReactBlogState();
}

class _ReactBlogState extends State<ReactBlog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20.h,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 20.w,
            ),
            Row(
              children: [
                Icon(
                  Icons.favorite_outline,
                  color: Colors.red,
                  size: 52.sp,
                ),
                Text(
                  '0',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.sp,
                      color: Colors.black),
                )
              ],
            ),
            SizedBox(
              width: 20.w,
            ),
            Row(
              children: [
                Icon(
                  Icons.comment_outlined,
                  color: Colors.black,
                  size: 52.sp,
                ),
                Text(
                  '0',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.sp,
                      color: Colors.black),
                )
              ],
            ),
            SizedBox(
              width: 20.w,
            ),
            Row(
              children: [
                Icon(
                  Icons.ios_share,
                  color: Colors.black,
                  size: 52.sp,
                ),
                Text(
                  '0',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.sp,
                      color: Colors.black),
                )
              ],
            ),
            // SizedBox(
            //   width: 400.w,
            // ),
            Spacer(),
            Icon(
              Icons.bookmark_border,
              color: Colors.black,
              size: 52.sp,
            ),
          ],
        )
      ],
    );
  }
}
