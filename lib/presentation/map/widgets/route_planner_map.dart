import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:tracio_fe/core/configs/utils/location_tracking.dart';
import 'package:tracio_fe/data/map/models/mapbox_direction_req.dart';
import 'package:tracio_fe/presentation/map/bloc/get_direction_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/get_direction_state.dart';
import 'package:tracio_fe/presentation/map/bloc/map_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/map_state.dart';

class RoutePlannerMap extends StatefulWidget {
  const RoutePlannerMap({super.key});

  @override
  State<RoutePlannerMap> createState() => _RoutePlannerMapState();
}

class _RoutePlannerMapState extends State<RoutePlannerMap> {
  LocationTracking locationTracking = LocationTracking();
  StreamSubscription? userPositionStream;

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

  @override
  Widget build(BuildContext context) {
    final mapCubit = BlocProvider.of<MapCubit>(context);
    final directionCubit = BlocProvider.of<GetDirectionCubit>(context);
    return BlocConsumer<GetDirectionCubit, GetDirectionState>(
      listener: (context, state) async {
        if (state is GetDirectionLoaded) {
          if (context.mounted) {
            //Set order of waypoints
            await mapCubit.addMultiplePointAnnotations(state.direction.waypoints);
            await mapCubit.addPolylineRoute(state.direction.geometry!);
          }
        } else if (state is GetDirectionFailure) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
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
                    await mapCubit.addPointAnnotation(tappedPosition);

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
        // Update camera position using MapCubit
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
