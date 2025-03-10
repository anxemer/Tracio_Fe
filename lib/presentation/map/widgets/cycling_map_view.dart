import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:geolocator/geolocator.dart' as geolocator;
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
    context.read<LocationBloc>().add(StartLocationTracking());
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
      double bearing, geolocator.Position position, MapCubit mapCubit) async {
    if (!isMapInitialized) return; // Ensure map is initialized

    final newPoint = mapbox.Position(position.longitude, position.latitude);

    setState(() {
      routePoints.add(newPoint);
    });

    // Smooth the path
    final smoothedRoutePoints = _smoothPath(routePoints, 8);

    final lineString = mapbox.LineString(coordinates: smoothedRoutePoints);

    await mapCubit.addPolylineRoute(lineString);
    await mapCubit.mapboxMap?.flyTo(
        mapbox.CameraOptions(
            center: mapbox.Point(coordinates: newPoint), bearing: bearing),
        mapbox.MapAnimationOptions(
          duration: 200,
        ));
  }

  List<mapbox.Position> _smoothPath(List<mapbox.Position> points, int factor) {
    List<mapbox.Position> smoothedPoints = [];
    for (int i = 0; i < points.length - 1; i++) {
      mapbox.Position start = points[i];
      mapbox.Position end = points[i + 1];
      smoothedPoints.add(start);

      for (int j = 1; j < factor; j++) {
        double lat = start.lat + (end.lat - start.lat) * (j / factor);
        double lng = start.lng + (end.lng - start.lng) * (j / factor);
        smoothedPoints.add(mapbox.Position(lng, lat));
      }
    }
    smoothedPoints.add(points.last);
    return smoothedPoints;
  }

  @override
  void dispose() {
    context.read<LocationBloc>().add(StopLocationTracking());
    super.dispose();
  }
}
