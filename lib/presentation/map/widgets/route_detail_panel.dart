import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_elevation/map_elevation.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:Tracio/common/widget/drag_handle/drag_handle.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/configs/utils/color_utils.dart';
import 'package:Tracio/data/map/models/request/post_route_req.dart';
import 'package:Tracio/presentation/map/bloc/get_direction_cubit.dart';
import 'package:Tracio/presentation/map/bloc/get_direction_state.dart';
import 'package:Tracio/presentation/map/bloc/map_cubit.dart';
import 'package:Tracio/presentation/map/bloc/map_state.dart';
import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/map/pages/snapshot_display_page.dart';

class RouteDetailPanel extends StatefulWidget {
  final ScrollController scrollController;

  const RouteDetailPanel({super.key, required this.scrollController});

  @override
  State<RouteDetailPanel> createState() => _RouteDetailPanelState();
}

class _RouteDetailPanelState extends State<RouteDetailPanel> {
  ElevationPoint? hoverPoint;
  CircleAnnotation? hoverAnnotation;
  final Distance distance = Distance();
  List<ElevationPoint> elevationPoints = [];
  CircleAnnotationManager? circleAnnotationManager;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleHoverUpdate(Position? position) async {
    final mapboxMap = context.read<MapCubit>().mapboxMap;
    if (mapboxMap == null) return;

    circleAnnotationManager ??=
        await mapboxMap.annotations.createCircleAnnotationManager();

    if (position == null) {
      if (hoverAnnotation != null) {
        await circleAnnotationManager!.deleteAll();
        hoverAnnotation = null;
      }
      return;
    }

    final point = Point(coordinates: position);

    if (hoverAnnotation == null) {
      final circleOption = CircleAnnotationOptions(
        geometry: point,
        circleRadius: 8.0,
        circleColor: Colors.green.toInt(),
        circleStrokeColor: Colors.white.toInt(),
        circleStrokeWidth: 3.0,
      );

      hoverAnnotation = await circleAnnotationManager!.create(circleOption);
    } else {
      final updated =
          CircleAnnotation(id: hoverAnnotation!.id, geometry: point);
      await circleAnnotationManager!.update(updated);
      hoverAnnotation = updated;
    }
    mapboxMap.flyTo(
        CameraOptions(center: Point(coordinates: position)),
        MapAnimationOptions(
          duration: 0,
        ));
  }

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
          double distanceAsKm;
          double estimatedTimeMinutes;
          double averageElevationFeet = 0.0;
          if (hoverPoint != null) {
            final start = LatLng(elevationPoints.first.latitude,
                elevationPoints.first.longitude);
            final end = LatLng(hoverPoint!.latitude, hoverPoint!.longitude);

            distanceAsKm = _calDistanceAsKm(start, end);
            estimatedTimeMinutes = _calculateEstimatedTime(start, end);
            averageElevationFeet = hoverPoint!.altitude;
          } else {
            distanceAsKm = direction.distance * 0.000621371;
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
                _buildMetricColumn("Distance", distanceAsKm, "km"),
                const SizedBox(width: 8),
                const VerticalDivider(color: Colors.black26, thickness: 1),
                const SizedBox(width: 8),
                _buildMetricColumn("Elev. Gain", averageElevationFeet, "ft"),
                const SizedBox(width: 8),
                const VerticalDivider(color: Colors.black26, thickness: 1),
                const SizedBox(width: 8),
                _buildMetricColumn("Est. Time", estimatedTimeMinutes, "min"),
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
                    await mapCubit.getSnapshot(
                        direction.geometry!,
                        direction.geometry!.coordinates.first,
                        direction.geometry!.coordinates.last);
                  },
                  child: BlocConsumer<MapCubit, MapCubitState>(
                      listener: (context, state) async {
                    if (state is StaticImageLoaded) {
                      if (context.mounted) {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SnapshotDisplayPage(
                              snapshotImage: mapCubit.snapshotImageUrl!,
                              metricsSection: _buildMetricsData(
                                distanceAsKm,
                                estimatedTimeMinutes,
                                averageElevationFeet,
                              ),
                            ),
                          ),
                        );
                        if (result is Map<String, dynamic>) {
                          final routeName = result["routeName"] as String?;
                          final routeDescription =
                              result["routeDescription"] as String?;

                          if (mapCubit.pointAnnotations.isEmpty) return;

                          final origin =
                              _createLocation(mapCubit.pointAnnotations.first);
                          final destination =
                              _createLocation(mapCubit.pointAnnotations.last);
                          final waypoints =
                              _extractWaypoints(mapCubit.pointAnnotations);

                          final request = PostRouteReq(
                            routeName: routeName ?? "New Route",
                            description: routeDescription,
                            origin: origin,
                            destination: destination,
                            waypoints: waypoints,
                            polyline: _encodePolyline(direction.geometry!),
                            routeThumbnail:
                                mapCubit.snapshotImageUrl!.toString(),
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
          _buildMetricColumn("Distance", 0, "km"),
          const SizedBox(width: 8),
          const VerticalDivider(color: Colors.black26, thickness: 1),
          const SizedBox(width: 8),
          //Average elevation as ft
          _buildMetricColumn("Elev. Gain", 0, "ft"),
          const SizedBox(width: 8),
          const VerticalDivider(color: Colors.black26, thickness: 1),
          const SizedBox(width: 8),
          //EST time as min
          _buildMetricColumn("Est. Time", 0, "est. min"),
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

  Container _buildMetricsData(double distanceAsKm, double estimatedTimeMinutes,
      double averageElevationFeet) {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          //Distance as Miles
          _buildMetricColumn("Distance", distanceAsKm, "mi"),
          const SizedBox(width: 8),
          const VerticalDivider(color: Colors.black26, thickness: 1),
          const SizedBox(width: 8),
          //Average elevation as ft
          _buildMetricColumn("Elev. Gain", averageElevationFeet, "ft"),
          const SizedBox(width: 8),
          const VerticalDivider(color: Colors.black26, thickness: 1),
          const SizedBox(width: 8),
          //EST time as min
          _buildMetricColumn("Est. Time", estimatedTimeMinutes, "est. min"),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(String label, double value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        Text(value.toStringAsFixed(2), style: const TextStyle(fontSize: 18)),
        Text(unit, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildElevationChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Text("Elevation chart", style: TextStyle(fontSize: 12)),
              Spacer(),
              Text("Elev. greater than", style: TextStyle(fontSize: 12)),
              SizedBox(width: 4),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.green,
                  border: Border.all(color: Colors.white, width: 1),
                ),
              ),
              Text("10%", style: TextStyle(fontSize: 12)),
              SizedBox(width: 4),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(color: Colors.white, width: 1),
                ),
              ),
              Text("20%", style: TextStyle(fontSize: 12)),
              SizedBox(width: 4),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  border: Border.all(color: Colors.white, width: 1),
                ),
              ),
              Text("30%", style: TextStyle(fontSize: 12)),
            ],
          ),
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
                    _handleHoverUpdate(
                      notification.position != null
                          ? Position(notification.position!.longitude,
                              notification.position!.latitude)
                          : null,
                    );
                    return true;
                  },
                  child: Elevation(
                    elevationPoints,
                    color: AppColors.background,
                    elevationGradientColors: ElevationGradientColors(
                      gt10: Colors.green,
                      gt20: Colors.grey,
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

  double _calDistanceAsKm(LatLng start, LatLng end) {
    return distance.as(LengthUnit.Kilometer, start, end);
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
