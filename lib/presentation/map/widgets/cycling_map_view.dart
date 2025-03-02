import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:tracio_fe/presentation/map/bloc/map_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/map_state.dart';
import 'package:tracio_fe/presentation/map/bloc/tracking_location_bloc.dart';
import 'package:tracio_fe/presentation/map/bloc/tracking_location_event.dart';

class CyclingMapView extends StatefulWidget {
  const CyclingMapView({super.key});

  @override
  State<CyclingMapView> createState() => _CyclingMapViewState();
}

class _CyclingMapViewState extends State<CyclingMapView> {
  StreamSubscription? locationSubscription;

  @override
  void initState() {
    super.initState();
    // Start location tracking when the view initializes
    context.read<LocationBloc>().add(StartLocationTracking());
  }

  @override
  Widget build(BuildContext context) {
    final mapCubit = context.read<MapCubit>();

    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<MapCubit, MapCubitState>(
            builder: (context, state) {
              return mapbox.MapWidget(
                key: const ValueKey("mapWidget"),
                cameraOptions: mapCubit.camera,
                onMapCreated: (map) {
                  mapCubit.initializeMapForRiding(map);
                },
              );
            },
          ),
          Positioned(
            top: 80,
            left: 20,
            child: Card(
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: BlocBuilder<LocationBloc, LocationState>(
                  builder: (context, state) {
                    if (state is LocationUpdated) {
                      // LocationUpdated is emitted by LocationBloc
                      final position = state.position;
                      return Text(
                        "Lat: ${position.latitude}, Lng: ${position.longitude}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      );
                    } else if (state is LocationError) {
                      // Show error message if location fetch fails
                      return Text(
                        "Error: ${state.message}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      );
                    } else {
                      // Show fetching message while location is being fetched
                      return const Text(
                        "Fetching location...",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Stop location tracking when the view is disposed
    context.read<LocationBloc>().add(StopLocationTracking());
    super.dispose();
  }
}
