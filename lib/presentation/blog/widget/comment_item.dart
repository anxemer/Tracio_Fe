import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/widget/blog/picture_card.dart';
import 'package:tracio_fe/domain/blog/entites/comment_blog.dart';
import 'package:tracio_fe/domain/blog/entites/reply_comment.dart';
import 'package:tracio_fe/presentation/blog/bloc/comment/get_comment_cubit.dart';
import 'package:tracio_fe/presentation/blog/widget/comment.dart';
import 'package:tracio_fe/presentation/library/bloc/reaction/bloc/reaction_bloc.dart';

import '../../../common/widget/blog/comment/comment.dart';
import '../../../common/widget/blog/comment/comment_tree_widget.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/app_size.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../bloc/comment/get_comment_state.dart';

class CommentItem extends StatefulWidget {
  const CommentItem(
      {super.key,
      required this.comment,
      required this.replyCount,
      required this.onViewMoreReplyTap,
      required this.onViewMoreReviewTap,
      required this.onReact,
      required this.onReply});
  final CommentBlogEntity comment;
  final int replyCount;
  final Future<void> Function(int) onViewMoreReplyTap;
  final Future<void> Function() onViewMoreReviewTap;
  final Future<void> Function() onReact;
  final Future<void> Function() onReply;

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool toogleIsReaction(bool isReaction) {
    return !isReaction;
  }

  void handleReplyTap() async {
    await widget.onViewMoreReplyTap(widget.comment.commentId);
  }

  void handleReplyCommentTab() async {
    await widget.onReply();
  }

  void handleReactComment() async {}

  @override
  Widget build(BuildContext context) {
    List<String> mediaUrls =
        widget.comment.mediaFiles!.map((file) => file.mediaUrl ?? "").toList();
    // final commentInputCubit = context.read<CommentInputCubit>();

    return BlocBuilder<GetCommentCubit, GetCommentState>(
      builder: (context, state) {
        if (state is GetCommentLoaded) {
          final review = state.listComment.firstWhere(
              (comment) => comment.commentId == widget.comment.commentId);

          final isReplyOpened =
              review.replyCommentPagination?.replies != null &&
                  review.replyCommentPagination!.replies.isNotEmpty;

          return CommentTreeWidget<CommentBlogEntity, ReplyCommentEntity?>(
            lineColor: Colors.grey.shade300,
            lineWidth: 2.5,
            comment: widget.comment,
            replies: isReplyOpened
                ? review.replyCommentPagination?.replies ?? []
                : (widget.comment.replyCount > 0 ? [null] : []),
            avatarComment: (context, comment) => PreferredSize(
              preferredSize: Size(22.0 * 2, 22.0 * 2),
              child: _buildAvatar(
                comment.cyclistAvatar,
                Size(22.0 * 2, 22.0 * 2),
              ),
            ),
            avatarReply: (context, reply) => PreferredSize(
              preferredSize:
                  isReplyOpened ? Size(16.0 * 2, 16.0 * 2) : Size(0, 0),
              child: isReplyOpened
                  ? _buildAvatar(
                      reply?.userAvatar ??
                          'https://img.tripi.vn/cdn-cgi/image/width=700,height=700/https://img7.thuthuatphanmem.vn/uploads/2023/08/18/meme-anh-da-den-cham-hoi_052117827.jpg',
                      Size(16.0 * 2, 16.0 * 2),
                    )
                  : SizedBox.shrink(),
            ),
            commentContent: (context, comment) {
              final isReacted = widget.comment.isReacted;
              final likeCount = widget.comment.likeCount;

              return _buildComment(
                comment,
                isReacted: isReacted,
                likeCount: likeCount,
                onReact: () {
                  final isNowReacted = toogleIsReaction(isReacted);
                  setState(() {
                    widget.comment.isReacted = isNowReacted;
                    widget.comment.likeCount += isNowReacted ? 1 : -1;
                  });

                  context.read<ReactionBloc>().add(
                        isNowReacted
                            ? ReactComment(commentId: widget.comment.commentId)
                            : UnReactComment(
                                commentId: widget.comment.commentId),
                      );
                },
              );
            },
            replyContent: (context, reply) {
              if (!isReplyOpened) {
                return _buildReplyCount(widget.comment.replyCount);
              }

              final isReacted = reply!.isReacted;
              final likeCount = reply.likeCount;

              return _buildComment(
                reply,
                isReacted: isReacted,
                likeCount: likeCount,
                onReact: () {
                  final isNowReacted = toogleIsReaction(isReacted);
                  setState(() {
                    reply.isReacted = isNowReacted;
                    reply.likeCount += isNowReacted ? 1 : -1;
                  });

                  context.read<ReactionBloc>().add(
                        isNowReacted
                            ? ReactReplyComment(replyCommentId: reply.commentId)
                            : UnReactReplyComment(
                                replyCommentId: reply.commentId),
                      );
                },
              );
            },
          );
        }

        return SizedBox.shrink();
      },
    );
  }

  Widget _buildPlaceholderIcon(IconData icon) {
    return Container(
      color: Colors.grey.shade300,
      child: Icon(icon, color: Colors.white, size: 18.0),
    );
  }

  Widget _buildAvatar(String avatarUrl, Size avatarSize) {
    return CircleAvatar(
      radius: avatarSize.width / 2,
      backgroundColor: Colors.grey.shade300,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: avatarUrl,
          fit: BoxFit.cover,
          width: avatarSize.width,
          height: avatarSize.height,
          placeholder: (context, url) => _buildPlaceholderIcon(Icons.person),
          errorWidget: (context, url, error) =>
              _buildPlaceholderIcon(Icons.person),
        ),
      ),
    );
  }

  Widget _buildReplyCount(int replyCount) {
    return InkWell(
        onTap: handleReplyTap,
        child: SizedBox(
          width: double.infinity,
          child: Text(
            "View $replyCount more reply...",
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ));
  }

  Widget _buildComment(
    BaseCommentEntity comment, {
    required bool isReacted,
    required int likeCount,
    required VoidCallback onReact,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // NAME
              Text(comment.userName,
                  style: TextStyle(
                    fontSize: AppSize.textMedium.sp,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 4.0),
              // CONTENT
              Text(comment.content,
                  style: TextStyle(
                    fontSize: AppSize.textMedium.sp,
                  )),
              if (comment.mediaUrls.isNotEmpty)
                SizedBox(
                  height: AppSize.imageLarge.h,
                  width: AppSize.imageLarge.w,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: PictureCard(
                        listImageUrl: comment.mediaUrls,
                        imageWidth: AppSize.imageSmall.w,
                        imageheight: AppSize.imageSmall.h,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        // REACTION ROW
        Row(
          children: [
            Text(
              timeago.format(comment.createdAt),
              style: TextStyle(color: Colors.grey.shade500),
            ),
            InkWell(
              onTap: onReact,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: isReacted
                    ? Icon(Icons.favorite, color: Colors.red)
                    : Text("Like",
                        style: TextStyle(color: Colors.grey.shade500)),
              ),
            ),
            InkWell(
              onTap: handleReplyCommentTab,
              child:
                  Text("Reply", style: TextStyle(color: Colors.grey.shade500)),
            ),
            Spacer(),
            if (likeCount > 0)
              Text("$likeCount reacts",
                  style: TextStyle(color: Colors.grey.shade500)),
          ],
        ),
      ],
    );
  }

  //   BlocBuilder<GenericDataCubit, GenericDataState>(
  //     builder: (context, state) {
  //       return Column(
  //         children: [
  //           Container(
  //             height: 2.h,
  //             color: context.isDarkMode ? Colors.white : Colors.black45,
  //           ),
  //           Padding(
  //             padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
  //             child: Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 // Phần avatar và thanh dọc
  //                 Column(
  //                   children: [
  //                     // Avatar
  //                     ClipOval(
  //                       child: SizedBox(
  //                           // width: AppSize.imageSmall.w,
  //                           // height: AppSize.imageSmall.h,
  //                           child: CachedNetworkImage(
  //                         imageUrl: widget.comment.avatar??'',
  //                         fit: BoxFit.cover,
  //                         imageBuilder: (context, imageProvider) =>
  //                             CircleAvatar(
  //                           // radius: 30.sp,
  //                           backgroundImage: imageProvider,
  //                         ),
  //                         errorWidget: (context, url, error) => CircleAvatar(
  //                           backgroundColor: Colors.transparent,
  //                           radius: AppSize.imageSmall / 2.4.w,
  //                           child: Icon(
  //                             Icons.person,
  //                             size: AppSize.imageSmall / 2.w,
  //                           ),
  //                         ),
  //                       )),
  //                     ),
  //                     Container(
  //                       width: 2.w,
  //                       height:
  //                           _showReplies && widget.comment.repliesCount != 0
  //                               ? (120 + widget.comment.repliesCount * 120).h
  //                               : 40.h, // Điều chỉnh chiều cao của thanh dọc
  //                       color: Colors.grey.shade300,
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(width: 8.w),
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Row(
  //                         children: [
  //                           Text(
  //                             widget.comment.userName.toString(),
  //                             style: TextStyle(
  //                               fontSize: AppSize.textMedium.sp,
  //                               fontWeight: FontWeight.bold,
  //                               color: context.isDarkMode
  //                                   ? Colors.white
  //                                   : Colors.black,
  //                             ),
  //                           ),
  //                           SizedBox(width: 20.w),
  //                           Text(
  //                             timeago.format(
  //                               widget.comment.createdAt!,
  //                             ),
  //                             style:
  //                                 TextStyle(fontSize: AppSize.textMedium.sp),
  //                           ),
  //                         ],
  //                       ),
  //                       SizedBox(height: 4.h),
  //                       Text(
  //                         widget.comment.content.toString(),
  //                         style: TextStyle(
  //                           fontSize: AppSize.textLarge.sp,
  //                           color: context.isDarkMode
  //                               ? Colors.white
  //                               : Colors.black,
  //                         ),
  //                       ),
  //                       SizedBox(height: 6.h),
  //                       mediaUrls.isEmpty
  //                           ? SizedBox()
  //                           : SizedBox(
  //                               height: AppSize.imageLarge.h,
  //                               width: AppSize.imageLarge.w,
  //                               child: Container(
  //                                   decoration: BoxDecoration(
  //                                     color: Colors.grey.shade100,
  //                                   ),
  //                                   width: MediaQuery.of(context).size.width,
  //                                   margin:
  //                                       EdgeInsets.symmetric(horizontal: 4.0),
  //                                   child: ClipRRect(
  //                                     borderRadius: BorderRadius.circular(10),
  //                                     child: Image.network(mediaUrls[0],
  //                                         fit: BoxFit.cover,
  //                                         errorBuilder: (context, url,
  //                                                 error) =>
  //                                             Icon(
  //                                               Icons.error,
  //                                               color: context.isDarkMode
  //                                                   ? AppColors.primary
  //                                                   : AppColors.background,
  //                                             ),
  //                                         loadingBuilder: (context, child,
  //                                             loadingProgress) {
  //                                           if (loadingProgress == null)
  //                                             return child;
  //                                           return Center(
  //                                             child:
  //                                                 CircularProgressIndicator(),
  //                                           );
  //                                         }),
  //                                   )),
  //                             ),
  //                       SizedBox(
  //                         height: 6.h,
  //                       ),
  //                       Row(
  //                         children: [
  //                           GestureDetector(
  //                               onTap: () async {
  //                                 if (widget.comment.isReacted == true) {
  //                                   await sl<UnReactBlogUseCase>().call(
  //                                       UnReactionParam(
  //                                           id: widget.comment.commentId!,
  //                                           type: 'comment'));
  //                                   setState(() {
  //                                     if (widget.comment.likesCount > 0) {
  //                                       widget.comment.likesCount--;
  //                                     }

  //                                     widget.comment.isReacted = false;
  //                                   });
  //                                 } else {
  //                                   var result = await sl<ReactBlogUseCase>()
  //                                       .call(ReactBlogReq(
  //                                           entityId:
  //                                               widget.comment.commentId,
  //                                           entityType: "comment"));
  //                                   result.fold((error) {
  //                                     error;
  //                                   }, (data) {
  //                                     bool isReact = toogleIsReaction(
  //                                         widget.comment.isReacted);

  //                                     setState(() {
  //                                       widget.comment.likesCount++;
  //                                       widget.comment.isReacted = isReact;
  //                                     });
  //                                   });
  //                                 }
  //                               },
  //                               child: Row(
  //                                 children: [
  //                                   Icon(
  //                                     widget.comment.isReacted
  //                                         ? Icons.favorite
  //                                         : Icons.favorite_border_outlined,
  //                                     color: widget.comment.isReacted
  //                                         ? Colors.red
  //                                         : context.isDarkMode
  //                                             ? Colors.white
  //                                             : Colors.black,
  //                                     size: AppSize.iconSmall.sp,
  //                                   ),
  //                                   BasicTextButton(
  //                                       text: widget.comment.likesCount
  //                                           .toString(),
  //                                       onPress: () {})
  //                                 ],
  //                               )),
  //                           SizedBox(width: 10.w),
  //                           Row(
  //                             children: [
  //                               GestureDetector(
  //                                 onTap: () {
  //                                   widget.onReplyTap();
  //                                   commentInputCubit
  //                                       .updateToReplyComment(widget.comment);
  //                                   if (!_showReplies &&
  //                                       widget.comment.repliesCount > 0) {
  //                                     setState(() {
  //                                       _showReplies = true;
  //                                     });
  //                                     context
  //                                         .read<GenericDataCubit>()
  //                                         .getData<List<ReplyCommentEntity>>(
  //                                             sl<GetReplyCommentUsecase>(),
  //                                             params: GetReplyCommentReq(
  //                                                 commentId: widget
  //                                                     .comment.commentId!,
  //                                                 replyId: 0,
  //                                                 pageSize: 10,
  //                                                 pageNumber: 1));
  //                                   }
  //                                 },
  //                                 child: Image.asset(
  //                                   AppImages.reply,
  //                                   width: AppSize.iconSmall.w,
  //                                   color: context.isDarkMode
  //                                       ? Colors.white
  //                                       : Colors.black,
  //                                 ),
  //                               ),
  //                               SizedBox(width: 10.w),
  //                               BasicTextButton(
  //                                   text: widget.comment.repliesCount
  //                                       .toString(),
  //                                   onPress: () {}),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                       SizedBox(height: 4.h),
  //                       if (widget.comment.repliesCount > 0)
  //                         GestureDetector(
  //                           onTap: () async {
  //                             setState(() {
  //                               _showReplies = !_showReplies;
  //                             });
  //                             if (_showReplies) {
  //                               context
  //                                   .read<GenericDataCubit>()
  //                                   .getData<List<ReplyCommentEntity>>(
  //                                       sl<GetReplyCommentUsecase>(),
  //                                       params: GetReplyCommentReq(
  //                                           commentId:
  //                                               widget.comment.commentId!,
  //                                           replyId: 0,
  //                                           pageSize: 10,
  //                                           pageNumber: 1));
  //                             }
  //                           },
  //                           child: Text(
  //                             _showReplies
  //                                 ? "Hide ${widget.comment.repliesCount} reply"
  //                                 : "Show ${widget.comment.repliesCount} reply",
  //                             style: TextStyle(
  //                               color: context.isDarkMode
  //                                   ? Colors.white
  //                                   : Colors.grey,
  //                               fontSize: AppSize.textMedium.sp,
  //                             ),
  //                           ),
  //                         ),
  //                       if (_showReplies)
  //                         Builder(
  //                           builder: (context) {
  //                             if (state is DataLoading) {
  //                               return Padding(
  //                                 padding:
  //                                     EdgeInsets.symmetric(vertical: 8.h),
  //                                 child: Center(
  //                                     child: CircularProgressIndicator()),
  //                               );
  //                             } else if (state is DataLoaded) {
  //                               final double itemHeight =
  //                                   AppSize.cardHeight.h;
  //                               final double padding =
  //                                   AppSize.apHorizontalPadding.h;
  //                               final double totalHeight =
  //                                   (itemHeight + padding) *
  //                                       state.data.length;

  //                               final double minHeight = 200.h;
  //                               final double maxHeight =
  //                                   MediaQuery.of(context).size.height;
  //                               final double dynamicHeight =
  //                                   totalHeight.clamp(minHeight, maxHeight);
  //                               return SizedBox(
  //                                 width: double.infinity,
  //                                 height: dynamicHeight,
  //                                 child: Column(
  //                                   children: List.generate(state.data.length,
  //                                       (index) {
  //                                     return Padding(
  //                                       padding: EdgeInsets.symmetric(
  //                                           horizontal: 6.h, vertical: 2.h),
  //                                       child: ReplyCommentItem(
  //                                           reply: state.data[index]),
  //                                     );
  //                                   }),
  //                                 ),
  //                               );
  //                             } else if (state is FailureLoadData) {
  //                               return Padding(
  //                                 padding:
  //                                     EdgeInsets.symmetric(vertical: 16.h),
  //                                 child: Text(
  //                                   "Can't load Reply! Try Again",
  //                                   style: TextStyle(color: Colors.red),
  //                                 ),
  //                               );
  //                             }
  //                             return Container();
  //                           },
  //                         ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   ),
  // );
}
