import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_elevation/map_elevation.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:tracio_fe/common/widget/drag_handle/drag_handle.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/data/map/models/request/post_route_req.dart';
import 'package:tracio_fe/presentation/map/bloc/get_direction_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/get_direction_state.dart';
import 'package:tracio_fe/presentation/map/bloc/map_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/map_state.dart';
import 'package:tracio_fe/presentation/map/bloc/route_cubit.dart';
import 'package:tracio_fe/presentation/map/pages/snapshot_display_page.dart';

//TODO: Hover Build Metric session for more detai info
class RouteDetailPanel extends StatefulWidget {
  final ScrollController scrollController;

  const RouteDetailPanel({super.key, required this.scrollController});

  @override
  State<RouteDetailPanel> createState() => _RouteDetailPanelState();
}

class _RouteDetailPanelState extends State<RouteDetailPanel> {
  ElevationPoint? hoverPoint;
  final Distance distance = Distance();
  List<ElevationPoint> elevationPoints = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetDirectionCubit, GetDirectionState>(
      listener: (context, state) async {
        if (state is GetDirectionLoaded) {
          setState(() {
            elevationPoints = state.elevationPoints ?? [];
          });
        }
      },
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: DragHandle(width: 100, height: 6),
            ),
            _buildMetricsSection(),
            _buildElevationChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsSection() {
    return BlocBuilder<GetDirectionCubit, GetDirectionState>(
      builder: (context, state) {
        final mapCubit = context.read<MapCubit>();
        if (state is GetDirectionLoaded) {
          final direction = state.direction;
          double distanceInMiles;
          double estimatedTimeMinutes;
          double averageElevationFeet = 0.0;
          if (hoverPoint != null) {
            final start = LatLng(elevationPoints.first.latitude,
                elevationPoints.first.longitude);
            final end = LatLng(hoverPoint!.latitude, hoverPoint!.longitude);

            distanceInMiles = _calDistanceAsMile(start, end);
            estimatedTimeMinutes = _calculateEstimatedTime(start, end);
            averageElevationFeet = hoverPoint!.altitude;
          } else {
            distanceInMiles = direction.distance * 0.000621371;
            estimatedTimeMinutes = direction.duration / 60;
            if (elevationPoints.isNotEmpty) {
              final totalElevationMeters = elevationPoints
                  .map((e) => e.altitude)
                  .reduce((a, b) => a + b);
              final averageElevationMeters =
                  totalElevationMeters / elevationPoints.length;
              averageElevationFeet = averageElevationMeters * 3.28084;
            }
          }
          return Container(
            height: 110,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _buildMetricColumn(distanceInMiles, "mi"),
                const SizedBox(width: 8),
                const VerticalDivider(color: Colors.black26, thickness: 1),
                const SizedBox(width: 8),
                _buildMetricColumn(averageElevationFeet, "ft"),
                const SizedBox(width: 8),
                const VerticalDivider(color: Colors.black26, thickness: 1),
                const SizedBox(width: 8),
                _buildMetricColumn(estimatedTimeMinutes, "min"),
                const Spacer(),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                        side: BorderSide(color: AppColors.secondBackground),
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.all(
                      AppColors.secondBackground,
                    ),
                  ),
                  onPressed: () async {
                    // Capture the snapshot
                    await mapCubit.getSnapshot(direction.geometry!,
                        direction.waypoints.first, direction.waypoints.last);
                  },
                  child: BlocConsumer<MapCubit, MapCubitState>(
                      listener: (context, state) async {
                    if (state is StaticImageLoaded) {
                      if (context.mounted) {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SnapshotDisplayPage(
                              snapshotImage: mapCubit.snapshotImageUrl!,
                              metricsSection: _buildEmptyMetricsData(),
                            ),
                          ),
                        );
                        if (result is Map<String, dynamic>) {
                          final routeName = result["routeName"] as String?;
                          final routeDescription =
                              result["routeDescription"] as String?;
                          final routePrivacy = result["routePrivacy"] as int?;

                          if (mapCubit.pointAnnotations.isEmpty) return;

                          final origin =
                              _createLocation(mapCubit.pointAnnotations.first);
                          final destination =
                              _createLocation(mapCubit.pointAnnotations.last);
                          final waypoints =
                              _extractWaypoints(mapCubit.pointAnnotations);

                          final request = PostRouteReq(
                            routeName: routeName ?? "New Route",
                            routeDescription: routeDescription,
                            privacy: routePrivacy!,
                            origin: origin,
                            destination: destination,
                            waypoints: waypoints,
                            polylineOverview:
                                _encodePolyline(direction.geometry!),
                            avoidsRoads: ["ferry"],
                            optimize: false,
                            weighting: 2,
                            staticImage: mapCubit.snapshotImageUrl!.toString(),
                          );

                          BlocProvider.of<RouteCubit>(context)
                              .postRoute(request);
                        }
                      }
                    } else if (state is StaticImageFailure) {
                      debugPrint(state.errorMessage);
                    }
                  }, builder: (context, imageState) {
                    if (imageState is StaticImageLoading) {
                      return SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    } else {
                      return Text(
                        "Done",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      );
                    }
                  }),
                )
              ],
            ),
          );
        } else {
          return _buildEmptyMetricsData();
        }
      },
    );
  }

  Container _buildEmptyMetricsData() {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          //Distance as Miles
          _buildMetricColumn(0, "mi"),
          const SizedBox(width: 8),
          const VerticalDivider(color: Colors.black26, thickness: 1),
          const SizedBox(width: 8),
          //Average elevation as ft
          _buildMetricColumn(0, "ft"),
          const SizedBox(width: 8),
          const VerticalDivider(color: Colors.black26, thickness: 1),
          const SizedBox(width: 8),
          //EST time as min
          _buildMetricColumn(0, "est. min"),
          const Spacer(),
          ElevatedButton(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              backgroundColor:
                  WidgetStatePropertyAll<Color>(Colors.grey.shade200),
            ),
            onPressed: () {},
            child: const Text(
              "Done",
              style: TextStyle(color: Colors.black45, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildMetricColumn(double value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value.toStringAsFixed(2), style: const TextStyle(fontSize: 18)),
        Text(unit, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildElevationChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("Elevation chart", style: TextStyle(fontSize: 12)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          height: 130,
          color: Colors.white.withAlpha(6),
          child: elevationPoints.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "No route data available",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                )
              : NotificationListener<ElevationHoverNotification>(
                  onNotification: (ElevationHoverNotification notification) {
                    setState(() {
                      hoverPoint = notification.position;
                    });
                    return true;
                  },
                  child: Elevation(
                    elevationPoints,
                    color: Colors.grey.shade400,
                    elevationGradientColors: ElevationGradientColors(
                      gt10: Colors.green,
                      gt20: Colors.orangeAccent,
                      gt30: Colors.redAccent,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  double _calculateEstimatedTime(LatLng start, LatLng end,
      {double speedKmh = 20.0}) {
    double distanceKm = distance.as(LengthUnit.Kilometer, start, end);
    return speedKmh > 0 ? (distanceKm / speedKmh) * 60 : 0;
  }

  double _calDistanceAsMile(LatLng start, LatLng end) {
    return distance.as(LengthUnit.Mile, start, end);
  }

  String _encodePolyline(LineString lineString) {
    final listNum = lineString.coordinates
        .map((position) => [position.lat, position.lng])
        .toList();

    return encodePolyline(listNum);
  }

  Location _createLocation(PointAnnotationOptions annotation) {
    return Location(
      latitude: annotation.geometry.coordinates.lat.toDouble(),
      longitude: annotation.geometry.coordinates.lng.toDouble(),
    );
  }

  List<Location>? _extractWaypoints(List<PointAnnotationOptions> annotations) {
    return annotations
        .sublist(1, annotations.length - 1)
        .map((annotation) => _createLocation(annotation))
        .toList();
  }
}
