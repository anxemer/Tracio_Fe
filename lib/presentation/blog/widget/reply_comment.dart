// reply_comment_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/blog/entites/reply_comment.dart';

import '../../../common/widget/button/text_button.dart';
import '../../../core/configs/theme/app_colors.dart';
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
    var isDark = context.isDarkMode;
    List<String> mediaUrls =
        widget.reply.mediaFiles.map((file) => file.mediaUrl ?? "").toList();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          ClipOval(
            child: SizedBox(
              width: AppSize.iconMedium.w,
              height: AppSize.iconMedium.h,
              child: Image.asset(AppImages.man),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.reply.cyclistName.toString(),
                      style: TextStyle(
                        fontSize: AppSize.textMedium.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      timeago.format(widget.reply.createdAt!),
                      style: TextStyle(fontSize: AppSize.textMedium.sp),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                // Nội dung reply
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.reply.reReplyCyclistName == null
                            ? ''
                            : '@${widget.reply.reReplyCyclistName} ',
                        style: TextStyle(
                            fontSize: AppSize.textLarge.sp,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: widget.reply.content.toString(),
                        style: TextStyle(
                          fontSize: AppSize.textMedium.sp,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  softWrap: true,
                ),
                SizedBox(height: 8.h),
                mediaUrls.isEmpty
                    ? SizedBox()
                    : SizedBox(
                        height: AppSize.imageMedium.h,
                        width: AppSize.imageMedium.w,
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(mediaUrls[0],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, url, error) => Icon(
                                        Icons.error,
                                        color: AppColors.background,
                                      ),
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }),
                            )),
                      ),
                SizedBox(
                  height: 6.h,
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
                              size: AppSize.iconSmall.sp,
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
                                width: AppSize.iconSmall.w,
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
