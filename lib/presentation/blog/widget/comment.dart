import 'dart:io';

import 'package:Tracio/domain/blog/entites/comment_blog.dart';
import 'package:Tracio/domain/blog/entites/reply_comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/common/widget/drag_handle/drag_handle.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/data/blog/models/request/comment_blog_req.dart';
import 'package:Tracio/data/blog/models/request/reply_comment_req.dart';
import 'package:Tracio/domain/blog/usecase/comment_blog.dart';
import 'package:Tracio/domain/blog/usecase/rep_comment.dart';
import 'package:Tracio/presentation/blog/widget/comment_item.dart';
import 'package:Tracio/service_locator.dart';
import '../../../domain/blog/entites/comment_input_data.dart';
import '../../../data/blog/models/request/get_comment_req.dart';
import '../bloc/comment/comment_input_state.dart';
import '../bloc/comment/get_comment_state.dart';
import '../bloc/comment/get_comment_cubit.dart';
import '../bloc/comment/comment_input_cubit.dart';
import '../bloc/get_blog_cubit.dart';
import 'comment_input.dart';

class Comment extends StatefulWidget {
  final int blogId;
  final bool isDetail;

  const Comment({
    super.key,
    required this.blogId,
    this.isDetail = false,
  });

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  late CommentInputCubit _commentInputCubit;

  @override
  void initState() {
    super.initState();
    _commentInputCubit = context.read<CommentInputCubit>();
    context.read<GetCommentCubit>().getCommentBlog(GetCommentReq(
        blogId: widget.blogId, commentId: 0, pageNumber: 1, pageSize: 50));
  }

  void _handleCommentSubmit(
      String content, List<File> files, CommentInputData inputData) async {
    if (content.isEmpty && files.isEmpty) return;

    switch (inputData.mode) {
      case CommentMode.blogComment:
        var result = await sl<CommentBlogUsecase>().call(
          CommentBlogReq(
            blogId: widget.blogId,
            content: content,
            mediaFiles: files,
          ),
        );

        result.fold(
          (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Comment Fail')),
            );
          },
          (success) {
            // Giả sử success là CommentBlogEntity hoặc một đối tượng chứa dữ liệu bình luận
            final newComment = CommentBlogEntity(
              commentId:
                  success.commentId, // Dùng timestamp nếu API không trả id
              content: content,
              mediaFiles: success.mediaFiles,
              replyCount: 0,
              replyCommentPagination: success.replyCommentPagination,
              cyclistId: success.cyclistId,
              cyclistName: success.cyclistName,
              cyclistAvatar: success.cyclistAvatar,
              isReacted: success.isReacted,
              createdAt: success.createdAt,
              likeCount: success.likeCount,
              mediaUrls: [],
              tagUserNames: [],
            );
            context.read<GetCommentCubit>().addComment(newComment);
            // context.read<GetBlogCubit>().incrementCommentCount(widget.blogId);
            FocusScope.of(context).unfocus();
          },
        );
        break;

      case CommentMode.replyComment:
        if (inputData.commentId != null) {
          var result = await sl<RepCommentUsecase>().call(
            ReplyCommentReq(
              commentId: inputData.commentId!,
              content: content,
              mediaFiles: files,
            ),
          );

          result.fold(
            (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Reply failed')),
              );
            },
            (success) {
              final newReply = ReplyCommentEntity(
                  replyId: success.replyId,
                  cyclistId: success.cyclistId,
                  commentId: success.commentId,
                  cyclistName: success.cyclistName,
                  reReplyCyclistName: success.reReplyCyclistName,
                  content: success.content,
                  isReacted: success.isReacted,
                  mediaFiles: success.mediaFiles,
                  createdAt: success.createdAt,
                  tagUserNames: [],
                  mediaUrls: [],
                  likeCount: success.likeCount,
                  replyCount: 0);
              context
                  .read<GetCommentCubit>()
                  .addReplyComment(inputData.commentId!, newReply);
              // context.read<GetBlogCubit>().incrementCommentCount(widget.blogId);
              _commentInputCubit.updateToDefault(widget.blogId);
              FocusScope.of(context).unfocus();
            },
          );
        }
        break;

      case CommentMode.replyToReply:
        if (inputData.commentId != null) {
          var result = await sl<RepCommentUsecase>().call(
            ReplyCommentReq(

              commentId: inputData.commentId!,
              content: content,
              mediaFiles: files,
              replyId: inputData.replyId,
            ),
          );

          result.fold(
            (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Reply comment fail')),
              );
            },
            (success) {
              final newReply = ReplyCommentEntity(
                  replyId: success.replyId,
                  cyclistId: success.cyclistId,
                  commentId: success.commentId,
                  cyclistName: success.cyclistName,
                  reReplyCyclistName: success.reReplyCyclistName,
                  content: success.content,
                  isReacted: success.isReacted,
                  mediaFiles: success.mediaFiles,
                  createdAt: success.createdAt,
                  tagUserNames: [],
                  mediaUrls: [],
                  likeCount: success.likeCount,
                  replyCount: 0);
              context
                  .read<GetCommentCubit>()
                  .addReplyComment(inputData.commentId!, newReply);
              // context.read<GetBlogCubit>().incrementCommentCount(widget.blogId);
              _commentInputCubit.updateToDefault(widget.blogId);
              FocusScope.of(context).unfocus();
            },
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppSize.borderRadiusLarge),
        topRight: Radius.circular(AppSize.borderRadiusLarge),
      ),
      child: Container(
        color: context.isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        child: Column(
          children: [
            SizedBox(height: 10.h),
            DragHandle(width: MediaQuery.of(context).size.width * 0.3.w),
            SizedBox(height: 10),
            Text(
              'Comments',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: AppSize.textHeading.sp,
              ),
            ),
            if (widget.isDetail)
              _buildContent()
            else
              Flexible(child: _buildContent()),
            widget.isDetail
                ? SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(
                        bottom: AppSize.apHorizontalPadding,
                        left: 10,
                        right: 10),
                    child: BlocBuilder<CommentInputCubit, CommentInputState>(
                      builder: (context, inputState) {
                        return CommentInputWidget(
                          inputData: inputState.inputData,
                          onSubmit: _handleCommentSubmit,
                          onReset: () {
                            _commentInputCubit.updateToDefault(widget.blogId);
                          },
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<GetCommentCubit, GetCommentState>(
      builder: (context, state) {
        if (state is GetCommentLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is GetCommentFailure) {
          return const Center(child: Text("Haven't Comment yet"));
        }
        if (state is GetCommentLoaded) {
          final comments = state.listComment;
          return comments.isEmpty
              ? const Center(child: Text("Haven't Comment yet"))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: widget.isDetail
                      ? NeverScrollableScrollPhysics()
                      : AlwaysScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.h, vertical: 10.h),
                      child: CommentItem(
                        onReply: (reply) async {
                          _commentInputCubit.updateToReplyToReply(reply);
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        comment: comment,
                        replyCount: comment.replyCount,
                        onViewMoreReviewTap: () async {},
                        onReact: () async {},
                        onCmt: () async {
                          _commentInputCubit.updateToReplyComment(comment);
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        onViewMoreReplyTap: (commentId) async {
                          await context
                              .read<GetCommentCubit>()
                              .getCommentBlogReply(commentId);
                        },
                      ),
                    );
                  },
                );
        }
        return const Center(child: Text("Haven't Comment yet"));
      },
    );
  }
}
