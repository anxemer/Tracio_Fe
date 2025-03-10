import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/presentation/map/bloc/get_direction_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/get_location_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/map_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/map_state.dart';
import 'package:tracio_fe/presentation/map/bloc/route_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/tracking_location_bloc.dart';
import 'package:tracio_fe/presentation/map/bloc/tracking_location_event.dart';
import 'package:tracio_fe/presentation/map/widgets/cycling_map_view.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

class CyclingPage extends StatefulWidget {
  const CyclingPage({super.key});

  @override
  State<CyclingPage> createState() => _CyclingPageState();
}

class _CyclingPageState extends State<CyclingPage> {
  final double _fabHeight = 80;
  bool isPaused = false; // State to track if cycling is paused

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => MapCubit()),
            BlocProvider(
              create: (context) => GetDirectionCubit(),
            ),
            BlocProvider(
              create: (context) => GetLocationCubit(),
            ),
            BlocProvider(
              create: (context) => RouteCubit(),
            ),
          ],
          child: Stack(
            children: [
              CyclingMapView(),
              Positioned(
                bottom: _fabHeight,
                left: 10,
                child: Column(
                  children: [
                    // Center camera button
                    BlocBuilder<MapCubit, MapCubitState>(
                      builder: (context, state) {
                        return IconButton(
                          style: IconButton.styleFrom(
                            elevation: 2,
                            backgroundColor: Colors.white,
                            alignment: Alignment.center,
                            padding: EdgeInsets.zero,
                          ),
                          icon: Icon(
                            Icons.location_searching_outlined,
                            color: Colors.black87,
                          ),
                          onPressed: () async {
                            _centerCameraButton(context);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                left: MediaQuery.of(context).size.width / 2 -
                    40, // Center the button
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isPaused = !isPaused;
                    });
                    // Add logic to pause or start tracking
                    if (isPaused) {
                      // Pause logic
                      context.read<LocationBloc>().add(PauseLocationTracking());
                    } else {
                      // Start logic
                      context.read<LocationBloc>().add(StartLocationTracking());
                    }
                  },
                  child: Text(isPaused ? "Start" : "Pause"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _centerCameraButton(BuildContext context) async {
    geolocator.LocationSettings locationSettings = geolocator.LocationSettings(
      accuracy: geolocator.LocationAccuracy.high,
      distanceFilter: 100,
    );
    await geolocator.Geolocator.getCurrentPosition(
            locationSettings: locationSettings)
        .then((geolocator.Position? position) {
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
}
