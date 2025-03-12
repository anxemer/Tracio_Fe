// reply_comment_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/domain/blog/entites/reply_comment.dart';

import '../../../common/widget/button/text_button.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import '../../../data/blog/models/request/react_blog_req.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../domain/blog/usecase/react_blog.dart';
import '../../../domain/blog/usecase/un_react_blog.dart';
import '../../../service_locator.dart';
import '../bloc/comment/comment_input_cubit.dart';

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
  bool toogleIsReaction(bool isReaction) {
    return !isReaction;
  }

  @override
  Widget build(BuildContext context) {
    final commentInputCubit = context.read<CommentInputCubit>();

    List<String> mediaUrls =
        widget.reply.mediaFiles.map((file) => file.mediaUrl ?? "").toList();
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
                Row(
                  children: [
                    Text(
                      '@${widget.reply.cyclistName}',
                      style: TextStyle(
                          fontSize: 32.sp,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      widget.reply.content.toString(),
                      style: TextStyle(
                        fontSize: 28.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                mediaUrls.isEmpty
                    ? SizedBox()
                    : SizedBox(
                        height: 200.h,
                        width: 200.w,
                        child: Image.network(mediaUrls[0], fit: BoxFit.cover),
                      ),
                Row(
                  children: [
                    GestureDetector(
                        onTap: () async {
                          if (widget.reply.isReacted == true) {
                            await sl<UnReactBlogUseCase>().call(UnReactionParam(
                                id: widget.reply.commentId, type: 'reply'));
                            setState(() {
                              if (widget.reply.likesCount > 0) {
                                widget.reply.likesCount--;
                              }

                              widget.reply.isReacted = false;
                            });
                          } else {
                            var result = await sl<ReactBlogUseCase>().call(
                                ReactBlogReq(
                                    entityId: widget.reply.commentId,
                                    entityType: "comment"));
                            result.fold((error) {
                              error;
                            }, (data) {
                              bool isReact =
                                  toogleIsReaction(widget.reply.isReacted);

                              setState(() {
                                widget.reply.likesCount++;
                                widget.reply.isReacted = isReact;
                              });
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              widget.reply.isReacted
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              color: widget.reply.isReacted
                                  ? Colors.red
                                  : Colors.black,
                              size: 30.sp,
                            ),
                            BasicTextButton(
                                text: widget.reply.likesCount.toString(),
                                onPress: () {}),
                            SizedBox(
                              width: 10.w,
                            ),
                            InkWell(
                              onTap: () => commentInputCubit
                                  .updateToReplyToReply(widget.reply),
                              child: Image.asset(
                                AppImages.reply,
                                width: 40.w,
                              ),
                            )
                          ],
                        )),
                    // SizedBox(width: 20.w),
                  ],
                ),
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
