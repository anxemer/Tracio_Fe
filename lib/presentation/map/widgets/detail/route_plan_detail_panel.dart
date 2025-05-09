import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/map/bloc/route_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_elevation/map_elevation.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:Tracio/common/widget/drag_handle/drag_handle.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/configs/utils/color_utils.dart';
import 'package:Tracio/presentation/map/bloc/get_direction_cubit.dart';
import 'package:Tracio/presentation/map/bloc/get_direction_state.dart';
import 'package:Tracio/presentation/map/bloc/map_cubit.dart';

class RoutePlanDetailPanel extends StatefulWidget {
  final ScrollController scrollController;

  const RoutePlanDetailPanel({super.key, required this.scrollController});

  @override
  State<RoutePlanDetailPanel> createState() => _RoutePlanDetailPanelState();
}

class _RoutePlanDetailPanelState extends State<RoutePlanDetailPanel> {
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
        if (state is GetElevationLoaded) {
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
            SizedBox(
              height: 10,
            ),
            _buildRouteInformation(),
            _buildElevationChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteInformation() {
    return BlocBuilder<RouteCubit, RouteState>(
      builder: (context, state) {
        if (state is GetRouteDetailLoaded) {
          final route = state.route;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 100,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  route.routeName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoItem(Icons.timeline,
                        "${route.totalDistance.toStringAsFixed(1)} km"),
                    const SizedBox(width: 12),
                    _buildInfoItem(Icons.terrain,
                        "${route.totalElevationGain.toStringAsFixed(0)} m"),
                    const SizedBox(width: 12),
                  ],
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
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
}
