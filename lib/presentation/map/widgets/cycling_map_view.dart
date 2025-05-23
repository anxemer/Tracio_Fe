import 'dart:async';
import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/map/bloc/route_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:Tracio/common/helper/custom_paint/numbered_circle_painter.dart';
import 'dart:ui' as ui;
import 'package:Tracio/core/services/signalR/implement/group_route_hub_service.dart';
import 'package:Tracio/core/services/signalR/implement/matching_hub_service.dart';
import 'package:Tracio/data/map/source/tracking_grpc_service.dart';
import 'package:Tracio/presentation/map/bloc/get_direction_cubit.dart';
import 'package:Tracio/presentation/map/bloc/get_direction_state.dart';
import 'package:Tracio/presentation/map/bloc/map_cubit.dart';
import 'package:Tracio/presentation/map/bloc/match/cubit/match_request_cubit.dart';
import 'package:Tracio/presentation/map/bloc/tracking/bloc/tracking_bloc.dart';
import 'package:Tracio/presentation/map/widgets/match_request_banner.dart';
import 'package:Tracio/service_locator.dart';

class CyclingMapView extends StatefulWidget {
  const CyclingMapView({super.key});

  @override
  State<CyclingMapView> createState() => _CyclingMapViewState();
}

class _CyclingMapViewState extends State<CyclingMapView>
    with TickerProviderStateMixin {
  List<mapbox.Position> routePoints = [];
  List<Position> tempRouteList = [];
  bool isMapInitialized = false;
  mapbox.Position? _lastDrawnPoint;

  final groupRouteHub = sl<GroupRouteHubService>();
  final matchingHub = sl<MatchingHubService>();

  StreamSubscription? _locationUpdateSub;
  StreamSubscription? _matchedUserUpdateSub;

  @override
  void dispose() {
    _locationUpdateSub?.cancel();
    _matchedUserUpdateSub?.cancel();
    super.dispose();
  }

  Future<ui.Image> _createNumberedImage(int number) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final size = ui.Size(80, 80);
    final painter = NumberedCirclePainter(number);
    painter.paint(canvas, size);

    final picture = recorder.endRecording();
    final image =
        await picture.toImage(size.width.toInt(), size.height.toInt());

    return image;
  }

  Future<Uint8List> _getMarkerBytes(String assetPath) async {
    final ByteData bytes = await rootBundle.load(assetPath);
    return bytes.buffer.asUint8List();
  }

  Future<Uint8List> _getImageDataForOrderedPoint(
      int index, List<dynamic> pointAnnotations) async {
    if (index == 0) {
      // Start point
      return await _getMarkerBytes('assets/images/start-flag.png');
    } else if (index == pointAnnotations.length - 1) {
      // End point
      return await _getMarkerBytes('assets/images/end-flag.png');
    } else {
      // Middle points
      final image = await _createNumberedImage(index + 1);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      return bytes!.buffer.asUint8List();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapCubit = context.read<MapCubit>();
    final trackingState = context.read<TrackingBloc>().state;
    final routeId =
        trackingState is TrackingInProgress ? trackingState.routeId : null;
    return Stack(
      children: [
        BlocListener<RouteCubit, RouteState>(
          listener: (context, state) {
            if (state is UpdateRouteLoadingProgress) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    dismissDirection: DismissDirection.up,
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height - 100,
                      left: 10,
                      right: 10,
                    ),
                    content: Text(state.statusMessage),
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 6,
                    duration: const Duration(days: 1),
                  ),
                );
              }
            }

            if (state is UpdateRouteLoaded) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  dismissDirection: DismissDirection.up,
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height - 100,
                    left: 10,
                    right: 10,
                  ),
                  content: Text(state.successMessage),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 6,
                  duration: const Duration(seconds: 2),
                ),
              );
            }

            if (state is UpdateRouteFailure) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  dismissDirection: DismissDirection.up,
                  content: Text("❌ ${state.errorMessage}"),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height - 100,
                    left: 10,
                    right: 10,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 6,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
          child: BlocConsumer<GetDirectionCubit, GetDirectionState>(
              listener: (context, state) async {
            if (state is GetDirectionLoaded) {
              if (context.mounted) {
                // Set order of waypoints
                for (var waypoint in state.direction.geometry!.coordinates) {
                  var imageData = await _getImageDataForOrderedPoint(
                    state.direction.geometry!.coordinates.indexOf(waypoint),
                    state.direction.geometry!.coordinates,
                  );
                  await mapCubit.addPointAnnotation(waypoint, imageData);
                }

                // After adding all points, add polyline
                await mapCubit.addPolylineRoute(state.direction.geometry!);
              }
            } else if (state is GetDirectionFailure) {
              // Show error message
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage)),
                );
              }
            }
          }, builder: (context, directionState) {
            return Stack(
              fit: StackFit.expand,
              children: [
                BlocListener<TrackingBloc, TrackingState>(
                  listener: (context, state) async {
                    if (state is TrackingInProgress &&
                        !state.isPaused &&
                        state.position != null) {
                      final location = state.position!;
                      final newPoint = mapbox.Position(
                        location.longitude,
                        location.latitude,
                      );
                      mapCubit.mapboxMap?.flyTo(
                        mapbox.CameraOptions(
                          center: mapbox.Point(coordinates: newPoint),
                          bearing: location.heading,
                        ),
                        mapbox.MapAnimationOptions(
                            duration: 100, startDelay: 0),
                      );

                      if (_lastDrawnPoint != null) {
                        final segment = mapbox.LineString(coordinates: [
                          _lastDrawnPoint!,
                          newPoint,
                        ]);
                        await mapCubit.addPolylineRoute(segment,
                            lineOpacity: 1);
                      }

                      _lastDrawnPoint = newPoint;

                      setState(() {
                        tempRouteList.add(location);
                      });
                      if (routeId != null && tempRouteList.length >= 20) {
                        final grpcLocations = tempRouteList.map((pos) {
                          final dateTime = pos.timestamp;
                          return {
                            "latitude": pos.latitude,
                            "longitude": pos.longitude,
                            "altitude": pos.altitude,
                            "timestamp": dateTime.millisecondsSinceEpoch,
                            "speed": pos.speed * 18 / 5,
                            "distance": state.odometerKm,
                          };
                        }).toList();

                        unawaited(sl<ITrackingGrpcService>().sendLocations(
                          routeId: routeId,
                          locations: grpcLocations,
                        ));

                        setState(() => tempRouteList.clear());
                      }
                    }
                  },
                  child: mapbox.MapWidget(
                    key: const ValueKey("mapWidget"),
                    cameraOptions: mapCubit.camera,
                    onMapCreated: (map) async {
                      mapCubit.initializeMap(map,
                          locationSetting: mapbox.LocationComponentSettings(
                            enabled: true,
                            showAccuracyRing: true,
                            puckBearingEnabled: true,
                          ));

                      isMapInitialized = true;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _locationUpdateSub =
                            groupRouteHub.onLocationUpdate.listen((data) async {
                          await context.read<MapCubit>().updateUserMarker(
                                id: data.userId.toString(),
                                imageUrl: data.profilePicture,
                                newPosition: mapbox.Position(
                                    data.longitude, data.latitude),
                              );
                        });
                      });
                      _matchedUserUpdateSub =
                          matchingHub.onUpdatedMatchedUser.listen((data) async {
                        if (!mounted) return;

                        try {
                          context
                              .read<TrackingBloc>()
                              .add(AddMatchedUser(data));
                          await context.read<MapCubit>().updateUserMarker(
                                id: data.userId.toString(),
                                imageUrl: data.avatar,
                                newPosition: mapbox.Position(
                                    data.longitude, data.latitude),
                              );
                        } catch (e, stack) {
                          debugPrint(
                              "❌ Error updating marker for user ${data.userId}: $e\n$stack");
                        }
                      });
                    },
                  ),
                ),
                BlocBuilder<MatchRequestCubit, MatchRequestState>(
                  builder: (context, state) {
                    if (state is MatchRequestVisible) {
                      return Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: MatchRequestBanner(
                          userName: state.request.otherUserName,
                          avatar: state.request.otherUserAvatar,
                          onAccept: () =>
                              context.read<MatchRequestCubit>().dismiss(true),
                          onCancel: () =>
                              context.read<MatchRequestCubit>().dismiss(false),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
                if (directionState is GetDirectionLoading ||
                    directionState is GetElevationLoading)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
