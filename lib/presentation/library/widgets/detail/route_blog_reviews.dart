import 'dart:io';

import 'package:Tracio/data/map/models/request/post_reply_req.dart';
import 'package:Tracio/data/map/models/request/post_review_req.dart';
import 'package:Tracio/domain/map/entities/route_reply.dart';
import 'package:Tracio/domain/map/usecase/route_blog/post_reply_usecase.dart';
import 'package:Tracio/domain/map/usecase/route_blog/post_review_usecase.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/map/entities/route_blog.dart';
import 'package:Tracio/domain/map/entities/route_review.dart';
import 'package:Tracio/presentation/library/bloc/reaction/bloc/reaction_bloc.dart';
import 'package:Tracio/presentation/library/widgets/detail/route_blog_review_item.dart';
import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/map/bloc/route_state.dart';

import '../../../../domain/blog/entites/comment_input_data.dart';
import '../../../../service_locator.dart';
import '../../../blog/bloc/comment/comment_input_cubit.dart';
import '../../../blog/bloc/comment/comment_input_state.dart';
import '../../../blog/widget/comment_input.dart';

class RouteBlogReviews extends StatefulWidget {
  final int routeId;
  final RouteBlogEntity route;
  const RouteBlogReviews(
      {super.key, required this.routeId, required this.route});

  @override
  State<RouteBlogReviews> createState() => _RouteBlogReviewsState();
}

class _RouteBlogReviewsState extends State<RouteBlogReviews> {
  late CommentInputCubit _commentInputCubit;
  List<RouteReviewEntity> reviews = [];
  List<RouteReplyEntity> replis = [];
  final TextEditingController textEditingController = TextEditingController();

  Future<void> _onRefresh() async {
    await context.read<RouteCubit>().getRouteBlogReviews(widget.routeId);
  }

  void _onSent(XFile? file, int? reviewId, int? replyId, String? userName) {}
  @override
  void initState() {
    _onRefresh();
    _commentInputCubit = context.read<CommentInputCubit>();

    super.initState();
  }

  void _handleCommentSubmit(
      String content, List<File> files, CommentInputData inputData) async {
    if (content.isEmpty && files.isEmpty) return;

    switch (inputData.mode) {
      case CommentMode.blogComment:
        var result = await sl<PostReviewUsecase>().call(
          PostReviewReq(routeId: widget.routeId, content: content, file: files),
        );

        result.fold(
          (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Review Fail')),
            );
          },
          (success) {
            setState(() {
              reviews.add(success);
            });
            FocusScope.of(context).unfocus();
          },
        );
        break;

      case CommentMode.replyComment:
        if (inputData.commentId != null) {
          var result = await sl<PostReplyUsecase>().call(PostReplyReq(
              reviewId: inputData.commentId!, content: content, file: files));

          result.fold(
            (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Reply failed')),
              );
            },
            (success) {
              final newReply = RouteReplyEntity(
                cyclistAvatar: success.userAvatar,
                replyId: success.replyId,
                cyclistId: success.cyclistId,
                reviewId: success.commentId,
                cyclistName: success.cyclistName,
                reReplyCyclistName: success.reReplyCyclistName,
                content: success.content,
                isReacted: success.isReacted,
                createdAt: success.createdAt,
                tagUserNames: [],
                mediaUrls: success.mediaUrls,
                likeCount: success.likeCount,
              );
              context
                  .read<RouteCubit>()
                  .addReplyReview(inputData.commentId!, newReply);
              _commentInputCubit.updateToDefaultRoute(widget.routeId);
              FocusScope.of(context).unfocus();
            },
          );
        }
        break;

      case CommentMode.replyToReply:
        if (inputData.commentId != null) {
          var result = await sl<PostReplyUsecase>().call(PostReplyReq(
              reviewId: inputData.commentId!,
              content: content,
              file: files,
              replyId: inputData.replyId));

          result.fold(
            (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Reply comment fail')),
              );
            },
            (success) {
              final newReply = RouteReplyEntity(
                cyclistAvatar: success.userAvatar,
                replyId: success.replyId,
                cyclistId: success.cyclistId,
                reviewId: success.commentId,
                cyclistName: success.cyclistName,
                reReplyCyclistName: success.reReplyCyclistName,
                content: success.content,
                isReacted: success.isReacted,
                createdAt: success.createdAt,
                tagUserNames: [],
                mediaUrls: [],
                likeCount: success.likeCount,
              );
              context
                  .read<RouteCubit>()
                  .addReplyReview(inputData.commentId!, newReply);
              // context.read<GetBlogCubit>().incrementCommentCount(widget.blogId);
              _commentInputCubit.updateToDefaultRoute(widget.routeId);
              FocusScope.of(context).unfocus();
            },
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Reviews"),
        actions: [
          BlocBuilder<RouteCubit, RouteState>(
            builder: (context, state) {
              if (state is GetRouteBlogLoading) {
                return Padding(
                  padding:
                      const EdgeInsets.only(right: AppSize.apHorizontalPadding),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppColors.primary),
                  ),
                );
              }
              return SizedBox();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: BlocBuilder<RouteCubit, RouteState>(
            builder: (context, state) {
              if (state is GetRouteBlogFailure) {
                return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (_, __) => Center(
                    child: Text("Error: ${state.errorMessage}"),
                  ),
                );
              }

              if (state is GetRouteBlogLoaded && state.reviews.isNotEmpty) {
                reviews = state.reviews;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 80.h,
                      child: CachedNetworkImage(
                        imageUrl: widget.route.routeThumbnail,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            _buildPlaceholderIcon(Icons.person),
                        errorWidget: (context, url, error) =>
                            _buildPlaceholderIcon(Icons.person),
                      ),
                    ),
                    const SizedBox(
                      height: AppSize.apHorizontalPadding,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.apHorizontalPadding / 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.route.routeName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: AppSize.textExtraLarge * 0.8.sp,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(
                            height: AppSize.apHorizontalPadding / 3,
                          ),
                          Text(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              "${widget.route.cyclistName} • ${widget.route.formatDateTime(widget.route.createdAt)}"),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (widget.route.isReacted) {
                          context
                              .read<ReactionBloc>()
                              .add(UnReactRoute(routeId: widget.route.routeId));
                        } else {
                          context
                              .read<ReactionBloc>()
                              .add(ReactRoute(routeId: widget.route.routeId));
                        }
                      },
                      icon: Icon(
                        widget.route.isReacted
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: widget.route.isReacted
                            ? Colors.red
                            : Colors.black87,
                        size: AppSize.iconMedium.w,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.apHorizontalPadding / 2),
                        child: ListView.builder(
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            return RouteBlogReviewItem(
                              onCmt: () async {
                                print(state.reviews[index].reviewId);
                                _commentInputCubit
                                    .updateToReplyReview(state.reviews[index]);
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                              review: state.reviews[index],
                              replyCount: state.reviews[index].replyCount,
                              onViewMoreReplyTap: (reviewId) async {
                                await context
                                    .read<RouteCubit>()
                                    .getRouteBlogReply(reviewId);
                              },
                              onViewMoreReviewTap: () async {},
                              onReact: () async {},
                              onReply: (reply) async {
                                _commentInputCubit
                                    .updateToReplyToReplyRoute(reply);
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
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
                              _commentInputCubit
                                  .updateToDefaultRoute(widget.routeId);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else if (state is GetRouteBlogLoaded && state.reviews.isEmpty) {
                return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (_, __) {
                    return Column(
                      children: [
                        _buildRoute(),
                        Center(child: Text("No reviews available")),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: AppSize.apHorizontalPadding,
                              left: 10,
                              right: 10),
                          child:
                              BlocBuilder<CommentInputCubit, CommentInputState>(
                            builder: (context, inputState) {
                              return CommentInputWidget(
                                inputData: inputState.inputData,
                                onSubmit: _handleCommentSubmit,
                                onReset: () {
                                  _commentInputCubit
                                      .updateToDefaultRoute(widget.routeId);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
              }

              return ListView.builder(
                itemCount: 1,
                itemBuilder: (_, __) {
                  return Column(
                    children: [
                      _buildRoute(),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: AppSize.apHorizontalPadding,
                            left: 10,
                            right: 10),
                        child:
                            BlocBuilder<CommentInputCubit, CommentInputState>(
                          builder: (context, inputState) {
                            return CommentInputWidget(
                              inputData: inputState.inputData,
                              onSubmit: _handleCommentSubmit,
                              onReset: () {
                                _commentInputCubit
                                    .updateToDefault(widget.routeId);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRoute() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: 80.h,
          child: CachedNetworkImage(
            imageUrl: widget.route.routeThumbnail,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildPlaceholderIcon(Icons.person),
            errorWidget: (context, url, error) =>
                _buildPlaceholderIcon(Icons.person),
          ),
        ),
        const SizedBox(
          height: AppSize.apHorizontalPadding,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.apHorizontalPadding / 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.route.routeName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: AppSize.textExtraLarge * 0.8.sp,
                      fontWeight: FontWeight.w600)),
              const SizedBox(
                height: AppSize.apHorizontalPadding / 3,
              ),
              Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  "${widget.route.cyclistName} • ${widget.route.formatDateTime(widget.route.createdAt)}"),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            if (widget.route.isReacted) {
              context
                  .read<ReactionBloc>()
                  .add(UnReactRoute(routeId: widget.route.routeId));
            } else {
              context
                  .read<ReactionBloc>()
                  .add(ReactRoute(routeId: widget.route.routeId));
            }
          },
          icon: Icon(
            widget.route.isReacted ? Icons.favorite : Icons.favorite_border,
            color: widget.route.isReacted ? Colors.red : Colors.black87,
            size: AppSize.iconMedium.w,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderIcon(IconData icon) {
    return Container(
      color: Colors.grey.shade300,
      child: Icon(icon, color: Colors.white, size: 18.0),
    );
  }
}
