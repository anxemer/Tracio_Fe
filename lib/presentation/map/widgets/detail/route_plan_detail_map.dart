import 'dart:async';
import 'dart:typed_data';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/data/map/models/route.dart';
import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/map/bloc/route_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:Tracio/common/helper/custom_paint/numbered_circle_painter.dart';
import 'dart:ui' as ui;
import 'package:Tracio/presentation/map/bloc/get_direction_state.dart';
import 'package:Tracio/presentation/map/bloc/map_cubit.dart';
import 'package:Tracio/presentation/map/bloc/map_state.dart';

class RoutePlanDetailMap extends StatefulWidget {
  const RoutePlanDetailMap({super.key});

  @override
  State<RoutePlanDetailMap> createState() => _RoutePlanDetailMapState();
}

class _RoutePlanDetailMapState extends State<RoutePlanDetailMap> {
  List<mapbox.Position> waypoints = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<ui.Image> _createNumberedImage(int number) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final size = ui.Size(80, 80);
    final painter = NumberedCirclePainter(number);
    painter.paint(canvas, size);

    final picture = recorder.endRecording();
    final image =
        await picture.toImage(size.width.toInt(), size.height.toInt());

    return image;
  }

  Future<Uint8List> _getMarkerBytes(String assetPath) async {
    final ByteData bytes = await rootBundle.load(assetPath);
    return bytes.buffer.asUint8List();
  }

  Future<Uint8List> _getImageDataForOrderedPoint(
      int index, List<dynamic> pointAnnotations) async {
    if (index == 0) {
      // Start point
      return await _getMarkerBytes('assets/images/start-flag.png');
    } else if (index == pointAnnotations.length - 1) {
      // End point
      return await _getMarkerBytes('assets/images/end-flag.png');
    } else {
      // Middle points
      final image = await _createNumberedImage(index + 1);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      return bytes!.buffer.asUint8List();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapCubit = BlocProvider.of<MapCubit>(context);
    return BlocConsumer<RouteCubit, RouteState>(
      listener: (context, state) async {
        if (state is GetRouteDetailLoaded) {
          waypoints.clear();
          if (context.mounted) {
            for (var waypoint in state.route.waypoints) {
              var imageData = await _getImageDataForOrderedPoint(
                state.route.waypoints.indexOf(waypoint),
                state.route.waypoints,
              );
              await mapCubit.addPointAnnotation(
                  mapbox.Position(waypoint.longitude, waypoint.latitude),
                  imageData);
            }

            await context.read<MapCubit>().addPolylineRoute(
                _getLineString(state.route.polyline),
                lineOpacity: 1,
                lineColor: AppColors.primary,
                lineWidth: 6);
            moveToFitOriginDestination(
                state.route.origin, state.route.destination);
          }
        } else if (state is GetRouteDetailFailure) {
          // Show error message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        }
      },
      builder: (context, directionState) {
        return Stack(
          children: [
            BlocConsumer<MapCubit, MapCubitState>(
              listener: (context, state) {
                if (state is MapCubitRouteLoaded) {
                  mapCubit.addPolylineRoute(state.lineString);
                } else if (state is MapCubitStyleLoaded) {
                  _changeMapStyle(state.styleUri, context);
                }
              },
              builder: (context, state) {
                return mapbox.MapWidget(
                  key: const ValueKey("mapWidget"),
                  cameraOptions: mapCubit.camera,
                  onMapCreated: (map) {
                    mapCubit.initializeMap(map);
                  },
                  onTapListener: (tapListenerEvent) async {},
                );
              },
            ),
            // Show loading indicator while fetching directions
            if (directionState is GetDirectionLoading ||
                directionState is GetElevationLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        );
      },
    );
  }

  Future<void> _changeMapStyle(String styleUri, BuildContext context) async {
    final mapCubit = BlocProvider.of<MapCubit>(context);
    mapCubit.mapboxMap?.loadStyleURI(styleUri);
  }

  mapbox.LineString _getLineString(String polyline) {
    final decoded = decodePolyline(polyline);
    final coordinates = decoded.map((coord) {
      if (coord.length >= 2) {
        return mapbox.Position(coord[1], coord[0]);
      } else {
        return mapbox.Position(0, 0);
      }
    }).toList();

    return mapbox.LineString(coordinates: coordinates);
  }

  void moveToFitOriginDestination(GeoPoint origin, GeoPoint destination) {
    final center = mapbox.Position(
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
