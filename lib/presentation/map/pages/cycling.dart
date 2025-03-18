import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/data/map/source/tracking_grpc_service.dart';
import 'package:tracio_fe/presentation/map/bloc/get_direction_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/get_location_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/map_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/map_state.dart';
import 'package:tracio_fe/presentation/map/widgets/cycling_map_view.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:tracio_fe/presentation/map/widgets/cycling_top_action_bar.dart';
import 'package:tracio_fe/service_locator.dart';

class CyclingPage extends StatefulWidget {
  const CyclingPage({super.key});

  @override
  State<CyclingPage> createState() => _CyclingPageState();
}

class _CyclingPageState extends State<CyclingPage> {
  final double _fabHeight = 80;
  bool isPaused = false;
  bool isRiding = false; // Indicates if ride is active
  bool showHoldOptions = false; // Show Resume & Finish on long press
  final ITrackingGrpcService trackingService = sl<ITrackingGrpcService>();

  @override
  void dispose() async {
    await trackingService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => MapCubit()),
            BlocProvider(create: (context) => GetDirectionCubit()),
            BlocProvider(create: (context) => GetLocationCubit()),
          ],
          child: Stack(
            children: [
              /// Map View
              const CyclingMapView(),

              /// Center Camera Button
              Positioned(
                bottom: _fabHeight,
                left: 10,
                child: BlocBuilder<MapCubit, MapCubitState>(
                  builder: (context, state) {
                    return IconButton(
                      style: IconButton.styleFrom(
                        elevation: 2,
                        backgroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.location_searching_outlined, color: Colors.black87),
                      onPressed: () async {
                        _centerCameraButton(context);
                      },
                    );
                  },
                ),
              ),

              /// **Bottom UI (Start / Pause Button & Metrics)**
              Positioned(
                bottom: 10,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      /// **Metrics (Above Pause Button)**
                      if (isRiding && !showHoldOptions)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildMetricTile("Distance", "0.0 km"),
                              _buildMetricTile("Duration", "00:00:00"),
                              _buildMetricTile("Elevation", "0 m"),
                              _buildMetricTile("Speed", "0 km/h"),
                            ],
                          ),
                        ),

                      /// **Pause Button with Gesture Detection**
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: showHoldOptions
                            ? _resumeFinishButtons()
                            : _pausePlayButton(),
                      ),
                    ],
                  ),
                ),
              ),

              /// **Top Action Bar**
              Positioned(
                top: 10,
                right: 20,
                child: const CyclingTopActionBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// **Helper: Metric Tile**
  Widget _buildMetricTile(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  /// **Pause/Start Button**
  Widget _pausePlayButton() {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          showHoldOptions = true;
        });
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            isRiding ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () {
            setState(() {
              isRiding = true;
              isPaused = !isPaused;
            });
          },
        ),
      ),
    );
  }

  /// **Resume & Finish Buttons**
  Widget _resumeFinishButtons() {
    return Container(
      width: 250,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _textButton("Resume", () {
            setState(() {
              showHoldOptions = false;
              isPaused = false;
            });
          }),
          _textButton("Finish Ride", () {
            setState(() {
              isPaused = false;
              isRiding = false;
              showHoldOptions = false;
            });
          }),
        ],
      ),
    );
  }

  /// **Helper: Text Button**
  Widget _textButton(String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
    );
  }

  /// **Function: Center Camera on Current Position**
  Future<void> _centerCameraButton(BuildContext context) async {
    geolocator.LocationSettings locationSettings = const geolocator.LocationSettings(
      accuracy: geolocator.LocationAccuracy.high,
      distanceFilter: 100,
    );
    await geolocator.Geolocator.getCurrentPosition(locationSettings: locationSettings)
        .then((geolocator.Position? position) {
      if (position != null && context.mounted) {
        BlocProvider.of<MapCubit>(context).animateCamera(
          mapbox.Position(position.longitude, position.latitude),
        );
      }
    });
  }
}
