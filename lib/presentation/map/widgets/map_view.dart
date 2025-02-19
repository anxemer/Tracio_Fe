import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:tracio_fe/core/configs/utils/color_utils.dart';
import 'package:tracio_fe/core/configs/utils/location_tracking.dart';
import 'package:tracio_fe/presentation/map/bloc/map_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/map_state.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LocationTracking locationTracking = LocationTracking();
  StreamSubscription? userPositionStream;
  Dio dio = Dio();

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
    return BlocConsumer<MapCubit, MapCubitState>(
      listener: (context, state) {
        if (state is MapCubitRouteLoaded) {
          _addPolylineRouteToMap(state.lineString, context);
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
            // mapCubit.fetchRoute();
          },
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
        BlocProvider.of<MapCubit>(context).cameraAnimation(
          mapbox.Position(position.longitude, position.latitude),
        );
      }
    });
  }

  Future<void> _addPolylineRouteToMap(
      mapbox.LineString lineString, BuildContext context) async {
    final mapCubit = BlocProvider.of<MapCubit>(context);
    // Add the route to the map
    final polylineAnnotationManager =
        await mapCubit.mapboxMap?.annotations.createPolylineAnnotationManager();
    mapbox.PolylineAnnotationOptions? polylineAnnotationOptions;

    polylineAnnotationOptions = mapbox.PolylineAnnotationOptions(
        geometry: lineString,
        lineJoin: mapbox.LineJoin.ROUND,
        lineColor: Colors.red.toInt(),
        lineWidth: 6.0);
    // Add the annotation to the map
    polylineAnnotationManager?.create(polylineAnnotationOptions);
  }

  Future<void> _changeMapStyle(String styleUri, BuildContext context) async {
    final mapCubit = BlocProvider.of<MapCubit>(context);
    mapCubit.mapboxMap?.loadStyleURI(styleUri);
  }
}
