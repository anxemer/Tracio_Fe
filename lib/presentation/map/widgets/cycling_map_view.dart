import 'dart:async';
import 'package:Tracio/presentation/map/bloc/map_state.dart';
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
  final bool isCentered;
  final Function(bool) onCenteredChanged;

  const CyclingMapView({
    super.key,
    required this.isCentered,
    required this.onCenteredChanged,
  });

  @override
  State<CyclingMapView> createState() => _CyclingMapViewState();
}

class _CyclingMapViewState extends State<CyclingMapView>
    with TickerProviderStateMixin {
  List<mapbox.Position> routePoints = [];
  List<Position> tempRouteList = [];
  bool isMapInitialized = false;
  mapbox.Position? _lastDrawnPoint;
  static const int _maxRoutePoints = 30;
  int _segmentCounter = 0;
  int _pointsSinceLastSegment = 0;

  final groupRouteHub = sl<GroupRouteHubService>();
  final matchingHub = sl<MatchingHubService>();

  StreamSubscription? _groupParticipantUpdateSub;
  StreamSubscription? _matchedUserUpdateSub;
  StreamSubscription? _currentPositionUpdateSub;

  bool _isCentered = true;

  @override
  void initState() {
    super.initState();
    _startPositionUpdates();
    _isCentered = widget.isCentered;
  }

  @override
  void didUpdateWidget(CyclingMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isCentered != widget.isCentered) {
      setState(() {
        _isCentered = widget.isCentered;
      });
    }
  }

  Future<void> _handleInitialPosition() async {
    try {
      // Try to get cached position first
      final cachedPosition = await Geolocator.getLastKnownPosition();
      if (cachedPosition != null && mounted) {
        // Move map to cached position instantly
        context.read<MapCubit>().mapboxMap?.flyTo(
              mapbox.CameraOptions(
                center: mapbox.Point(
                  coordinates: mapbox.Position(
                    cachedPosition.longitude,
                    cachedPosition.latitude,
                  ),
                ),
                bearing: cachedPosition.heading,
              ),
              mapbox.MapAnimationOptions(
                  duration: 0), // Instant move for cached position
            );
      }
    } catch (e) {
      debugPrint('❌ Error getting cached position: $e');
    }
  }

  void _startPositionUpdates() async {
    // Cancel any existing subscription
    _currentPositionUpdateSub?.cancel();

    // Try to get initial position first
    await _handleInitialPosition();

    // Then start live updates
    _currentPositionUpdateSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      ),
    ).listen(
      _handlePositionUpdate,
      onError: (error) {
        debugPrint('❌ Error in position stream: $error');
      },
    );
  }

  void _handlePositionUpdate(Position position) {
    if (!mounted) return;

    if (_isCentered) {
      context.read<MapCubit>().mapboxMap?.flyTo(
            mapbox.CameraOptions(
              center: mapbox.Point(
                coordinates: mapbox.Position(
                  position.longitude,
                  position.latitude,
                ),
              ),
              bearing: position.heading,
            ),
            mapbox.MapAnimationOptions(
              duration: 200,
              startDelay: 0,
            ),
          );
    }
  }

  void _resetTrackingState() {
    _lastDrawnPoint = null;
    routePoints.clear();
    tempRouteList.clear();
    _pointsSinceLastSegment = 0;
    _segmentCounter = 0;
  }

  @override
  void dispose() {
    _groupParticipantUpdateSub?.cancel();
    _matchedUserUpdateSub?.cancel();
    _currentPositionUpdateSub?.cancel();
    _resetTrackingState();
    context.read<TrackingBloc>().add(ResetTracking());
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

  void _updateRouteLine(List<mapbox.Position> points) async {
    if (points.isEmpty) return;
    final lineString = mapbox.LineString(coordinates: points);
    await context.read<MapCubit>().updateRouteLine(lineString);
  }

  Future<void> _manageRoutePoints(mapbox.Position newPoint) async {
    routePoints.add(newPoint);
    _pointsSinceLastSegment++;

    if (_pointsSinceLastSegment >= _maxRoutePoints) {
      // Extract full segment
      final segmentString =
          mapbox.LineString(coordinates: List.from(routePoints));

      // Add as static segment
      await context.read<MapCubit>().addRouteSegment(
            segmentString,
            'route_segment_${_segmentCounter++}',
            lineWidth: 5.0,
            lineColor: Colors.deepOrange,
            lineOpacity: 1.0,
            lineBorderColor: Colors.white,
            lineBorderWidth: 1.0,
          );

      // Reset: keep only the last point to start a new segment
      routePoints = [routePoints.last];
      _pointsSinceLastSegment = 0;
    }
  }

  void setIsCentered(bool value) {
    setState(() {
      _isCentered = value;
    });
    widget.onCenteredChanged(value);
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
                    if (state is TrackingInProgress) {
                      _currentPositionUpdateSub?.cancel();
                      if (state.isPaused) {
                        _startPositionUpdates();
                        _updateRouteLine(routePoints);
                      } else if (state.position != null) {
                        final location = state.position!;
                        final newPoint = mapbox.Position(
                          location.longitude,
                          location.latitude,
                        );

                        // Add initial line layer if it's the first point
                        if (_lastDrawnPoint == null) {
                          final initialLineString =
                              mapbox.LineString(coordinates: [newPoint]);
                          await mapCubit.addRouteLine(initialLineString,
                              lineWidth: 5.0,
                              lineColor: Colors.deepOrange,
                              lineOpacity: 1.0,
                              lineBorderColor: Colors.white,
                              lineBorderWidth: 1.0);
                        }

                        // Only update camera if map is centered
                        if (_isCentered) {
                          mapCubit.mapboxMap?.flyTo(
                            mapbox.CameraOptions(
                              center: mapbox.Point(
                                coordinates: mapbox.Position(
                                  location.longitude,
                                  location.latitude,
                                ),
                              ),
                              bearing: location.heading,
                            ),
                            mapbox.MapAnimationOptions(
                                duration: 100, startDelay: 0),
                          );
                        }

                        _lastDrawnPoint = newPoint;
                        await _manageRoutePoints(newPoint);
                        _updateRouteLine(routePoints);

                        setState(() {
                          tempRouteList.add(location);
                        });

                        if (routeId != null &&
                            tempRouteList.length >= _maxRoutePoints) {
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

                          setState(() {
                            tempRouteList.clear();
                          });
                        }
                      }
                    } else if (state is TrackingFinished ||
                        state is TrackingInitial) {
                      // When tracking is finished or reset, remove the route line
                      await mapCubit.removeRouteLine();
                      await mapCubit.removeAllRouteSegments();
                      _startPositionUpdates();
                      _resetTrackingState();
                    }
                  },
                  child: Listener(
                    onPointerDown: (_) {
                      if (_isCentered && mounted) {
                        setIsCentered(false);
                      }
                    },
                    child: BlocListener<MapCubit, MapCubitState>(
                      listener: (context, state) {
                        if (state is MapCubitStyleLoaded) {
                          _changeMapStyle(state.styleUri, context);
                        }
                      },
                      child: mapbox.MapWidget(
                        key: const ValueKey("mapWidget"),
                        cameraOptions: mapCubit.camera,
                        onMapCreated: (map) async {
                          await mapCubit.initializeMap(map,
                              locationSetting: mapbox.LocationComponentSettings(
                                enabled: true,
                                showAccuracyRing: true,
                                puckBearingEnabled: true,
                              ),
                              gesturesSetting: mapbox.GesturesSettings(
                                scrollEnabled: true,
                                pitchEnabled: false,
                              ),
                              compassSetting: mapbox.CompassSettings(
                                enabled: false,
                              ),
                              logoSetting: mapbox.LogoSettings(
                                  position:
                                      mapbox.OrnamentPosition.BOTTOM_RIGHT,
                                  marginBottom: 80),
                              attributionSetting: mapbox.AttributionSettings(
                                  position:
                                      mapbox.OrnamentPosition.BOTTOM_RIGHT,
                                  marginRight: 90,
                                  marginBottom: 80));

                          setState(() {
                            isMapInitialized = true;
                          });
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            // Group route location updates
                            _groupParticipantUpdateSub = groupRouteHub
                                .onLocationUpdate
                                .listen((data) async {
                              if (!mounted) return;
                              try {
                                await context.read<MapCubit>().updateUserMarker(
                                      id: data.userId.toString(),
                                      imageUrl: data.profilePicture,
                                      newPosition: mapbox.Position(
                                          data.longitude, data.latitude),
                                    );
                              } catch (e, stack) {
                                debugPrint(
                                    "❌ Error updating group route marker for user ${data.userId}: $e\n$stack");
                              }
                            });

                            // Matched user updates
                            _matchedUserUpdateSub = matchingHub
                                .onUpdatedMatchedUser
                                .listen((data) async {
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
                                    "❌ Error updating matched user marker for user ${data.userId}: $e\n$stack");
                              }
                            });
                          });
                        },
                      ),
                    ),
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

  Future<void> _changeMapStyle(String styleUri, BuildContext context) async {
    final mapCubit = BlocProvider.of<MapCubit>(context);
    mapCubit.mapboxMap?.loadStyleURI(styleUri);
  }
}
