import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:Tracio/common/helper/custom_paint/numbered_circle_painter.dart';
import 'dart:ui' as ui;
import 'package:Tracio/core/configs/utils/location_tracking.dart';
import 'package:Tracio/data/map/models/request/mapbox_direction_req.dart';
import 'package:Tracio/presentation/map/bloc/get_direction_cubit.dart';
import 'package:Tracio/presentation/map/bloc/get_direction_state.dart';
import 'package:Tracio/presentation/map/bloc/map_cubit.dart';
import 'package:Tracio/presentation/map/bloc/map_state.dart';

class RoutePlannerMap extends StatefulWidget {
  const RoutePlannerMap({super.key});

  @override
  State<RoutePlannerMap> createState() => _RoutePlannerMapState();
}

class _RoutePlannerMapState extends State<RoutePlannerMap> {
  LocationTracking locationTracking = LocationTracking();
  StreamSubscription? userPositionStream;
  List<mapbox.Position> waypoints = [];

  @override
  void initState() {
    super.initState();
    _setupPositionTracking();
  }

  @override
  void dispose() {
    userPositionStream?.cancel();
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
    final directionCubit = BlocProvider.of<GetDirectionCubit>(context);
    return BlocConsumer<GetDirectionCubit, GetDirectionState>(
      listener: (context, state) async {
        if (state is GetDirectionLoaded) {
          waypoints.clear();
          if (context.mounted) {
            // Set order of waypoints
            for (var waypoint in state.direction.waypoints) {
              var imageData = await _getImageDataForOrderedPoint(
                state.direction.waypoints.indexOf(waypoint),
                state.direction.waypoints,
              );
              await mapCubit.addPointAnnotation(waypoint, imageData);
            }

            // After adding all points, add polyline
            await mapCubit.addPolylineRoute(state.direction.geometry!);
          }
        } else if (state is GetDirectionFailure) {
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
                  onTapListener: (tapListenerEvent) async {
                    final tappedPosition = tapListenerEvent.point.coordinates;
                    setState(() {
                      waypoints.add(tappedPosition);
                    });
                    for (var waypoint in waypoints) {
                      var imageData = await _getImageDataForOrderedPoint(
                          waypoints.indexOf(waypoint), waypoints);
                      await mapCubit.addPointAnnotation(waypoint, imageData);
                    }
                    if (mapCubit.pointAnnotations.length >= 2) {
                      List<Coordinate> coordinates = mapCubit.pointAnnotations
                          .map((annotation) => Coordinate(
                                annotation.geometry.coordinates.lng as double,
                                annotation.geometry.coordinates.lat as double,
                              ))
                          .toList();

                      String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN']!;

                      final request = MapboxDirectionsRequest(
                        profile: 'cycling',
                        coordinates: coordinates,
                        accessToken: accessToken,
                      );
                      //Clear annotations for re-position
                      mapCubit.clearAnnotations();
                      directionCubit.getDirectionUsingMapbox(request);
                    }
                  },
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

  Future<void> _setupPositionTracking() async {
    userPositionStream = await locationTracking.setupPositionTracking();
    geolocator.LocationSettings locationSettings = geolocator.LocationSettings(
      accuracy: geolocator.LocationAccuracy.high,
      distanceFilter: 100,
    );
    userPositionStream?.cancel();
    userPositionStream = geolocator.Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((geolocator.Position? position) {
      if (position != null) {
        if (context.mounted) {
          BlocProvider.of<MapCubit>(context).animateCamera(
            mapbox.Position(position.longitude, position.latitude),
          );
        }
      }
    });
  }

  Future<void> _changeMapStyle(String styleUri, BuildContext context) async {
    final mapCubit = BlocProvider.of<MapCubit>(context);
    mapCubit.mapboxMap?.loadStyleURI(styleUri);
  }
}
