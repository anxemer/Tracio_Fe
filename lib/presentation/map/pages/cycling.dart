import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/presentation/map/bloc/get_direction_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/get_location_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/map_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/map_state.dart';
import 'package:tracio_fe/presentation/map/bloc/route_cubit.dart';
import 'package:tracio_fe/presentation/map/widgets/cycling_map_view.dart';
import 'package:tracio_fe/presentation/map/widgets/top_action_bar.dart';
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
  bool isCentered = false;
  List<String> mapStyles = [
    "Mapbox Streets",
    "Mapbox Outdoors",
    "Mapbox Light",
    "Mapbox Dark",
    "Mapbox Satellite",
    "Goong Map",
    "Terrain-v2",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Stack(children: [
            CyclingMapView(),
            Positioned(
              bottom: _fabHeight,
              left: 10,
              child: Column(
                spacing: 10,
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
                  }),

                  // Change style button
                  BlocBuilder<MapCubit, MapCubitState>(
                      builder: (context, state) {
                    return IconButton(
                      style: IconButton.styleFrom(
                        elevation: 2,
                        backgroundColor: Colors.white,
                        alignment: Alignment.center,
                        padding: EdgeInsets.zero,
                      ),
                      icon: const Icon(
                        Icons.layers,
                        color: Colors.black87,
                      ),
                      onPressed: () {
                        _showStyleDialog(context);
                      },
                    );
                  }),

                  // Change Cycling button
                  IconButton(
                    style: IconButton.styleFrom(
                      elevation: 2,
                      backgroundColor: Colors.white,
                      alignment: Alignment.center,
                      padding: EdgeInsets.zero,
                    ),
                    icon: const Icon(
                      Icons.directions_bike_sharp,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      // Implement cycling functionality
                    },
                  ),
                ],
              ),
            ),

            // Top action bar
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: const TopActionBar(),
            ),

            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Center(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.secondBackground,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: Text("Start ride",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future<dynamic> _showStyleDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Select Map Style"),
          content: SingleChildScrollView(
            child: ListBody(
              children: mapStyles.map((style) {
                return ListTile(
                  title: Text(style),
                  onTap: () {
                    BlocProvider.of<MapCubit>(context).changeMapStyle(style);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
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
          BlocProvider.of<MapCubit>(context).cameraAnimation(
            mapbox.Position(position.longitude, position.latitude),
          );
        }
      }
    });
  }
}
