import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/widget/blog/comment/comment.dart';
import 'package:Tracio/common/widget/blog/comment/comment_tree_widget.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/map/entities/route_reply.dart';
import 'package:Tracio/domain/map/entities/route_review.dart';
import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/map/bloc/route_state.dart';

import '../../../../common/widget/blog/picture_card.dart';

class RouteBlogReviewItem extends StatefulWidget {
  final RouteReviewEntity review;
  final int replyCount;
  final Future<void> Function(int) onViewMoreReplyTap;
  final Future<void> Function() onViewMoreReviewTap;
  final Future<void> Function() onReact;
  final Future<void> Function() onCmt;
  final Future<void> Function(RouteReplyEntity) onReply;

  const RouteBlogReviewItem(
      {super.key,
      required this.review,
      required this.replyCount,
      required this.onViewMoreReplyTap,
      required this.onViewMoreReviewTap,
      required this.onReact,
      required this.onReply,
      required this.onCmt});

  @override
  State<RouteBlogReviewItem> createState() => _RouteBlogReviewItemState();
}

class _RouteBlogReviewItemState extends State<RouteBlogReviewItem> {
  void handleReplyTap() async {
    await widget.onViewMoreReplyTap(widget.review.reviewId);
  }

  void handleCommentTab() async {
    await widget.onCmt();
  }

  bool toogleIsReaction(bool isReaction) {
    return !isReaction;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSize.apVerticalPadding),
      child: BlocBuilder<RouteCubit, RouteState>(
        builder: (context, state) {
          if (state is GetRouteBlogLoaded) {
            final review = state.reviews.firstWhere(
                (review) => review.reviewId == widget.review.reviewId);

            final isReplyOpened = review.replyPagination?.replies != null &&
                review.replyPagination!.replies.isNotEmpty;
            return CommentTreeWidget<RouteReviewEntity, RouteReplyEntity?>(
              lineColor: Colors.grey.shade300,
              lineWidth: 2.5,
              comment: widget.review,
              replies: isReplyOpened
                  ? review.replyPagination?.replies ?? []
                  : List.generate(widget.review.replyCount, (_) => null),
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
                        reply?.cyclistAvatar ?? "",
                        Size(16.0 * 2, 16.0 * 2),
                      )
                    : SizedBox.shrink(),
              ),
              commentContent: (context, comment) {
                final isReacted = widget.review.isReacted;
                final likeCount = widget.review.likeCount;

                return _buildComment(
                  onCmt: handleCommentTab,
                  context.isDarkMode,
                  widget.review.mediaUrls,
                  null,
                  comment,
                  isReacted: isReacted,
                  likeCount: likeCount,
                  onReact: () {
                    final isNowReacted = toogleIsReaction(isReacted);
                    setState(() {
                      widget.review.isReacted = isNowReacted;
                      widget.review.likeCount += isNowReacted ? 1 : -1;
                    });

                    // context.read<ReactionBloc>().add(
                    //       isNowReacted
                    //           ? ReactComment(commentId: widget.comment.commentId)
                    //           : UnReactComment(
                    //               commentId: widget.comment.commentId),
                    //     );
                  },
                );
              },
              replyContent: (context, reply) {
                if (!isReplyOpened) {
                  return _buildReplyCount(widget.review.replyCount);
                }

                final isReacted = reply!.isReacted;
                final likeCount = reply.likeCount;
                // List<String> mediaUrls =
                //     reply.mediaUrls.map((file) => file.mediaUrl ?? "").toList();
                return _buildComment(
                  onCmt: () async {
                    await widget.onReply(reply); // truyền đúng reply đang click
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  context.isDarkMode,
                  reply.mediaUrls,
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
                  },
                );
              },
            );
          }
          return SizedBox.shrink();
        },
      ),
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
    required VoidCallback onCmt,
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
                    : Icon(Icons.favorite_border, color: Colors.black),
              ),
            ),
            InkWell(
              onTap: onCmt,
              child: Icon(
                Icons.comment_outlined,
                color: context.isDarkMode ? Colors.white : Colors.black,
                size: AppSize.iconSmall,
              ),
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
