import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/widget/blog/picture_card.dart';
import 'package:Tracio/domain/blog/entites/comment_blog.dart';
import 'package:Tracio/domain/blog/entites/reply_comment.dart';
import 'package:Tracio/presentation/blog/bloc/comment/get_comment_cubit.dart';
import 'package:Tracio/presentation/library/bloc/reaction/bloc/reaction_bloc.dart';

import '../../../common/widget/blog/comment/comment.dart';
import '../../../common/widget/blog/comment/comment_tree_widget.dart';
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

  @override
  void initState() {
    timeago.setLocaleMessages('en_short', timeago.EnShortMessages());

    super.initState();
  }

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
                context.isDarkMode,
                mediaUrls,
                null,
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
              List<String> mediaUrls =
                  reply.mediaFiles.map((file) => file.mediaUrl ?? "").toList();
              return _buildComment(
                context.isDarkMode,
                mediaUrls,
                reply.reReplyCyclistName,
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
    bool isDark,
    List<String> imageUrl,
    String? reReplyName,
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
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade200,
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
              RichText(
                  text: TextSpan(
                children: [
                  TextSpan(
                    text: reReplyName == null ? '' : '@$reReplyName ',
                    style: TextStyle(
                        fontSize: AppSize.textLarge.sp,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: comment.content.toString(),
                    style: TextStyle(
                      fontSize: AppSize.textMedium.sp,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              )),
              imageUrl.isNotEmpty
                  ? SizedBox(
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
                            listImageUrl: imageUrl,
                            imageWidth: AppSize.imageLarge.w,
                            imageheight: AppSize.imageLarge.h,
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        // REACTION ROW
        Row(
          children: [
            Text(
              timeago.format(comment.createdAt, locale: 'en_short'),
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
}
