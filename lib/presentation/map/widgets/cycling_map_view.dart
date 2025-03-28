import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:tracio_fe/presentation/map/bloc/get_direction_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/get_direction_state.dart';
import 'package:tracio_fe/presentation/map/bloc/map_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/tracking_location_bloc.dart';
import 'package:tracio_fe/presentation/map/bloc/tracking_location_event.dart';

class CyclingMapView extends StatefulWidget {
  const CyclingMapView({super.key});

  @override
  State<CyclingMapView> createState() => _CyclingMapViewState();
}

class _CyclingMapViewState extends State<CyclingMapView> {
  List<mapbox.Position> routePoints = [];
  bool isMapInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mapCubit = context.read<MapCubit>();

    return Stack(
      children: [
        BlocConsumer<GetDirectionCubit, GetDirectionState>(
            listener: (context, state) async {
          if (state is GetDirectionLoaded) {
            if (context.mounted) {
              //Set order of waypoints
              await mapCubit
                  .addMultiplePointAnnotations(state.direction.waypoints);
              await mapCubit.addPolylineRoute(state.direction.geometry!);
            }
          } else if (state is GetDirectionFailure) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        }, builder: (context, directionState) {
          return Stack(
            children: [
              BlocConsumer<LocationCubit, LocationState>(
                listener: (context, state) {
                  if (state is LocationUpdated) {
                    _updateRoute(state.heading, state.position, mapCubit);
                  }
                },
                builder: (context, state) {
                  return mapbox.MapWidget(
                    key: const ValueKey("mapWidget"),
                    cameraOptions: mapCubit.camera,
                    onMapCreated: (map) {
                      mapCubit.initializeMap(map, forRiding: true);
                      isMapInitialized = true;
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
        }),
      ],
    );
  }

  Future<void> _updateRoute(
      double bearing, bg.Location position, MapCubit mapCubit) async {
    if (!isMapInitialized) return;

    final newPoint =
        mapbox.Position(position.coords.longitude, position.coords.latitude);

    // Add the new point to the route
    setState(() {
      routePoints.add(newPoint);
    });

    if (routePoints.length > 200) {
      setState(() {
        routePoints.removeAt(0);
      });
    }

    if (routePoints.isNotEmpty) {
      final lineString = mapbox.LineString(coordinates: routePoints);
      await mapCubit.addPolylineRoute(lineString);

      mapCubit.mapboxMap?.flyTo(
          mapbox.CameraOptions(
              center: mapbox.Point(coordinates: newPoint), bearing: bearing),
          mapbox.MapAnimationOptions(duration: 300, startDelay: 0));
    }
  }

  @override
  void dispose() {
    context.read<LocationCubit>().stopTracking();
    super.dispose();
  }
}
