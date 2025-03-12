import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:tracio_fe/presentation/map/bloc/map_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/tracking_location_bloc.dart';
import 'package:tracio_fe/presentation/map/bloc/tracking_location_event.dart';

class CyclingMapView extends StatefulWidget {
  const CyclingMapView({super.key});

  @override
  State<CyclingMapView> createState() => _CyclingMapViewState();
}

class _CyclingMapViewState extends State<CyclingMapView> {
  StreamSubscription? locationSubscription;
  List<mapbox.Position> routePoints = [];
  mapbox.MapboxMap? mapboxMap; // Store the map instance
  bool isMapInitialized = false;

  @override
  void initState() {
    super.initState();
    // context.read<LocationBloc>().add(StartLocationTracking());
  }

  @override
  Widget build(BuildContext context) {
    final mapCubit = context.read<MapCubit>();

    return Scaffold(
      body: Stack(
        children: [
          BlocConsumer<LocationBloc, LocationState>(
            listener: (context, state) {
              if (state is LocationUpdated) {
                print(
                    "Location updated: ${state.position.coords.latitude}, ${state.position.coords.longitude}");
                _updateRoute(state.heading, state.position, mapCubit);
              }
            },
            builder: (context, state) {
              return mapbox.MapWidget(
                key: const ValueKey("mapWidget"),
                cameraOptions: mapCubit.camera,
                onMapCreated: (map) {
                  mapboxMap = map;
                  mapCubit.initializeMap(map, forRiding: true);
                  isMapInitialized = true;
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _updateRoute(
      double bearing, bg.Location position, MapCubit mapCubit) async {
    if (!isMapInitialized) return; // Ensure map is initialized

    final newPoint =
        mapbox.Position(position.coords.longitude, position.coords.latitude);

    setState(() {
      routePoints.add(newPoint);
    });

    final lineString = mapbox.LineString(coordinates: routePoints);

    await mapCubit.addPolylineRoute(lineString);
    await mapCubit.mapboxMap?.flyTo(
        mapbox.CameraOptions(
            center: mapbox.Point(coordinates: newPoint), bearing: bearing),
        mapbox.MapAnimationOptions(
          duration: 200,
        ));
  }

  @override
  void dispose() {
    context.read<LocationBloc>().add(StopLocationTracking());
    super.dispose();
  }
}
