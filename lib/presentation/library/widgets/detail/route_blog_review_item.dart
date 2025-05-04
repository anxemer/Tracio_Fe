import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/widget/blog/comment/comment.dart';
import 'package:tracio_fe/common/widget/blog/comment/comment_tree_widget.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/domain/map/entities/route_reply.dart';
import 'package:tracio_fe/domain/map/entities/route_review.dart';
import 'package:tracio_fe/presentation/map/bloc/route_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/route_state.dart';

class RouteBlogReviewItem extends StatefulWidget {
  final RouteReviewEntity review;
  final int replyCount;
  final Future<void> Function(int) onViewMoreReplyTap;
  final Future<void> Function() onViewMoreReviewTap;
  final Future<void> Function() onReact;
  final Future<void> Function() onReply;

  const RouteBlogReviewItem(
      {super.key,
      required this.review,
      required this.replyCount,
      required this.onViewMoreReplyTap,
      required this.onViewMoreReviewTap,
      required this.onReact,
      required this.onReply});

  @override
  State<RouteBlogReviewItem> createState() => _RouteBlogReviewItemState();
}

class _RouteBlogReviewItemState extends State<RouteBlogReviewItem> {
  void handleReplyTap() async {
    await widget.onViewMoreReplyTap(widget.review.reviewId);
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
              commentContent: (context, comment) => _buildComment(comment),
              replyContent: (context, reply) => !isReplyOpened
                  ? _buildReplyCount(widget.review.replyCount)
                  : _buildComment(reply as RouteReplyEntity),
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

  Widget _buildComment(BaseCommentEntity comment) {
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
              //NAME
              Text(comment.userName,
                  style: TextStyle(
                    fontSize: AppSize.textMedium.sp,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(
                height: 4.0,
              ),
              //COMMENT
              Text(comment.content,
                  style: TextStyle(
                    fontSize: AppSize.textMedium.sp,
                  ))
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        //BUTTON-REACTIONS
        Row(
          spacing: 12,
          children: [
            Text(
              "20h",
              style: TextStyle(color: Colors.grey.shade500),
            ),
            Text(
              widget.review.isReacted ? "Liked" : "Like",
              style: TextStyle(
                  color: widget.review.isReacted
                      ? Colors.blue
                      : Colors.grey.shade500),
            ),
            Text(
              "Reply",
              style: TextStyle(color: Colors.grey.shade500),
            ),
            Spacer(),
            if (comment.likeCount > 0)
              Text(
                "${comment.likeCount} reacts",
                style: TextStyle(color: Colors.grey.shade500),
              ),
          ],
        )
      ],
    );
  }
}
