import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:tracio_fe/core/services/signalR/implement/group_route_hub_service.dart';
import 'package:tracio_fe/data/map/source/tracking_grpc_service.dart';
import 'package:tracio_fe/domain/groups/entities/group_route_location_update.dart';
import 'package:tracio_fe/presentation/map/bloc/get_direction_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/get_direction_state.dart';
import 'package:tracio_fe/presentation/map/bloc/map_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/tracking_location_bloc.dart';
import 'package:tracio_fe/presentation/map/bloc/tracking_location_event.dart';
import 'package:tracio_fe/service_locator.dart';

class CyclingMapView extends StatefulWidget {
  final int? routeId;
  const CyclingMapView({super.key, required this.routeId});

  @override
  State<CyclingMapView> createState() => _CyclingMapViewState();
}

class _CyclingMapViewState extends State<CyclingMapView> {
  List<mapbox.Position> routePoints = [];
  List<bg.Location> tempRouteList = [];
  bool isMapInitialized = false;

  final groupRouteHub = sl<GroupRouteHubService>();
  GroupRouteLocationUpdateEntity? userLocationUpdate;
  @override
  void initState() {
    super.initState();
    // groupRouteHub.connect().then((_) {
    //   groupRouteHub.joinGroupRoute("24").then((value) {
    //     context.read<MapCubit>().addUserMarker(
    //         id: "23",
    //         imageUrl:
    //             "https://useravatartracio.s3.amazonaws.com/7fcd23fb-742a-46af-8240-5adfa54a452c_avatar%20final.jpg",
    //         position: Position(106.6801295570291, 10.826393191096505));
    //     context.read<MapCubit>().addUserMarker(
    //         id: "24",
    //         imageUrl:
    //             "https://cellphones.com.vn/sforum/wp-content/uploads/2024/02/avatar-anh-meo-cute-5.jpg",
    //         position: Position(106.69974, 10.79315));
    //   });
    // });

    groupRouteHub.onLocationUpdate.listen((data) {
      setState(() {
        userLocationUpdate = data;
      });
      Future.microtask(() {
        context.read<MapCubit>().updateUserMarker(
            id: data.userId.toString(),
            imageUrl: data.profilePicture,
            newPosition: mapbox.Position(data.longitude, data.latitude));
      });
    });
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
              BlocListener<LocationCubit, LocationState>(
                listener: (context, state) {
                  if (state is LocationUpdated) {
                    _updateRoute(state.heading, state.position, mapCubit);
                  }
                },
                child: mapbox.MapWidget(
                  key: const ValueKey("mapWidget"),
                  cameraOptions: mapCubit.camera,
                  onMapCreated: (map) {
                    mapCubit.initializeMap(map, forRiding: true);
                    isMapInitialized = true;
                  },
                ),
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
      tempRouteList.add(position);
    });

    if (routePoints.length > 100) {
      setState(() {
        routePoints.removeAt(0);
      });
    }

    if (widget.routeId != null) {
      if (tempRouteList.length >= 100) {
        final List<Map<String, dynamic>> grpcLocations =
            tempRouteList.asMap().entries.map((entry) {
          final pos = entry.value;
          final dateTime = DateTime.parse(pos.timestamp);
          return {
            "latitude": pos.coords.latitude,
            "longitude": pos.coords.longitude,
            "altitude": pos.coords.altitude,
            "timestamp": dateTime.millisecondsSinceEpoch,
            "speed": pos.coords.speed * 18 / 5,
            "distance": pos.odometer / 1000,
          };
        }).toList();

        final grpc = TrackingGrpcService();
        await grpc.sendLocations(
          routeId: widget.routeId!,
          locations: grpcLocations,
        );

        setState(() {
          tempRouteList.clear();
        });
      }
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
