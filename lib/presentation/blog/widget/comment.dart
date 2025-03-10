import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/data/blog/models/request/comment_blog_req.dart';
import 'package:tracio_fe/data/blog/models/request/get_reply_comment_req.dart';
import 'package:tracio_fe/data/blog/models/request/reply_comment_req.dart';
import 'package:tracio_fe/domain/blog/usecase/comment_blog.dart';
import 'package:tracio_fe/domain/blog/usecase/get_reply_comment.dart';
import 'package:tracio_fe/domain/blog/usecase/rep_comment.dart';
import 'package:tracio_fe/presentation/blog/widget/comment_item.dart';
import 'package:tracio_fe/service_locator.dart';
import '../../../domain/blog/entites/comment_input_data.dart';
import '../../../data/blog/models/request/get_comment_req.dart';
import '../bloc/comment/comment_input_state.dart';
import '../bloc/comment/get_comment_state.dart';
import '../bloc/comment/get_commnet_cubit.dart';
import '../bloc/comment/comment_input_cubit.dart';
import 'comment_input.dart';

class Comment extends StatefulWidget {
  final int blogId;
  final GetCommentCubit cubit;

  const Comment({super.key, required this.blogId, required this.cubit});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  late CommentInputCubit _commentInputCubit;

  @override
  void initState() {
    super.initState();
    _commentInputCubit = CommentInputCubit(widget.blogId);

    widget.cubit.getCommentBlog(GetCommentReq(
        blogId: widget.blogId,
        ascending: true,
        commentId: 0,
        pageNumber: 1,
        pageSize: 10));
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
        if (widget.blogId != null) {
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
                SnackBar(content: Text('Gửi bình luận thất bại')),
              );
            },
            (success) {
              widget.cubit.getCommentBlog(GetCommentReq(
                blogId: widget.blogId,
                ascending: true,
                commentId: 0,
                pageNumber: 1,
                pageSize: 10,
              ));
            },
          );
        }
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
              widget.cubit.getCommentBlog(GetCommentReq(
                blogId: widget.blogId,
                ascending: true,
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
                SnackBar(content: Text('Gửi phản hồi thất bại')),
              );
            },
            (success) {
              _commentInputCubit.updateToDefault(widget.blogId);

              widget.cubit.getCommentBlog(GetCommentReq(
                blogId: widget.blogId,
                ascending: true,
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
    return BlocProvider.value(
      value: _commentInputCubit,
      child: BlocBuilder<GetCommentCubit, GetCommentState>(
        bloc: widget.cubit,
        builder: (context, state) {
          return ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Container(
                      width: 200.w,
                      height: 3.h,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Comments',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 32.sp),
                  ),
                  Expanded(
                    child: _buildContent(state),
                  ),
                  BlocBuilder<CommentInputCubit, CommentInputState>(
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(GetCommentState state) {
    if (state is GetCommentLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is GetCommentFailure) {
      return const Center(child: Text("Chưa có bình luận"));
    }
    if (state is GetCommentLoaded) {
      final comments = state.listComment ?? [];
      return comments.isEmpty
          ? const Center(child: Text("Chưa có bình luận"))
          : ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.h),
                  child: CommentItem(
                    comment: comments[index],
                    onReplyTap: () {
                      _commentInputCubit.updateToReplyComment(comments[index]);
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                );
              },
            );
    }
    return const Center(child: Text("Chưa có bình luận"));
  }
}
