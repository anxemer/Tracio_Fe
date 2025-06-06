import 'package:Tracio/presentation/map/widgets/cycling_tracking_drawer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mp;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/core/services/signalR/implement/group_route_hub_service.dart';
import 'package:Tracio/core/services/signalR/implement/matching_hub_service.dart';
import 'package:Tracio/presentation/map/bloc/get_direction_cubit.dart';
import 'package:Tracio/presentation/map/bloc/get_location_cubit.dart';
import 'package:Tracio/presentation/map/bloc/map_cubit.dart';
import 'package:Tracio/presentation/map/bloc/match/cubit/match_request_cubit.dart';
import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/map/bloc/tracking/bloc/tracking_bloc.dart';
import 'package:Tracio/presentation/map/pages/cycling_snapshot_display.dart';
import 'package:Tracio/presentation/map/widgets/cycling_lock_screen_button.dart';
import 'package:Tracio/presentation/map/widgets/cycling_map_view.dart';
import 'package:Tracio/presentation/map/widgets/cycling_metric_carousel.dart';
import 'package:Tracio/presentation/map/widgets/cycling_take_picture_button.dart';
import 'package:Tracio/presentation/map/widgets/cycling_top_action_bar.dart';
import 'package:Tracio/presentation/map/widgets/slide_to_unlock.dart';
import 'package:Tracio/service_locator.dart';
import 'package:Tracio/presentation/map/widgets/cycling_recenter_button.dart';
import 'package:Tracio/presentation/map/widgets/group_ride_status.dart';

class CyclingPage extends StatefulWidget {
  const CyclingPage({super.key});

  @override
  State<CyclingPage> createState() => _CyclingPageState();
}

class _CyclingPageState extends State<CyclingPage> {
  final double _fabHeightStart = 150;
  final double _fabHeightTracking = 200;
  final double _fabHeightLocked = 180;
  final double _fabHeightInit = 20;

  bool showHoldOptions = false;
  bool isLocked = false;
  double _currentFabHeight = 60; // Initial state

  CarouselSliderController carouselController = CarouselSliderController();
  bool _isCentered = true;

  void _updateFabHeight() {
    setState(() {
      if (showHoldOptions) {
        _currentFabHeight = _fabHeightStart;
      } else if (isLocked) {
        _currentFabHeight = _fabHeightLocked;
      } else {
        _currentFabHeight = _fabHeightTracking;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _currentFabHeight = _fabHeightInit + 40;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<TrackingBloc>().state;
      if (state is TrackingInProgress) {
        setState(() {
          showHoldOptions = state.isPaused;
          _updateFabHeight();
        });
      }
    });
  }

  void _onStartPressed() async {
    setState(() {
      showHoldOptions = false;
      isLocked = false;
      _updateFabHeight();
    });
    context.read<TrackingBloc>().add(RequestStartTracking());
  }

  _onPausePressed() {
    context.read<TrackingBloc>().add(PauseTracking());
    setState(() {
      showHoldOptions = true;
      _updateFabHeight();
    });
  }

  _onResumePressed() {
    context.read<TrackingBloc>().add(ResumeTracking());
    setState(() {
      showHoldOptions = false;
      _updateFabHeight();
    });
  }

  void _onFinishPressed() async {
    context.read<TrackingBloc>().add(PauseTracking());
    context.read<TrackingBloc>().add(RequestFinishTracking());

    final joinedGroupRoutes = sl<GroupRouteHubService>().joinedGroupRouteIds;
    if (joinedGroupRoutes.isNotEmpty) {
      final groupRouteId = joinedGroupRoutes.first;
      await sl<GroupRouteHubService>().leaveGroupRoute(groupRouteId);
      sl<GroupRouteHubService>().endGroupRouteUpdateStream();
    }

    setState(() {
      showHoldOptions = false;
      isLocked = false;
      _currentFabHeight = _fabHeightInit + 40;
    });
  }

  void _handleCenteredChanged(bool isCentered) {
    setState(() {
      _isCentered = isCentered;
    });
  }

  void _handleRecenterPressed() {
    setState(() {
      _isCentered = true;
    });
  }

  Widget _buildStartButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: Size(
              MediaQuery.of(context).size.width * 0.8, AppSize.buttonHeight),
          backgroundColor: AppColors.secondBackground,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.buttonRadius))),
      onPressed: () async {
        _onStartPressed();
      },
      child: const Text(
        "Start tracking",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // Build Resume and Finish button (when riding)
  Widget _buildResumeFinishButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width * 0.8,
                  AppSize.buttonHeight),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.buttonRadius),
                  side:
                      BorderSide(width: 1, color: AppColors.secondBackground))),
          onPressed: _onResumePressed,
          child:
              const Text("Resume", style: TextStyle(color: AppColors.primary)),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width * 0.8,
                  AppSize.buttonHeight),
              backgroundColor: AppColors.secondBackground,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.buttonRadius))),
          onPressed: _onFinishPressed,
          child: const Text("Finish", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  // Build the pause button
  Widget _buildPauseButton() {
    return GestureDetector(
      onLongPress: () async {
        _onPausePressed();
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(
            Icons.pause,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white.withValues(alpha: 0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  content: Text(
                    'Press and hold the pause button to pause or finalize your ride',
                    style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: AppSize.textExtraLarge.sp),
                  ),
                );
              },
            );
            await Future.delayed(Duration(milliseconds: 1500));
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  // Helper for floating map control buttons
  Widget _mapControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color iconColor = Colors.black,
    double size = 24,
    double left = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return Positioned(
      left: left > 0 ? left : null,
      right: right > 0 ? right : null,
      bottom: bottom,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(icon, size: size, color: iconColor),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        _onPausePressed();
      },
      child: Scaffold(
        body: SafeArea(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => MapCubit()),
              BlocProvider(create: (context) => GetDirectionCubit()),
              BlocProvider(create: (context) => GetLocationCubit()),
              BlocProvider(
                  create: (context) =>
                      MatchRequestCubit(sl<MatchingHubService>()))
            ],
            child: BlocListener<TrackingBloc, TrackingState>(
              listener: (context, state) {
                if (state is TrackingFinished) {
                  final route = state.route;

                  final decodedPolyline = decodePolyline(route.polyline)
                      .map((coord) => mp.Position(coord[1], coord[0]))
                      .toList();
                  final lineString =
                      mp.LineString(coordinates: decodedPolyline);

                  if (context.mounted) {
                    // Reset state before navigating
                    setState(() {
                      showHoldOptions = false;
                      isLocked = false;
                      _currentFabHeight = _fabHeightInit + 40;
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (_) => MapCubit()
                            ..getSnapshot(
                              lineString,
                              mp.Position(route.origin.longitude,
                                  route.origin.latitude),
                              mp.Position(route.destination.longitude,
                                  route.destination.latitude),
                              width: MediaQuery.of(context).size.width.toInt(),
                              height: 180.h.toInt(),
                            ),
                          child: BlocProvider.value(
                            value: context.read<RouteCubit>(),
                            child: BlocProvider.value(
                              value: context.read<TrackingBloc>(),
                              child: CyclingSnapshotDisplay(route: route),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                } else if (state is TrackingInitial) {
                  // Reset state when tracking is initialized
                  setState(() {
                    showHoldOptions = false;
                    isLocked = false;
                    _currentFabHeight = _fabHeightInit + 40;
                  });
                }

                if (state is TrackingInProgress) {
                  if (state.isPaused == true) {
                    setState(() {
                      showHoldOptions = true;
                      isLocked = false;
                      _updateFabHeight();
                    });
                  }
                }
                if (state is TrackingError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("❌ ${state.message}"),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                    ),
                  );
                }
              },
              child: Stack(
                children: [
                  /// Map View
                  CyclingMapView(
                    isCentered: _isCentered,
                    onCenteredChanged: _handleCenteredChanged,
                  ),

                  /// Cycling Top Bar
                  BlocBuilder<TrackingBloc, TrackingState>(
                    builder: (context, state) {
                      if ((state is! TrackingInProgress &&
                              state is! TrackingStarting &&
                              state is! TrackingFinishing &&
                              state is! TrackingFinished) &&
                          (state is TrackingInitial &&
                              state.groupRouteId == null)) {
                        return Positioned(
                          top: 10,
                          left: 0,
                          right: 0,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: CyclingTopActionBar(
                              isRiding: false,
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),

                  BlocBuilder<TrackingBloc, TrackingState>(
                    builder: (context, state) {
                      if ((state is TrackingInProgress &&
                              state.groupRouteId != null) ||
                          (state is TrackingInitial &&
                              state.groupRouteId != null)) {
                        return const GroupRideStatus();
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),

                  BlocBuilder<TrackingBloc, TrackingState>(
                    buildWhen: (prev, curr) {
                      if (prev is TrackingInProgress &&
                          curr is TrackingInProgress) {
                        final prevIds =
                            prev.matchedUsers?.map((e) => e.userId).toSet() ??
                                {};
                        final currIds =
                            curr.matchedUsers?.map((e) => e.userId).toSet() ??
                                {};

                        // Trigger rebuild if sets are different in size or content
                        if (prevIds.length != currIds.length) return true;

                        for (final id in prevIds) {
                          if (!currIds.contains(id)) return true;
                        }
                        return false;
                      }
                      return prev.runtimeType != curr.runtimeType;
                    },
                    builder: (context, state) {
                      if (state is TrackingInProgress &&
                          state.matchedUsers?.isNotEmpty == true) {
                        return CyclingTrackingDrawer(
                            matchedUsers: state.matchedUsers!);
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  //Show when tracking
                  BlocBuilder<TrackingBloc, TrackingState>(
                    buildWhen: (prev, curr) {
                      if (prev is TrackingInProgress &&
                          curr is TrackingInProgress) {
                        return prev.isPaused != curr.isPaused ||
                            prev.polyline != curr.polyline;
                      }
                      return prev.runtimeType != curr.runtimeType;
                    },
                    builder: (context, state) {
                      if (state is TrackingInProgress) {
                        return Positioned(
                          bottom: 0,
                          left: 0,
                          child: Container(
                            height: showHoldOptions
                                ? _fabHeightStart.h
                                : isLocked
                                    ? _fabHeightLocked.h
                                    : _fabHeightTracking.h,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (!showHoldOptions && !state.isPaused)
                                  CyclingMetricCarousel(
                                    odometerKm: state.odometerKm ?? 0,
                                    speed: state.speed ?? 0,
                                    elevationGain: state.elevationGain ?? 0,
                                    duration: state.duration,
                                    avgSpeed: state.avgSpeed ?? 0,
                                    batteryLevel: state.battery,
                                    altitude: state.altitude ?? 0,
                                    movingTime: state.movingTime,
                                  ),

                                if (!showHoldOptions &&
                                    !isLocked &&
                                    !state.isPaused)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      CyclingLockScreenButton(
                                          onCallBack: () => setState(() {
                                                isLocked = true;
                                              })),
                                      _buildPauseButton(),
                                      CyclingTakePictureButton()
                                    ],
                                  ),

                                // Show when options for Resume/Finish
                                if (showHoldOptions && state.isPaused)
                                  _buildResumeFinishButtons(),

                                //Show when lock
                                if (isLocked)
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .6,
                                    child: SlideToUnlock(
                                      onCallBack: () {
                                        setState(() {
                                          isLocked = false;
                                        });
                                      },
                                    ),
                                  )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Positioned(
                          bottom: _fabHeightInit,
                          left: 0,
                          right: 0,
                          child: Align(
                            alignment: Alignment.center,
                            child: _buildStartButton(),
                          ),
                        );
                      }
                    },
                  ),

                  // Map style button
                  Builder(builder: (context) {
                    return _mapControlButton(
                      icon: Icons.layers,
                      onPressed: () {
                        final mapCubit = context.read<MapCubit>();
                        _showStyleDialog(
                          context,
                          (style) => mapCubit.changeMapStyle(style),
                        );
                      },
                      left: 16,
                      bottom: _currentFabHeight.h + 20 + 20 + 30,
                    );
                  }),
                  // Recenter button (uses CyclingRecenterButton for icon logic)
                  Positioned(
                    left: 16,
                    bottom: _currentFabHeight.h + 20,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: CyclingRecenterButton(
                        isCentered: _isCentered,
                        onPressed: _handleRecenterPressed,
                      ),
                    ),
                  ),
                  // Zoom in button
                  Builder(builder: (context) {
                    return _mapControlButton(
                      icon: Icons.add,
                      onPressed: () async {
                        var camera = await context
                            .read<MapCubit>()
                            .mapboxMap
                            ?.getCameraState();
                        context.read<MapCubit>().mapboxMap?.flyTo(
                              mp.CameraOptions(
                                center: mp.Point(
                                    coordinates: camera!.center.coordinates),
                                zoom: camera.zoom + 1,
                              ),
                              mp.MapAnimationOptions(duration: 200),
                            );
                      },
                      right: 16,
                      bottom: _currentFabHeight.h + 30 + 20 + 20,
                    );
                  }),
                  // Zoom out button
                  Builder(builder: (context) {
                    return _mapControlButton(
                      icon: Icons.remove,
                      onPressed: () async {
                        var camera = await context
                            .read<MapCubit>()
                            .mapboxMap
                            ?.getCameraState();
                        context.read<MapCubit>().mapboxMap?.flyTo(
                              mp.CameraOptions(
                                center: mp.Point(
                                    coordinates: camera!.center.coordinates),
                                zoom: camera.zoom - 1,
                              ),
                              mp.MapAnimationOptions(duration: 200),
                            );
                      },
                      right: 16,
                      bottom: _currentFabHeight.h + 20,
                    );
                  }),
                  // Loading indicator
                  BlocBuilder<TrackingBloc, TrackingState>(
                    builder: (context, state) {
                      final isLoading = state is TrackingStarting ||
                          state is TrackingFinishing;
                      if (!isLoading) return const SizedBox.shrink();

                      return Stack(
                        children: const [
                          Opacity(
                            opacity: 0.6,
                            child: ModalBarrier(
                                dismissible: false, color: Colors.black),
                          ),
                          Center(child: CircularProgressIndicator()),
                        ],
                      );
                    },
                  ),

                  //Notify if there is a new participant
                  BlocListener<TrackingBloc, TrackingState>(
                    listenWhen: (prev, curr) {
                      if (prev is TrackingInProgress &&
                          curr is TrackingInProgress) {
                        if (prev.groupParticipants == null ||
                            curr.groupParticipants == null) {
                          return false;
                        }
                        // Check if there's any change in participants
                        if (prev.groupParticipants!.length !=
                            curr.groupParticipants!.length) {
                          return true;
                        }
                        // Check if any participant has changed
                        final prevIds = prev.groupParticipants!
                            .map((p) => p.userId)
                            .toSet();
                        final currIds = curr.groupParticipants!
                            .map((p) => p.userId)
                            .toSet();
                        return prevIds.difference(currIds).isNotEmpty ||
                            currIds.difference(prevIds).isNotEmpty;
                      }
                      return false;
                    },
                    listener: (context, state) {
                      if (state is TrackingInProgress &&
                          state.groupParticipants?.isNotEmpty == true) {
                        final prevState = context.read<TrackingBloc>().state;
                        if (prevState is TrackingInProgress) {
                          final prevIds = prevState.groupParticipants
                                  ?.map((p) => p.userId)
                                  .toSet() ??
                              {};
                          final currIds = state.groupParticipants
                                  ?.map((p) => p.userId)
                                  .toSet() ??
                              {};

                          // Find new participants
                          final newParticipants = currIds.difference(prevIds);
                          if (newParticipants.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("New participant joined"),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 3),
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.only(
                                    bottom: _currentFabHeight.h + 20,
                                    left: 10,
                                    right: 10),
                                dismissDirection: DismissDirection.up,
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: const SizedBox.shrink(),
                  ),

                  // Listen for group route ID changes
                  BlocListener<TrackingBloc, TrackingState>(
                    listenWhen: (prev, curr) {
                      if (prev is TrackingInProgress &&
                          curr is TrackingInProgress) {
                        return prev.groupRouteId != curr.groupRouteId;
                      }
                      if (prev is TrackingInitial && curr is TrackingInitial) {
                        return prev.groupRouteId != curr.groupRouteId;
                      }
                      return false;
                    },
                    listener: (context, state) {
                      if (state is TrackingInProgress &&
                          state.groupRouteId == null) {
                        sl<GroupRouteHubService>().endGroupRouteUpdateStream();
                      } else if (state is TrackingInitial &&
                          state.groupRouteId == null) {
                        sl<GroupRouteHubService>().endGroupRouteUpdateStream();
                      }
                    },
                    child: const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> mapStyles = [
    "Mapbox Streets",
    "Mapbox Outdoors",
    "Mapbox Light",
    "Mapbox Dark",
    "Mapbox Satellite",
    "Goong Map",
    "Terrain-v2",
  ];

  Future<dynamic> _showStyleDialog(
      BuildContext context, void Function(String style) onStyleSelected) {
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
                    onStyleSelected(style);
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
}
