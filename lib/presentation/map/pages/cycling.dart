import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/core/services/notifications/notification_service.dart';
import 'package:tracio_fe/presentation/map/bloc/get_direction_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/get_location_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/map_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/tracking_location_bloc.dart';
import 'package:tracio_fe/presentation/map/widgets/cycling_lock_screen_button.dart';
import 'package:tracio_fe/presentation/map/widgets/cycling_map_view.dart';
import 'package:tracio_fe/presentation/map/widgets/cycling_metric_carousel.dart';
import 'package:tracio_fe/presentation/map/widgets/cycling_take_picture_button.dart';
import 'package:tracio_fe/presentation/map/widgets/cycling_top_action_bar.dart';
import 'package:tracio_fe/presentation/map/widgets/slide_to_unlock.dart';

class CyclingPage extends StatefulWidget {
  const CyclingPage({super.key});

  @override
  State<CyclingPage> createState() => _CyclingPageState();
}

class _CyclingPageState extends State<CyclingPage> {
  final double _fabHeightStart = 150;
  final double _fabHeightTracking = 200;
  final double _fabHeightLocked = 180;
  bool isPaused = false;
  bool isRiding = false;
  bool showHoldOptions = false;
  bool shouldStreamLocation = false;
  late DateTime rideStartTime;
  Timer? timer;
  double odometerKm = 0.0;
  double speed = 0.0;
  double altitude = 0.0;
  Duration duration = Duration.zero;
  bool isLocked = false;

  CarouselSliderController carouselController = CarouselSliderController();
  @override
  void initState() {
    super.initState();
  }

  Future<void> _initializeBackgroundGeolocation() async {
    bg.BackgroundGeolocation.onLocation(_streamLocationDataToBloc);
    bg.BackgroundGeolocation.onMotionChange(_streamMotionDataToBloc);
    bg.BackgroundGeolocation.setOdometer(0.0);
    final state = await bg.BackgroundGeolocation.ready(bg.Config(
        reset: false,
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        stopTimeout: 5,
        logLevel: bg.Config.LOG_LEVEL_ERROR,
        motionTriggerDelay: 5000));
    if (!state.enabled) {
      await bg.BackgroundGeolocation.start();
    }
  }

  Future<void> _startTracking() async {
    // Start sending tracking notification
    rideStartTime = DateTime.now();
    NotificationService.sendRideTrackingNotification(
      'Starting...',
      'Preparing GPS...',
      rideStartTime,
    );
    final state = await bg.BackgroundGeolocation.state;
    if (!state.enabled) {
      setState(() {
        isRiding = true;
        isPaused = false;
        shouldStreamLocation = true;
      });
    } else {
      await bg.BackgroundGeolocation.changePace(true);
      setState(() {
        isRiding = true;
        isPaused = false;
        shouldStreamLocation = true;
      });
    }
  }

  void _streamLocationDataToBloc(bg.Location location) {
    if (!mounted || !shouldStreamLocation) return;
    context
        .read<LocationCubit>()
        .updateLocation(location, location.coords.heading);
    setState(() {
      odometerKm = location.odometer / 1000;
      speed = location.coords.speed * 18 / 5;
      altitude = location.coords.altitude;
      duration = DateTime.now().difference(rideStartTime);
    });
  }

  void _streamMotionDataToBloc(bg.Location location) async {
    NotificationService.sendRideTrackingNotification(
      'Recording',
      'Distance: ${formatDuration(duration)}; Distance: $odometerKm km',
      rideStartTime,
    );
    try {
      if (!location.isMoving) {
        context.read<LocationCubit>().pauseTracking();
      } else {
        final state = await bg.BackgroundGeolocation.state;
        if (state.enabled) {
          await bg.BackgroundGeolocation.changePace(true);
        } else {
          debugPrint("Geolocation not started yet.");
        }
      }
    } catch (e) {
      debugPrint("Error in changePace: $e");
    }
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    timer?.cancel();
    bg.BackgroundGeolocation.stop();
    super.dispose();
  }

  // Build Start button (when not riding)
  Widget _buildStartButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: Size(
              MediaQuery.of(context).size.width * 0.8, AppSize.buttonHeight),
          backgroundColor: AppColors.secondBackground,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.buttonRadius))),
      onPressed: () async {
        await _initializeBackgroundGeolocation();
        await _startTracking();
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
          onPressed: () async {
            await bg.BackgroundGeolocation.changePace(true);
            setState(() {
              isPaused = false;
              isRiding = true;
              shouldStreamLocation = true;
              showHoldOptions = false;
            });
          },
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
          onPressed: () async {
            // Finish tracking
            await bg.BackgroundGeolocation.stop();
            setState(() {
              isRiding = false;
              isPaused = false;
              shouldStreamLocation = false;
              showHoldOptions = false;
            });
          },
          child: const Text("Finish", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  // Build the pause button
  Widget _buildPauseButton() {
    return GestureDetector(
      onLongPress: () async {
        setState(() {
          showHoldOptions = true;
          isPaused = true;
          shouldStreamLocation = false;
        }); // Pause tracking
        await bg.BackgroundGeolocation.changePace(false);
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

              /// Cycling Top Bar
              Positioned(
                top: 10,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: CyclingTopActionBar(
                    isRiding: isRiding || isLocked || isPaused,
                  ),
                ),
              ),

              //Show when tracking
              if (isRiding)
                Positioned(
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
                        // Show when Tracking
                        if (isRiding && !showHoldOptions)
                          CyclingMetricCarousel(
                            odometerKm: odometerKm,
                            speed: speed,
                            altitude: altitude,
                          ),

                        // Show when Tracking
                        if (isRiding && !showHoldOptions && !isLocked)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        if (showHoldOptions) _buildResumeFinishButtons(),

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
                ),

              // Show when start
              if (!isRiding)
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: _buildStartButton(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
