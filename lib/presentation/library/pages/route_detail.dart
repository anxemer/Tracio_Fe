import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:Tracio/common/widget/drag_handle/drag_handle.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/data/map/models/route.dart';
import 'package:Tracio/presentation/library/widgets/detail/elevation_graph.dart';
import 'package:Tracio/presentation/library/widgets/detail/route_detail_information.dart';
import 'package:Tracio/presentation/library/widgets/detail/route_detail_map_view.dart';
import 'package:Tracio/presentation/library/widgets/detail/route_detail_skeleton.dart';
import 'package:Tracio/presentation/library/widgets/detail/speed_graph.dart';
import 'package:Tracio/presentation/map/bloc/map_cubit.dart';
import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/map/bloc/route_state.dart';
import 'package:Tracio/main.dart';
import 'package:Tracio/presentation/library/widgets/detail/route_detail_participants.dart';

class RouteDetailScreen extends StatefulWidget {
  final int routeId;
  const RouteDetailScreen({super.key, required this.routeId});

  @override
  State<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> with RouteAware {
  final double _panelHeightClosed = 110.0;
  double panelHeight = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    Future.microtask(
        () => context.read<RouteCubit>().getRouteDetail(widget.routeId));
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            BlocConsumer<RouteCubit, RouteState>(
              listener: (context, state) async {
                if (state is GetRouteDetailLoaded &&
                    context.read<MapCubit>().mapboxMap != null) {
                  await context.read<MapCubit>().clearAnnotations();
                  //Border
                  await context.read<MapCubit>().addPolylineRoute(
                      _getLineString(state.route.polyline),
                      lineOpacity: 1,
                      lineColor: Colors.white,
                      lineWidth: 6);
                  //Polyline
                  await context.read<MapCubit>().addPolylineRoute(
                      _getLineString(state.route.polyline),
                      lineOpacity: 1,
                      lineColor: AppColors.primary,
                      lineBorderWidth: 0,
                      lineWidth: 4);

                  moveToFitOriginDestination(
                      state.route.origin, state.route.destination);
                }
              },
              builder: (context, state) {
                return SlidingUpPanel(
                  maxHeight: MediaQuery.of(context).size.height,
                  minHeight: _panelHeightClosed,
                  parallaxEnabled: true,
                  parallaxOffset: .3,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  onPanelSlide: (double pos) => setState(() {
                    panelHeight = pos;
                  }),
                  panelBuilder: (sc) => MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: SingleChildScrollView(
                        controller: sc,
                        child: Builder(builder: (_) {
                          if (state is GetRouteDetailLoading) {
                            return RouteDetailSkeletonWidget();
                          }

                          if (state is GetRouteDetailLoaded) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: DragHandle(width: 80, height: 6),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: getDynamicTopMargin(
                                          panelHeight, context)),
                                ),
                                const SizedBox(
                                  height: AppSize.apVerticalPadding,
                                ),
                                RouteDetailInformation(
                                    routeEntity: state.route),
                                RouteDetailParticipants(
                                  routeDetail: state.route,
                                  matchedUsers: state.route.matchedUsers,
                                  participants: state.route.participants,
                                  isOwner: state.route.isOwner,
                                ),
                                Container(
                                  height: 16.h,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(
                                  height: AppSize.apVerticalPadding,
                                ),
                                SpeedGraphWidget(
                                  distances: state.route.distances,
                                  speeds: state.route.speeds,
                                ),
                                Container(
                                  height: 16.h,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(
                                  height: AppSize.apVerticalPadding,
                                ),
                                ElevationGraphWidget(
                                  distances: state.route.distances,
                                  elevationGains: state.route.altitudes,
                                ),
                                const SizedBox(
                                  height: AppSize.apSectionMargin * 3,
                                ),
                              ],
                            );
                          }

                          if (state is GetRouteDetailFailure) {
                            return Center(
                              child: Text(state.errorMessage),
                            );
                          }

                          return SizedBox.shrink();
                        })),
                  ),
                  body: const RouteDetailMapView(),
                );
              },
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSize.apHorizontalPadding / 2,
                    vertical: AppSize.apVerticalPadding / 2),
                decoration: BoxDecoration(
                  color: Colors.white
                      .withValues(alpha: panelHeight.clamp(0.0, 1.0)),
                ),
                child: Row(
                  children: [
                    // Back button
                    Container(
                      width: 40.w,
                      height: 40.w,
                      margin: EdgeInsets.only(
                          right: 12 * panelHeight.clamp(0.0, 1.0)),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: IconButton(
                          padding: EdgeInsets.all(2),
                          color: Colors.black,
                          iconSize: AppSize.iconMedium * 0.8.w,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios_sharp)),
                    ),
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
                      opacity: panelHeight.clamp(0.0, 1.0),
                      child: Text(
                        "Back",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Spacer(),
                    // Save route button
                    Container(
                      height: 40.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            enableFeedback: false,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    12.0 * (1 - panelHeight.clamp(0.0, 1.0)))),
                        child: Row(
                          children: [
                            Icon(
                              Icons.bookmark_add_outlined,
                              size: AppSize.iconMedium * 0.8.w,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            SizedBox(
                              width: 80.w * (1 - panelHeight.clamp(0.0, 1.0)),
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 100),
                                opacity: (1 - panelHeight.clamp(0.0, 1.0)),
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.visible,
                                  "Save route",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    // More button
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: IconButton(
                          padding: EdgeInsets.all(2),
                          color: Colors.black,
                          iconSize: AppSize.iconMedium * 0.8.w,
                          onPressed: () {},
                          icon: Icon(Icons.more_vert)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double getDynamicTopMargin(double panelHeight, BuildContext context) {
    final ratio = panelHeight;

    final double dynamicMargin = ratio * AppSize.appBarHeight / 2;

    return dynamicMargin;
  }

  LineString _getLineString(String polyline) {
    final decoded = decodePolyline(polyline);
    final coordinates = decoded.map((coord) {
      if (coord.length >= 2) {
        return Position(coord[1], coord[0]);
      } else {
        return Position(0, 0);
      }
    }).toList();

    return LineString(coordinates: coordinates);
  }

  void moveToFitOriginDestination(GeoPoint origin, GeoPoint destination) {
    final center = Position(
      (origin.longitude + destination.longitude) / 2,
      (origin.latitude + destination.latitude) / 2,
    );

    final latDiff = (origin.latitude - destination.latitude).abs();
    final lonDiff = (origin.longitude - destination.longitude).abs();
    final maxDiff = latDiff > lonDiff ? latDiff : lonDiff;

    double zoom;
    if (maxDiff < 0.005) {
      zoom = 16;
    } else if (maxDiff < 0.01) {
      zoom = 15;
    } else if (maxDiff < 0.02) {
      zoom = 14;
    } else if (maxDiff < 0.05) {
      zoom = 13;
    } else if (maxDiff < 0.1) {
      zoom = 12;
    } else if (maxDiff < 0.2) {
      zoom = 11;
    } else {
      zoom = 10;
    }

    context.read<MapCubit>().animateCamera(center, zoom: zoom);
  }
}
