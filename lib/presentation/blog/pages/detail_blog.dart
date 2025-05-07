import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/blog/entites/blog_entity.dart';
import 'package:Tracio/presentation/blog/pages/edit_blog.dart';
import 'package:Tracio/presentation/blog/widget/post_blog.dart';

import '../../../common/widget/appbar/app_bar.dart';
import '../../../data/blog/models/request/comment_blog_req.dart';
import '../../../data/blog/models/request/get_comment_req.dart';
import '../../../data/blog/models/request/reply_comment_req.dart';
import '../../../domain/blog/entites/comment_input_data.dart';
import '../../../domain/blog/usecase/comment_blog.dart';
import '../../../domain/blog/usecase/rep_comment.dart';
import '../../../service_locator.dart';
import '../bloc/comment/comment_input_cubit.dart';
import '../bloc/comment/get_comment_cubit.dart';
import '../widget/comment.dart';
import '../widget/react_blog.dart';

class DetailBlocPage extends StatefulWidget {
  const DetailBlocPage({super.key, required this.blog});
  final BlogEntity blog;

  @override
  State<DetailBlocPage> createState() => _DetailBlocPageState();
}

class _DetailBlocPageState extends State<DetailBlocPage> {
  late CommentInputCubit _commentInputCubit;
  void _handleCommentSubmit(
      String content, List<File> files, CommentInputData inputData) async {
    if (content.isEmpty && files.isEmpty) return;

    switch (inputData.mode) {
      case CommentMode.blogComment:
        var result = await sl<CommentBlogUsecase>().call(
          CommentBlogReq(
            blogId: widget.blog.blogId,
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
                  blogId: widget.blog.blogId,
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
              _commentInputCubit.updateToDefault(widget.blog.blogId);
              // sl<GetReplyCommentUsecase>().call(GetReplyCommentReq(
              //     commentId: inputData.commentId!,
              //     pageSize: 10,
              //     pageNumber: 1));
              context.read<GetCommentCubit>().getCommentBlog(GetCommentReq(
                    blogId: widget.blog.blogId,
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
              _commentInputCubit.updateToDefault(widget.blog.blogId);

              context.read<GetCommentCubit>().getCommentBlog(GetCommentReq(
                    blogId: widget.blog.blogId,
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
  void initState() {
    _commentInputCubit = CommentInputCubit(widget.blog.blogId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Item? selectedItem;
    final commentCubit = context.read<GetCommentCubit>();
    return Scaffold(
        appBar: BasicAppbar(
          backgroundColor: AppColors.lightBackground,
          height: 100.h,
          hideBack: false,
          title: Text(
            'Blog',
            style: TextStyle(
                color:
                    context.isDarkMode ? Colors.grey.shade200 : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: AppSize.textHeading.sp),
          ),
          action: PopupMenuButton<Item>(
            initialValue: selectedItem,
            onSelected: (Item item) {
              setState(() {
                selectedItem = item;
              });
              if (item == Item.edit) {
                // Chuyển sang trang Edit
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditBlogPostScreen(
                            imageUrl: widget.blog.mediaFiles,
                            blogId: widget.blog.blogId,
                            initialContent: widget.blog.content,
                            initialIsPublic: widget.blog.isPublic,
                          )),
                );
              } else if (item == Item.delete) {}
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Item>>[
              const PopupMenuItem<Item>(value: Item.edit, child: Text('Edit')),
              const PopupMenuItem<Item>(
                  value: Item.delete, child: Text('Delete')),
            ],
          ),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                PostBlog(blogEntity: widget.blog),
                ReactBlog(
                    blogEntity: widget.blog,
                    textReactionAction: () {},
                    cmtAction: () {}),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  // width: 400.w,
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: BlocProvider(
                    create: (context) => CommentInputCubit(widget.blog.blogId),
                    child: BlocProvider.value(
                      value: commentCubit,
                      child: Comment(
                        blogId: widget.blog.blogId,
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //       bottom: AppSize.apHorizontalPadding, left: 10, right: 10),
                //   child: BlocBuilder<CommentInputCubit, CommentInputState>(
                //     builder: (context, inputState) {
                //       return CommentInputWidget(
                //         inputData: inputState.inputData,
                //         onSubmit: _handleCommentSubmit,
                //         onReset: () {
                //           _commentInputCubit
                //               .updateToDefault(widget.blog.blogId);
                //         },
                //       );
                //     },
                //   ),
                // )
                // Comment(blogId: widget.blog.blogId, cubit: commentCubit)
              ],
            )));
  }
}

enum Item { edit, delete }
