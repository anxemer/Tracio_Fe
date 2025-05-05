import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/domain/map/entities/route_blog.dart';
import 'package:tracio_fe/presentation/library/bloc/reaction/bloc/reaction_bloc.dart';
import 'package:tracio_fe/presentation/library/pages/route_detail.dart';
import 'package:tracio_fe/presentation/library/widgets/detail/route_blog_reviews.dart';
import 'package:tracio_fe/presentation/map/bloc/map_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/route_cubit.dart';

class RouteBlogItem extends StatefulWidget {
  final int routeId;
  final RouteBlogEntity route;
  const RouteBlogItem({
    super.key,
    required this.routeId,
    required this.route,
  });

  @override
  State<RouteBlogItem> createState() => _RouteBlogItemState();
}

class _RouteBlogItemState extends State<RouteBlogItem> {
  bool _avatarError = false;
  bool _avatarLoading = false;
  bool _thumbnailError = false;
  bool _thumbnailLoading = false;
  @override
  void initState() {
    context
        .read<ReactionBloc>()
        .add(InitializeReactionRoute(route: widget.route));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppNavigator.push(
            context,
            BlocProvider(
              create: (context) => MapCubit(),
              child: BlocProvider.value(
                value: context.read<RouteCubit>()
                  ..getRouteDetail(widget.routeId),
                child: RouteDetailScreen(
                  routeId: widget.routeId,
                ),
              ),
            ));
      },
      child: Ink(
        padding: EdgeInsets.symmetric(vertical: AppSize.apVerticalPadding),
        color: Colors.white,
        child: Column(
          children: [
            // HEADER
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: AppSize.apHorizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // USER INFO
                  Row(
                    children: [
                      Ink.image(
                        image: CachedNetworkImageProvider(
                          widget.route.cyclistAvatar,
                          errorListener: (object) {
                            if (mounted) {
                              setState(() {
                                _avatarError = true;
                                _avatarLoading = false;
                              });
                            }
                          },
                        ),
                        fit: BoxFit.cover,
                        width: 32.w,
                        height: 32.w,
                        child: _avatarLoading
                            ? Center(child: CircularProgressIndicator())
                            : _avatarError
                                ? _buildPlaceholderIcon(Icons.person)
                                : _buildPlaceholderIcon(Icons.person),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.route.cyclistName,
                            style: TextStyle(
                                fontSize: AppSize.textMedium.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width -
                                32.w * 2 -
                                AppSize.apHorizontalPadding.w * 3,
                            child: Text(
                              "${widget.route.formatDateTime(widget.route.createdAt)} • ${widget.route.city}",
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  fontSize: AppSize.textSmall.sp,
                                  color: Colors.grey.shade800),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSize.apSectionPadding),
                  // ROUTE NAME + STAT
                  Text(
                    widget.route.routeName.toUpperCase(),
                    style: TextStyle(
                        fontSize: AppSize.textLarge.sp,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: AppSize.apSectionPadding / 3),
                  Row(
                    children: [
                      Column(
                        spacing: AppSize.apSectionPadding / 4,
                        children: [
                          Text("Distance",
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: AppSize.textSmall.sp)),
                          Text(
                            "${widget.route.formattedTotalDistance} km",
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: AppSize.textMedium.sp),
                          )
                        ],
                      ),
                      const SizedBox(width: 12),
                      Column(
                        spacing: AppSize.apSectionPadding / 4,
                        children: [
                          Text("Elevation Gain",
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: AppSize.textSmall.sp)),
                          Text(
                            "${widget.route.formattedTotalElevGain} ft",
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: AppSize.textMedium.sp),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
            // ROUTE IMAGE: Use Ink.image for the thumbnail
            Ink.image(
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250.h,
              image: CachedNetworkImageProvider(widget.route.routeThumbnail,
                  errorListener: (object) {
                if (mounted) {
                  setState(() {
                    _thumbnailError = true;
                    _thumbnailLoading = false;
                  });
                }
              }),
              child: _thumbnailLoading
                  ? Center(child: CircularProgressIndicator())
                  : _thumbnailError
                      ? _buildPlaceholderIcon(Icons.broken_image)
                      : SizedBox.shrink(),
            ),
            // INTERACTION BUTTONS
            Padding(
              padding: EdgeInsets.only(
                  left: AppSize.apHorizontalPadding.w * 2,
                  right: AppSize.apHorizontalPadding.w * 2,
                  top: AppSize.apVerticalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: BlocBuilder<ReactionBloc, ReactionState>(
                      builder: (context, state) {
                        final isReacted =
                            state.reactRoutes.contains(widget.route.routeId);

                        return IconButton(
                          onPressed: () {
                            if (isReacted) {
                              context.read<ReactionBloc>().add(
                                  UnReactRoute(routeId: widget.route.routeId));
                            } else {
                              context.read<ReactionBloc>().add(
                                  ReactRoute(routeId: widget.route.routeId));
                            }
                          },
                          icon: Icon(
                            isReacted ? Icons.favorite : Icons.favorite_border,
                            color: isReacted ? Colors.red : Colors.black87,
                            size: AppSize.iconMedium.w,
                          ),
                        );
                      },
                    ),
                  ),
                  Flexible(
                    child: IconButton(
                      onPressed: () {
                        Future.microtask(() => context
                            .read<RouteCubit>()
                            .getRouteBlogReviews(widget.routeId));
                        AppNavigator.push(
                            context,
                            RouteBlogReviews(
                                routeId: widget.routeId, route: widget.route));
                      },
                      icon: Icon(
                        Icons.comment_outlined,
                        size: AppSize.iconMedium.w,
                      ),
                    ),
                  ),
                  Flexible(
                    child: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          builder: (context) {
                            return DraggableScrollableSheet(
                              expand: false,
                              initialChildSize: 0.9,
                              minChildSize: 0.7,
                              maxChildSize: 0.9,
                              shouldCloseOnMinExtent: true,
                              builder: (context, scrollController) {
                                return Container(
                                  padding: EdgeInsets.only(
                                      left: 16,
                                      top: 8,
                                      right: 16,
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                  ),
                                  child: Column(
                                    children: [
                                      // Handle
                                      Center(
                                        child: Container(
                                          width: 40,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            borderRadius:
                                                BorderRadius.circular(2.5),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Title
                                      Text(
                                        "Send to",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 12),
                                      // Search bar
                                      TextField(
                                        decoration: InputDecoration(
                                          hintText: "Search",
                                          prefixIcon: const Icon(Icons.search),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      // Friend list
                                      Expanded(
                                        child: ListView.builder(
                                          controller: scrollController,
                                          itemCount: 5,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              leading: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  "https://via.placeholder.com/150", // fake avatar
                                                ),
                                              ),
                                              title: Text("Friend Name $index"),
                                              trailing: Checkbox(
                                                value: false,
                                                onChanged: (value) {},
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Write message
                                      TextField(
                                        decoration: InputDecoration(
                                          hintText: "Write a message",
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 4, horizontal: 16),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Send button
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.grey.shade300,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0))),
                                          child: Text(
                                            "Send",
                                            style: TextStyle(
                                                color: Colors.grey.shade500),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.share,
                        size: AppSize.iconMedium.w,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon(IconData icon) {
    return Ink(
      color: Colors.grey.shade300,
      child: Icon(icon, color: Colors.white, size: 18.0),
    );
  }
}
