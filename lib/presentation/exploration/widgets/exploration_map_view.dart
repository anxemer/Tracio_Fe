import 'package:Tracio/presentation/map/bloc/map_cubit.dart';
import 'package:Tracio/presentation/map/bloc/map_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:geolocator/geolocator.dart';

class ExplorationMapView extends StatefulWidget {
  final bool isCentered;
  final Function(bool) onCenteredChanged;

  const ExplorationMapView({
    super.key,
    required this.isCentered,
    required this.onCenteredChanged,
  });

  @override
  State<ExplorationMapView> createState() => _ExplorationMapViewState();
}

class _ExplorationMapViewState extends State<ExplorationMapView>
    with TickerProviderStateMixin {
  bool _isCentered = true;

  @override
  void initState() {
    super.initState();
    _isCentered = widget.isCentered;
  }

  @override
  void didUpdateWidget(ExplorationMapView oldWidget) {
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
      Position? cachedPosition;
      try {
        cachedPosition = await Geolocator.getLastKnownPosition();
      } catch (e) {
        debugPrint('❌ Error getting last known position: $e');
      }

      cachedPosition ??= await Geolocator.getCurrentPosition();

      if (mounted) {
        // Move map to position with smooth animation
        await context.read<MapCubit>().mapboxMap?.flyTo(
              mapbox.CameraOptions(
                center: mapbox.Point(
                  coordinates: mapbox.Position(
                    cachedPosition.longitude,
                    cachedPosition.latitude,
                  ),
                ),
                bearing: cachedPosition.heading,
                zoom: 13.0, // Add default zoom level
                padding: mapbox.MbxEdgeInsets(
                    top: 100, left: 0, right: 0, bottom: 0),
              ),
              mapbox.MapAnimationOptions(
                duration: 500, // Smooth animation duration
                startDelay: 0,
              ),
            );
      } else {
        debugPrint('⚠️ No position available');
      }
    } catch (e) {
      debugPrint('❌ Error in _handleInitialPosition: $e');
      // Optionally show a user-friendly error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Unable to get your current location. Please check your location settings.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
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
    return BlocListener<MapCubit, MapCubitState>(
      listener: (context, state) {
        if (state is MapCubitStyleLoaded) {
          _changeMapStyle(state.styleUri, context);
        }
      },
      child: mapbox.MapWidget(
        key: const ValueKey("mapWidget"),
        // cameraOptions: mapCubit.camera,
        onMapCreated: (map) async {
          await mapCubit.initializeMap(map,
              locationSetting: mapbox.LocationComponentSettings(
                enabled: true,
                showAccuracyRing: false,
                puckBearingEnabled: false,
              ),
              gesturesSetting: mapbox.GesturesSettings(
                  scrollEnabled: true,
                  pitchEnabled: false,
                  rotateEnabled: true),
              compassSetting: mapbox.CompassSettings(
                enabled: true,
                position: mapbox.OrnamentPosition.BOTTOM_RIGHT,
              ),
              logoSetting: mapbox.LogoSettings(
                  position: mapbox.OrnamentPosition.BOTTOM_RIGHT,
                  marginBottom: 80),
              attributionSetting: mapbox.AttributionSettings(
                  position: mapbox.OrnamentPosition.BOTTOM_RIGHT,
                  marginRight: 90,
                  marginBottom: 80));
          await _handleInitialPosition();
        },
      ),
    );
  }

  Future<void> _changeMapStyle(String styleUri, BuildContext context) async {
    final mapCubit = BlocProvider.of<MapCubit>(context);
    mapCubit.mapboxMap?.loadStyleURI(styleUri);
  }
}
