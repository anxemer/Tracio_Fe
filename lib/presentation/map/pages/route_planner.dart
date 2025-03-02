import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tracio_fe/presentation/map/bloc/get_direction_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/get_location_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/map_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/map_state.dart';
import 'package:tracio_fe/presentation/map/bloc/route_cubit.dart';
import 'package:tracio_fe/presentation/map/widgets/route_planner_map.dart';
import 'package:tracio_fe/presentation/map/widgets/route_detail_panel.dart';
import 'package:tracio_fe/presentation/map/widgets/top_action_bar.dart';

class RoutePlanner extends StatefulWidget {
  const RoutePlanner({super.key});

  @override
  State<RoutePlanner> createState() => _RoutePlannerState();
}

class _RoutePlannerState extends State<RoutePlanner> {
  final double _initFabHeight = 160;
  final double _initTopBarTopPosition = 10.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  final double _panelHeightClosed = 120.0;
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
  void initState() {
    super.initState();
    _fabHeight = _initFabHeight;
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = 300;

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
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Bottom: Sliding panel
              SlidingUpPanel(
                maxHeight: _panelHeightOpen,
                minHeight: _panelHeightClosed,
                parallaxEnabled: true,
                parallaxOffset: .5,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                onPanelSlide: (double pos) => setState(() {
                  _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                      _initFabHeight;
                }),
                panelBuilder: (sc) => RouteDetailPanel(scrollController: sc),
                body: const RoutePlannerMap(),
              ),

              // Right: Undo Redo buttons
              Positioned(
                bottom: _fabHeight,
                right: 10,
                child: BlocBuilder<MapCubit, MapCubitState>(
                    builder: (context, state) {
                  return Container(
                    width: 40,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(100),
                        bottom: Radius.circular(100),
                      ),
                    ),
                    child: Column(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.undo,
                            size: 20,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            BlocProvider.of<MapCubit>(context)
                                .removeLastAnnotation();
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.redo,
                            size: 20,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            BlocProvider.of<MapCubit>(context)
                                .clearAnnotations();
                            BlocProvider.of<MapCubit>(context)
                                .polylineAnnotationManager
                                ?.deleteAll();
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ),

              // Left: Configure buttons
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
                top: _initTopBarTopPosition,
                left: 20,
                right: 20,
                child: const TopActionBar(),
              ),
            ],
          ),
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
