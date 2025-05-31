import 'dart:async';

import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/map/bloc/route_state.dart';
import 'package:Tracio/presentation/map/widgets/detail/route_detail_top_action_bar.dart';
import 'package:Tracio/presentation/map/widgets/detail/route_plan_detail_map.dart';
import 'package:Tracio/presentation/map/widgets/detail/route_plan_detail_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:Tracio/presentation/map/bloc/get_direction_cubit.dart';
import 'package:Tracio/presentation/map/bloc/get_location_cubit.dart';
import 'package:Tracio/presentation/map/bloc/map_cubit.dart';
import 'package:Tracio/presentation/map/bloc/map_state.dart';
import 'package:Tracio/main.dart';

class RoutePlanDetail extends StatefulWidget {
  final int routeId;
  const RoutePlanDetail({super.key, required this.routeId});

  @override
  State<RoutePlanDetail> createState() => _RoutePlanDetailState();
}

class _RoutePlanDetailState extends State<RoutePlanDetail> with RouteAware {
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
    _fabHeight = _initFabHeight;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    Future.microtask(
        () => context.read<RouteCubit>().getRouteDetail(widget.routeId));
    super.didPopNext();
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
                panelBuilder: (sc) => BlocListener<RouteCubit, RouteState>(
                  listener: (context, state) {
                    if (state is GetRouteDetailLoaded) {
                      context.read<GetDirectionCubit>().getElevation(
                            _getLineString(state.route.polyline),
                          );
                    }
                  },
                  child: RoutePlanDetailPanel(scrollController: sc),
                ),
                body: const RoutePlanDetailMap(),
              ),

              // Right: Undo Redo buttons
              Positioned(
                bottom: _fabHeight,
                right: 10,
                child: BlocBuilder<MapCubit, MapCubitState>(
                    builder: (context, state) {
                  return Container(
                    width: 40,
                    height: 30 * 2 + 20 * 2,
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
                            Icons.add,
                            size: 20,
                            color: Colors.black,
                          ),
                          onPressed: () async {
                            var camera = await context
                                .read<MapCubit>()
                                .mapboxMap
                                ?.getCameraState();

                            context.read<MapCubit>().animateCamera(
                                  camera!.center.coordinates,
                                  zoom: camera.zoom + 1,
                                );
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.minimize_outlined,
                            size: 20,
                            color: Colors.black,
                          ),
                          onPressed: () async {
                            var camera = await context
                                .read<MapCubit>()
                                .mapboxMap
                                ?.getCameraState();

                            context.read<MapCubit>().animateCamera(
                                  camera!.center.coordinates,
                                  zoom: camera.zoom - 1,
                                );
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
                  ],
                ),
              ),

              // Top action bar
              Positioned(
                top: _initTopBarTopPosition,
                left: 20,
                right: 20,
                child: const RouteDetailTopActionBar(),
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
        if (context.mounted) {
          BlocProvider.of<MapCubit>(context).animateCamera(
            mapbox.Position(position.longitude, position.latitude),
          );
        }
      }
    });
  }

  mapbox.LineString _getLineString(String polyline) {
    final decoded = decodePolyline(polyline);
    final coordinates = decoded.map((coord) {
      if (coord.length >= 2) {
        return mapbox.Position(coord[1], coord[0]);
      } else {
        return mapbox.Position(0, 0);
      }
    }).toList();

    return mapbox.LineString(coordinates: coordinates);
  }
}
