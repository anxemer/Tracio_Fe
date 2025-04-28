import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/domain/map/entities/route_blog.dart';
import 'package:tracio_fe/domain/map/entities/route_detail.dart';
import 'package:tracio_fe/presentation/library/bloc/reaction/bloc/reaction_bloc.dart';
import 'package:tracio_fe/presentation/library/widgets/detail/route_blog_reviews.dart';
import 'package:tracio_fe/presentation/map/bloc/route_cubit.dart';

class RouteDetailInformation extends StatefulWidget {
  final RouteDetailEntity routeEntity;
  const RouteDetailInformation({super.key, required this.routeEntity});

  @override
  State<RouteDetailInformation> createState() => _RouteDetailInformationState();
}

class _RouteDetailInformationState extends State<RouteDetailInformation> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.apHorizontalPadding),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.w,
                backgroundColor: Colors.grey.shade300,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: widget.routeEntity.cyclistAvatar,
                    fit: BoxFit.cover,
                    width: 50.w,
                    height: 50.w,
                    placeholder: (context, url) =>
                        _buildPlaceholderIcon(Icons.person),
                    errorWidget: (context, url, error) =>
                        _buildPlaceholderIcon(Icons.person),
                  ),
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.routeEntity.cyclistName,
                    style: TextStyle(
                        fontSize: AppSize.textMedium * 1.2.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Text(
                    "${widget.routeEntity.formatDateTime(widget.routeEntity.createdAt)} • ${widget.routeEntity.city ?? ""}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: AppSize.textMedium * 0.8.sp,
                        color: Colors.black87),
                  ),
                ],
              ))
            ],
          ),
          SizedBox(
            height: AppSize.apSectionMargin.h,
          ),
          Text(
            widget.routeEntity.routeName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: AppSize.textMedium * 1.4.sp,
                color: Colors.black87),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(widget.routeEntity.description ?? ""),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 6,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4.h,
                crossAxisSpacing: 4.w,
                childAspectRatio: 3,
              ),
              itemBuilder: (context, index) {
                final stats = [
                  {
                    "label": "Distance",
                    "value": "${widget.routeEntity.totalDistance} km"
                  },
                  {
                    "label": "Elevation Gain",
                    "value": "${widget.routeEntity.totalElevationGain} m"
                  },
                  {
                    "label": "Moving Time",
                    "value": _formatDuration(widget.routeEntity.totalDuration)
                  },
                  {
                    "label": "Avg Speed",
                    "value": "${widget.routeEntity.avgSpeed} km/h"
                  },
                  {
                    "label": "Max Elevation",
                    "value": "${widget.routeEntity.highestElevation} m"
                  },
                  {
                    "label": "Max Speed",
                    "value": "${widget.routeEntity.maxSpeed} km/h"
                  },
                ];
                final item = stats[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item["label"]!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      item["value"]!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(
            height: AppSize.apVerticalPadding,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: BlocBuilder<ReactionBloc, ReactionState>(
                  builder: (context, state) {
                    final isReacted =
                        state.reactRoutes.contains(widget.routeEntity.routeId);

                    return IconButton(
                      onPressed: () {
                        if (isReacted) {
                          context.read<ReactionBloc>().add(UnReactRoute(
                              routeId: widget.routeEntity.routeId));
                        } else {
                          context.read<ReactionBloc>().add(
                              ReactRoute(routeId: widget.routeEntity.routeId));
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
                        .getRouteBlogReviews(widget.routeEntity.routeId));
                    AppNavigator.push(
                        context,
                        RouteBlogReviews(
                            routeId: widget.routeEntity.routeId,
                            route: _mapToRouteBlog(widget.routeEntity)));
                  },
                  icon: Icon(
                    Icons.comment_outlined,
                    size: AppSize.iconMedium.w,
                  ),
                ),
              ),
              Flexible(
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.share,
                    size: AppSize.iconMedium.w,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: AppSize.apSectionMargin,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderIcon(IconData icon) {
    return Container(
      color: Colors.grey.shade300,
      child: Icon(icon, color: Colors.white, size: 18.0),
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final secs = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  RouteBlogEntity _mapToRouteBlog(RouteDetailEntity routeDetail) {
    return RouteBlogEntity(
        routeId: routeDetail.routeId,
        cyclistId: routeDetail.cyclistId,
        cyclistName: routeDetail.cyclistName,
        cyclistAvatar: routeDetail.cyclistAvatar,
        routeName: routeDetail.routeName,
        routeThumbnail: routeDetail.routeThumbnail,
        description: routeDetail.description,
        city: routeDetail.city,
        totalDistance: routeDetail.totalDistance,
        totalElevationGain: routeDetail.totalElevationGain,
        totalDuration: routeDetail.totalDuration,
        avgSpeed: routeDetail.avgSpeed,
        mood: routeDetail.mood,
        isPublic: true,
        isPlanned: routeDetail.isPlanned,
        isReacted: false,
        createdAt: routeDetail.createdAt,
        updatedAt: routeDetail.updatedAt);
  }
}
