import 'dart:io';

import 'package:Tracio/domain/blog/entites/comment_blog.dart'
    show CommentBlogEntity;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/blog/entites/blog_entity.dart';
import 'package:Tracio/presentation/blog/pages/edit_blog.dart';
import 'package:Tracio/presentation/blog/widget/post_blog.dart';

import '../../../common/widget/appbar/app_bar.dart';
import '../../../data/blog/models/request/comment_blog_req.dart';
import '../../../data/blog/models/request/reply_comment_req.dart';
import '../../../domain/blog/entites/comment_input_data.dart';
import '../../../domain/blog/entites/reply_comment.dart';
import '../../../domain/blog/usecase/comment_blog.dart';
import '../../../domain/blog/usecase/rep_comment.dart';
import '../../../service_locator.dart';
import '../bloc/comment/comment_input_cubit.dart';
import '../bloc/comment/comment_input_state.dart';
import '../bloc/comment/get_comment_cubit.dart';
import '../bloc/get_blog_cubit.dart';
import '../widget/comment.dart';
import '../widget/comment_input.dart';
import '../widget/react_blog.dart';

class DetailBlogPage extends StatefulWidget {
  const DetailBlogPage({super.key, required this.blog, required this.userId});
  final BlogEntity blog;
  final int userId;

  @override
  State<DetailBlogPage> createState() => _DetailBlogPageState();
}

class _DetailBlogPageState extends State<DetailBlogPage> {
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
              // Giả sử success là ReplyCommentEntity hoặc một đối tượng chứa dữ liệu trả lời
              final newReply = ReplyCommentEntity(
                  userAvatar: success.userAvatar,
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
              _commentInputCubit.updateToDefault(widget.blog.blogId);
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
              // Giả sử success là ReplyCommentEntity
              final newReply = ReplyCommentEntity(
                  userAvatar: success.userAvatar,
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
              _commentInputCubit.updateToDefault(widget.blog.blogId);
              FocusScope.of(context).unfocus();
            },
          );
        }
        break;
    }
  }

  @override
  void initState() {
    _commentInputCubit = context.read<CommentInputCubit>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Item? selectedItem;
    final commentCubit = context.read<GetCommentCubit>();
    return Scaffold(
      appBar: BasicAppbar(
        height: 100.h,
        hideBack: false,
        title: Text(
          'Blog',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: AppSize.textHeading.sp),
        ),
        action: widget.userId == widget.blog.userId
            ? PopupMenuButton<Item>(
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
                  const PopupMenuItem<Item>(
                      value: Item.edit, child: Text('Edit')),
                  const PopupMenuItem<Item>(
                      value: Item.delete, child: Text('Delete')),
                ],
              )
            : SizedBox.shrink(),
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    expandedHeight: 320.h,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    pinned: false,
                    floating: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: PostBlog(
                        blogEntity: widget.blog,
                        // onLikeUpdated: () {},
                      ),
                    ),
                  ),
                  SliverAppBar(
                    expandedHeight: 50.h,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    pinned: false,
                    floating: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: ReactBlog(
                        blogEntity: widget.blog,
                        textReactionAction: () {},
                        cmtAction: () {},
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      // width: 400.w,
                      // height: MediaQuery.of(context).size.height / .5,
                      child: BlocProvider.value(
                        value: commentCubit,
                        child: Comment(
                          isDetail: true,
                          blogId: widget.blog.blogId,
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
          BlocBuilder<CommentInputCubit, CommentInputState>(
            builder: (context, inputState) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 10,
                  right: 10,
                ),
                child: CommentInputWidget(
                  inputData: inputState.inputData,
                  onSubmit: _handleCommentSubmit,
                  onReset: () {
                    _commentInputCubit.updateToDefault(widget.blog.blogId);
                  },
                ),
              );
            },
          ),
        ],
      ),
      // bottomNavigationBar: Padding(
      //   padding: EdgeInsets.only(
      //     bottom: AppSize.apHorizontalPadding,
      //     left: 10,
      //     right: 10,
      //   ),
      //   child: BlocBuilder<CommentInputCubit, CommentInputState>(
      //     builder: (context, inputState) {
      //       return CommentInputWidget(
      //         inputData: inputState.inputData,
      //         onSubmit: _handleCommentSubmit,
      //         onReset: () {
      //           _commentInputCubit.updateToDefault(widget.blog.blogId);
      //         },
      //       );
      //     },
      //   ),
      // ),
    );
  }
}

enum Item { edit, delete }
