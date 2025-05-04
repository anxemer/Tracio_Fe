import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/domain/map/entities/route_blog.dart';
import 'package:tracio_fe/domain/map/entities/route_review.dart';
import 'package:tracio_fe/presentation/library/bloc/reaction/bloc/reaction_bloc.dart';
import 'package:tracio_fe/presentation/library/widgets/detail/route_blog_review_item.dart';
import 'package:tracio_fe/presentation/library/widgets/detail/route_review_input_box.dart';
import 'package:tracio_fe/presentation/map/bloc/route_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/route_state.dart';

class RouteBlogReviews extends StatefulWidget {
  final int routeId;
  final RouteBlogEntity route;
  const RouteBlogReviews(
      {super.key, required this.routeId, required this.route});

  @override
  State<RouteBlogReviews> createState() => _RouteBlogReviewsState();
}

class _RouteBlogReviewsState extends State<RouteBlogReviews> {
  final TextEditingController textEditingController = TextEditingController();

  Future<void> _onRefresh() async {
    await context.read<RouteCubit>().getRouteBlogReviews(widget.routeId);
  }

  void _onSent(XFile? file, int? reviewId, int? replyId, String? userName) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                List<RouteReviewEntity> reviews = state.reviews;

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
                              review: state.reviews[index],
                              replyCount: state.reviews[index].replyCount,
                              onViewMoreReplyTap: (reviewId) async {
                                await context
                                    .read<RouteCubit>()
                                    .getRouteBlogReply(reviewId);
                              },
                              onViewMoreReviewTap: () async {},
                              onReact: () async {},
                              onReply: () async {},
                            );
                          },
                        ),
                      ),
                    ),
                    RouteReviewInputBox(
                      textEditingController: textEditingController,
                      onSent: _onSent,
                    )
                  ],
                );
              } else if (state is GetRouteBlogLoaded && state.reviews.isEmpty) {
                return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (_, __) {
                    return Center(child: Text("No reviews available"));
                  },
                );
              }

              return ListView.builder(
                itemCount: 1,
                itemBuilder: (_, __) {
                  return SizedBox.shrink();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon(IconData icon) {
    return Container(
      color: Colors.grey.shade300,
      child: Icon(icon, color: Colors.white, size: 18.0),
    );
  }
}
