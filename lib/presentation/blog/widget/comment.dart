import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/widget/drag_handle/drag_handle.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/data/blog/models/request/comment_blog_req.dart';
import 'package:tracio_fe/data/blog/models/request/get_reply_comment_req.dart';
import 'package:tracio_fe/data/blog/models/request/reply_comment_req.dart';
import 'package:tracio_fe/domain/blog/usecase/comment_blog.dart';
import 'package:tracio_fe/domain/blog/usecase/rep_comment.dart';
import 'package:tracio_fe/presentation/blog/widget/comment_item.dart';
import 'package:tracio_fe/service_locator.dart';
import '../../../domain/blog/entites/comment_input_data.dart';
import '../../../data/blog/models/request/get_comment_req.dart';
import '../bloc/comment/comment_input_state.dart';
import '../bloc/comment/get_comment_state.dart';
import '../bloc/comment/get_comment_cubit.dart';
import '../bloc/comment/comment_input_cubit.dart';
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
        blogId: widget.blogId, commentId: 0, pageNumber: 1, pageSize: 10));
  }

  @override
  void dispose() {
    _commentInputCubit.close();
    super.dispose();
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
            context.read<GetCommentCubit>().getCommentBlog(GetCommentReq(
                  blogId: widget.blogId,
                  commentId: 0,
                  pageNumber: 1,
                  pageSize: 10,
                ));
          },
        );
        break;

      case CommentMode.replyComment:
        if (inputData.commentId != null) {
          var result = await sl<RepCommentUsecase>().call(
            ReplyCommentReq(
              commentId: inputData.commentId!,
              content: content,
              files: files,
              // replyId: 1,
            ),
          );

          result.fold(
            (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('reply faile')),
              );
            },
            (success) {
              _commentInputCubit.updateToDefault(widget.blogId);
              // sl<GetReplyCommentUsecase>().call(GetReplyCommentReq(
              //     commentId: inputData.commentId!,
              //     pageSize: 10,
              //     pageNumber: 1));
              context.read<GetCommentCubit>().getCommentBlog(GetCommentReq(
                    blogId: widget.blogId,
                    commentId: 0,
                    pageNumber: 1,
                    pageSize: 10,
                  ));
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
              files: files,
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
              _commentInputCubit.updateToDefault(widget.blogId);

              context.read<GetCommentCubit>().getCommentBlog(GetCommentReq(
                    blogId: widget.blogId,
                    commentId: 0,
                    pageNumber: 1,
                    pageSize: 10,
                  ));
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
            SizedBox(
              height: 10.h,
            ),
            DragHandle(
              width: MediaQuery.of(context).size.width * 0.3.w,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Comments',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: AppSize.textHeading.sp,
              ),
            ),
            Expanded(
              child: _buildContent(),
            ),
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
                shrinkWrap: !widget.isDetail,
                physics: widget.isDetail
                    ? NeverScrollableScrollPhysics()
                    : AlwaysScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.h),
                    child: CommentItem(
                      comment: comments[index],
                      replyCount: comments[index].replyCount,
                      onViewMoreReviewTap: () async {},
                      onReact: () async {},
                      onReply: () async {
                        _commentInputCubit
                            .updateToReplyComment(comments[index]);
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
    });
  }
}
