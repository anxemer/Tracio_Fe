import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_elevation/map_elevation.dart';
import 'package:tracio_fe/common/widget/drag_handle/drag_handle.dart';
import 'package:tracio_fe/presentation/map/bloc/get_direction_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/get_direction_state.dart';

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
          // Once direction is loaded, request elevation data
          await context
              .read<GetDirectionCubit>()
              .getElevation(state.direction.polyLineOverview!);
        } else if (state is GetElevationLoaded) {
          // Update the elevation chart when data is available
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
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.black26, width: 1)),
              ),
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildMetricColumn(
                    hoverPoint?.latLng != null
                        ? _calDistanceAsMile(
                            elevationPoints.first.latLng, hoverPoint!.latLng)
                        : 0,
                    "mi",
                  ),
                  const SizedBox(width: 8),
                  const VerticalDivider(color: Colors.black26, thickness: 1),
                  const SizedBox(width: 8),
                  _buildMetricColumn(hoverPoint?.altitude ?? 0, "ft"),
                  const SizedBox(width: 8),
                  const VerticalDivider(color: Colors.black26, thickness: 1),
                  const SizedBox(width: 8),
                  _buildMetricColumn(
                    hoverPoint?.latLng != null
                        ? _calculateEstimatedTime(
                            elevationPoints.first.latLng, hoverPoint!.latLng)
                        : 0,
                    "est. time",
                  ),
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
            ),
          ),
        ],
      ),
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
    return speedKmh > 0 ? distanceKm / speedKmh : 0;
  }

  double _calDistanceAsMile(LatLng start, LatLng end) {
    return distance.as(LengthUnit.Mile, start, end);
  }

  Column _buildMetricColumn(double value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value.toStringAsFixed(1), style: const TextStyle(fontSize: 18)),
        Text(unit, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
