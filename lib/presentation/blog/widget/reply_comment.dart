// reply_comment_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/domain/blog/entites/reply_comment.dart';

import '../../../core/configs/theme/assets/app_images.dart';
import '../../../domain/blog/entites/comment_blog.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReplyCommentItem extends StatefulWidget {
  final ReplyCommentEntity reply;

  const ReplyCommentItem({
    Key? key,
    required this.reply,
  }) : super(key: key);

  @override
  State<ReplyCommentItem> createState() => _ReplyCommentItemState();
}

class _ReplyCommentItemState extends State<ReplyCommentItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          ClipOval(
            child: SizedBox(
              width: 50.w,
              height: 50.h,
              child: Image.asset(AppImages.man),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thông tin người dùng và thời gian
                Row(
                  children: [
                    Text(
                      widget.reply.cyclistName.toString(),
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      timeago.format(widget.reply.createdAt!, locale: 'vi'),
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                // Nội dung reply
                Text(
                  widget.reply.content.toString(),
                  style: TextStyle(
                    fontSize: 28.sp,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                // Nút tương tác
                // ...
              ],
            ),
          ),
        ],
      ),
    );
  }
}
