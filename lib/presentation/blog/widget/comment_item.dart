import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/bloc/generic_data_cubit.dart';
import 'package:tracio_fe/common/bloc/generic_data_state.dart';
import 'package:tracio_fe/common/widget/button/text_button.dart';
import 'package:tracio_fe/data/blog/models/request/get_reply_comment_req.dart';
import 'package:tracio_fe/data/blog/models/request/reply_comment_req.dart';
import 'package:tracio_fe/domain/blog/entites/comment_blog.dart';
import 'package:tracio_fe/domain/blog/entites/reply_comment.dart';
import 'package:tracio_fe/domain/blog/usecase/get_reply_comment.dart';
import 'package:tracio_fe/domain/blog/usecase/rep_comment.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import '../../../data/blog/models/request/comment_blog_req.dart';
import '../../../data/blog/models/request/react_blog_req.dart';
import '../../../domain/blog/usecase/react_blog.dart';
import '../../../domain/blog/usecase/un_react_blog.dart';
import '../../../service_locator.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'reply_comment.dart';

class CommentItem extends StatefulWidget {
  const CommentItem({super.key, required this.comment});
  final CommentBlogEntity comment;

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool toogleIsReaction(bool isReaction) {
    return !isReaction;
  }

  List<ReplyCommentEntity> replyCmt = [];
  bool _showReplies = false;
  TextEditingController _titleCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GenericDataCubit(),
      child: BlocBuilder<GenericDataCubit, GenericDataState>(
        builder: (context, state) {
          return Column(
            children: [
              Container(
                height: 2.h,
                color: Colors.black45,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Phần avatar và thanh dọc
                    Column(
                      children: [
                        // Avatar
                        ClipOval(
                          child: SizedBox(
                            width: 60.w,
                            height: 60.h,
                            child: Image.asset(AppImages.man),
                          ),
                        ),
                        Container(
                          width: 2.w,
                          height:
                              _showReplies && widget.comment.repliesCount != 0
                                  ? (120 + widget.comment.repliesCount * 120).h
                                  : 120.h, // Điều chỉnh chiều cao của thanh dọc
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ],
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tên người dùng và thời gian
                          Row(
                            children: [
                              Text(
                                widget.comment.userName.toString(),
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Text(
                                timeago.format(widget.comment.createdAt!,
                                    locale: 'vi'),
                                style: TextStyle(fontSize: 20.sp),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            widget.comment.content.toString(),
                            style: TextStyle(
                              fontSize: 32.sp,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 12.h),

                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    if (widget.comment.isReacted == true) {
                                      await sl<UnReactBlogUseCase>().call(
                                          UnReactionParam(
                                              id: widget.comment.commentId!,
                                              type: 'comment'));
                                      setState(() {
                                        if (widget.comment.likesCount > 0) {
                                          widget.comment.likesCount--;
                                        }

                                        widget.comment.isReacted = false;
                                      });
                                    } else {
                                      var result = await sl<ReactBlogUseCase>()
                                          .call(ReactBlogReq(
                                              entityId:
                                                  widget.comment.commentId,
                                              entityType: "comment"));
                                      result.fold((error) {
                                        error;
                                      }, (data) {
                                        bool isReact = toogleIsReaction(
                                            widget.comment.isReacted);

                                        setState(() {
                                          widget.comment.likesCount++;
                                          widget.comment.isReacted = isReact;
                                        });
                                      });
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        widget.comment.isReacted
                                            ? Icons.favorite
                                            : Icons.favorite_border_outlined,
                                        color: widget.comment.isReacted
                                            ? Colors.red
                                            : Colors.black,
                                        size: 40.sp,
                                      ),
                                      BasicTextButton(
                                          text: widget.comment.likesCount
                                              .toString(),
                                          onPress: () {})
                                    ],
                                  )),
                              SizedBox(width: 20.w),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _showReplies = !_showReplies;
                                      });
                                      if (_showReplies) {
                                        context
                                            .read<GenericDataCubit>()
                                            .getData<List<ReplyCommentEntity>>(
                                                sl<GetReplyCommentUsecase>(),
                                                params: GetReplyCommentReq(
                                                    commentId: widget
                                                        .comment.commentId!,
                                                    replyId: 0,
                                                    pageSize: 10,
                                                    pageNumber: 1));
                                      }
                                    },
                                    child: Image.asset(
                                      AppImages.reply,
                                      width: 40.w,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  BasicTextButton(
                                      text: widget.comment.repliesCount
                                          .toString(),
                                      onPress: () {}),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          if (widget.comment.repliesCount > 0)
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  _showReplies = !_showReplies;
                                });
                                if (_showReplies) {
                                  context
                                      .read<GenericDataCubit>()
                                      .getData<List<ReplyCommentEntity>>(
                                          sl<GetReplyCommentUsecase>(),
                                          params: GetReplyCommentReq(
                                              commentId:
                                                  widget.comment.commentId!,
                                              replyId: 0,
                                              pageSize: 10,
                                              pageNumber: 1));
                                }
                              },
                              child: Text(
                                _showReplies
                                    ? "Hide ${widget.comment.repliesCount} reply"
                                    : "Show ${widget.comment.repliesCount} reply",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 24.sp,
                                ),
                              ),
                            ),
                          if (_showReplies)
                            Builder(
                              builder: (context) {
                                if (state is DataLoading) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16.h),
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                } else if (state is DataLoaded) {
                                  final double itemHeight = 120
                                      .h; // Chiều cao trung bình cho mỗi reply
                                  final double padding =
                                      20.h; // Padding giữa các item
                                  final double totalHeight =
                                      (itemHeight + padding) *
                                          state.data.length;

                                  // Đặt giới hạn tối thiểu và tối đa (tuỳ chọn)
                                  final double minHeight = 100.h;
                                  final double maxHeight = 1000.h;
                                  final double dynamicHeight =
                                      totalHeight.clamp(minHeight, maxHeight);
                                  return Column(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        height: dynamicHeight,
                                        child: ListView.builder(
                                          itemCount: state.data.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.h,
                                                  vertical: 10.h),
                                              child: ReplyCommentItem(
                                                  reply: state.data[index]),
                                            );
                                          },
                                        ),
                                      ),
                                      _comment(() {
                                        context
                                            .read<GenericDataCubit>()
                                            .getData<List<ReplyCommentEntity>>(
                                                sl<GetReplyCommentUsecase>(),
                                                params: GetReplyCommentReq(
                                                    commentId: widget
                                                        .comment.commentId!,
                                                    replyId: 0,
                                                    pageSize: 10,
                                                    pageNumber: 1));
                                      })
                                    ],
                                  );
                                } else if (state is FailureLoadData) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16.h),
                                    child: Text(
                                      "Không thể tải replies: ${state.errorMessage}",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  );
                                }
                                return Container();
                              },
                            ),
                          // Hiển thị danh sách reply comments nếu _showReplies = true
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _comment(Function() onReplySubmitted) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60.sp),
            border: Border.all(color: Colors.black45, width: 1.w)),
        child: Row(
          children: [
            Padding(padding: EdgeInsets.symmetric(horizontal: 10.w)),
            ClipOval(
              child: SizedBox(
                width: 40.w,
                height: 40.h,
                child: Image.asset(AppImages.man),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: TextField(
                controller: _titleCon,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Reply',
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            SizedBox(width: 5.w),
            GestureDetector(
                onTap: () async {
                  var result =
                      await sl<RepCommentUsecase>().call(ReplyCommentReq(
                    commentId: widget.comment.commentId!,
                    content: _titleCon.text,
                  ));
                  result.fold((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gửi bình luận thất bại')),
                    );
                  }, (susscess) {
                    onReplySubmitted();
                    _titleCon.clear();
                    widget.comment.repliesCount++;
                  });
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Icon(Icons.send_rounded,
                    color: AppColors.background, size: 20)),
          ],
        ),
      ),
    );
  }
}
