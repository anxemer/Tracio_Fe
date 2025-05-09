import 'package:Tracio/presentation/map/widgets/cycling_tracking_drawer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mp;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/core/services/signalR/implement/group_route_hub_service.dart';
import 'package:Tracio/core/services/signalR/implement/matching_hub_service.dart';
import 'package:Tracio/data/map/models/request/finish_tracking_req.dart';
import 'package:Tracio/domain/map/usecase/finish_tracking_usecase.dart';
import 'package:Tracio/domain/map/usecase/start_tracking_usecase.dart';
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

class CyclingPage extends StatefulWidget {
  const CyclingPage({super.key});

  @override
  State<CyclingPage> createState() => _CyclingPageState();
}

class _CyclingPageState extends State<CyclingPage> {
  final double _fabHeightStart = 150;
  final double _fabHeightTracking = 200;
  final double _fabHeightLocked = 180;

  bool showHoldOptions = false;
  bool _isBgGeoInitialized = false;

  bool isLocked = false;
  CarouselSliderController carouselController = CarouselSliderController();
  bool isLoading = false;
  void setLoading(bool value) {
    if (!mounted) return;
    setState(() {
      isLoading = value;
    });
  }

  Future<void> _initializeBackgroundGeolocation() async {
    if (_isBgGeoInitialized) return;
    _isBgGeoInitialized = true;
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      final accuracy = location.coords.accuracy;

      if (accuracy > 10.0) {
        debugPrint("⛔️ Skipping due to low accuracy: $accuracy");
        return;
      }

      context.read<TrackingBloc>().add(UpdateTrackingData(location));
    });
    bg.BackgroundGeolocation.onEnabledChange((bool enabled) {
      debugPrint("BackgroundGeolocation enabled: $enabled");
      setState(() {
        _isBgGeoInitialized = enabled;
      });
    });

    bg.BackgroundGeolocation.setOdometer(0.0);
    if (!mounted) return;
    final state = await bg.BackgroundGeolocation.ready(bg.Config(
      reset: false,
      // Logging & Debug
      debug: true,
      logLevel: bg.Config.LOG_LEVEL_VERBOSE,
      // Geolocation options
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_NAVIGATION,
      distanceFilter: 10.0,
      locationUpdateInterval: 1000,
      fastestLocationUpdateInterval: 500,
      disableElasticity: true,
      // Activity recognition options
      stopTimeout: 5, disableMotionActivityUpdates: false,
      desiredOdometerAccuracy: 10.0,
      backgroundPermissionRationale: bg.PermissionRationale(
          title:
              "Allow Tracio to access this device's location even when the app is closed or not in use.",
          message:
              "This app collects location data to enable recording your trips to work and calculate distance-traveled.",
          positiveAction: 'Change to "{backgroundPermissionOptionLabel}"',
          negativeAction: 'Cancel'),
      // HTTP & Persistence
      autoSync: true,
      persistMode: bg.Config.PERSIST_MODE_NONE,
      // Application options
      stopOnTerminate: false,
      startOnBoot: true,
      enableHeadless: true,
      foregroundService: true,
    ));
    if (!state.enabled) {
      await bg.BackgroundGeolocation.start();
    }
  }

  Future<void> _fetchStartTracking() async {
    final origin = await bg.BackgroundGeolocation.getCurrentPosition(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        samples: 1,
        timeout: 30);
    Map<String, dynamic> params = {
      'origin': {
        "latitude": origin.coords.latitude,
        "longitude": origin.coords.longitude,
        "altitude": origin.coords.altitude
      },
    };
    final joinedGroupRoutes = sl<GroupRouteHubService>().joinedGroupRouteIds;
    if (joinedGroupRoutes.isEmpty) {
      debugPrint("❌ No joined group route ID available.");
    } else {
      final groupRouteId = joinedGroupRoutes.first;
      params["groupRouteId"] = groupRouteId;
    }

    final result = await sl<StartTrackingUsecase>().call(params);
    if (!mounted) return;
    result.fold((error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "🚨 Failed to start tracking: ${error.message}",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.fromLTRB(16, 20, 16, 0), // top spacing
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 6,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      debugPrint("Error starting tracking: $error");
    }, (response) async {
      final routeIdFromApi = response["result"]["routeId"];
      context.read<TrackingBloc>().add(StartTracking(
            routeId: routeIdFromApi,
          ));
      debugPrint("Tracking started successfully: $response");

      final matchingHubService = sl<MatchingHubService>();
      await matchingHubService.connect();

      _initializeBackgroundGeolocation();
    });
  }

  Future<void> _fetchFinishTracking() async {
    final trackingState = context.read<TrackingBloc>().state;

    if (trackingState is! TrackingInProgress || trackingState.routeId == null) {
      debugPrint("Tracking not in progress or routeId is missing.");
      return;
    }

    FinishTrackingReq request =
        FinishTrackingReq(routeId: trackingState.routeId!);

    final result = await sl<FinishTrackingUsecase>().call(request);
    return result.fold((error) async {
      debugPrint("Error finishing tracking: $error");
      await bg.BackgroundGeolocation.stop();
      context.read<TrackingBloc>().add(EndTracking());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to finish tracking. Try again.")),
      );

      return;
    }, (response) async {
      debugPrint("Tracking finished successfully: $response");
      await bg.BackgroundGeolocation.stop();
      context.read<TrackingBloc>().add(EndTracking());
      setState(() {
        showHoldOptions = false;
        isLocked = false;
      });
      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Route too short to save (under 500m). Auto-stop")),
        );

        return;
      }
      final decodedPolyline = decodePolyline(response.polyline)
          .map((coord) => mp.Position(coord[1], coord[0]))
          .toList();
      final lineString = mp.LineString(coordinates: decodedPolyline);
      //reset state
      setState(() {
        showHoldOptions = false;
        isLocked = false;
      });

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BlocProvider(
                    create: (context) => MapCubit()
                      ..getSnapshot(
                          lineString,
                          mp.Position(response.origin.longitude,
                              response.origin.latitude),
                          mp.Position(response.destination.longitude,
                              response.destination.latitude),
                          width: 400,
                          height: 400),
                    child: BlocProvider.value(
                      value: context.read<RouteCubit>(),
                      child: CyclingSnapshotDisplay(route: response),
                    ),
                  )));
      return;
    });
  }

  void _onStartPressed() async {
    setLoading(true);
    await _fetchStartTracking();
    setLoading(false);
  }

  void _onPausePressed() async {
    final state = context.read<TrackingBloc>().state;
    if (state is TrackingInProgress && !state.isPaused) {
      final isEnabled = await bg.BackgroundGeolocation.state;
      if (isEnabled.enabled) {
        await bg.BackgroundGeolocation.changePace(false);
      } else {
        debugPrint("⚠️ BackgroundGeolocation is not enabled.");
      }
      setState(() {
        showHoldOptions = true;
      });
      context.read<TrackingBloc>().add(PauseTracking());
    }
  }

  void _onResumePressed() async {
    final trackingState = context.read<TrackingBloc>().state;

    if (trackingState is TrackingInProgress && trackingState.isPaused) {
      final state = await bg.BackgroundGeolocation.state;

      if (!state.enabled) {
        await bg.BackgroundGeolocation.start(); // ✅ Required before changePace
      }

      await bg.BackgroundGeolocation.setOdometer(trackingState.odometerKm ?? 0);

      setState(() {
        showHoldOptions = false;
      });

      context.read<TrackingBloc>().add(ResumeTracking());

      await bg.BackgroundGeolocation.changePace(true);
    }
  }

  void _onFinishPressed() async {
    setLoading(true);
    await _fetchFinishTracking();

    //Leave group route hub
    final joinedGroupRoutes = sl<GroupRouteHubService>().joinedGroupRouteIds;
    if (joinedGroupRoutes.isEmpty) {
      debugPrint("❌ No joined group route ID available.");
    } else {
      final groupRouteId = joinedGroupRoutes.first;
      await sl<GroupRouteHubService>().leaveGroupRoute(groupRouteId);
    }

    setLoading(false);
  }

  @override
  void dispose() {
    super.dispose();
    bg.BackgroundGeolocation.setOdometer(0.0);
    bg.BackgroundGeolocation.stop();
    bg.BackgroundGeolocation.removeListeners();

    EasyThrottle.cancelAll();
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
            child: Stack(
              children: [
                /// Map View
                CyclingMapView(),

                /// Cycling Top Bar
                BlocBuilder<TrackingBloc, TrackingState>(
                  builder: (context, state) {
                    if (state is! TrackingInProgress) {
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
                  buildWhen: (prev, curr) {
                    if (prev is TrackingInProgress &&
                        curr is TrackingInProgress) {
                      final prevIds =
                          prev.matchedUsers?.map((e) => e.userId).toSet() ?? {};
                      final currIds =
                          curr.matchedUsers?.map((e) => e.userId).toSet() ?? {};

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
                                  width: MediaQuery.of(context).size.width * .6,
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
                        bottom: 20,
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
                if (isLoading)
                  const Opacity(
                    opacity: 0.6,
                    child:
                        ModalBarrier(dismissible: false, color: Colors.black),
                  ),
                if (isLoading) const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
