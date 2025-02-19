import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tracio_fe/core/constants/app_urls.dart';
import 'package:tracio_fe/presentation/map/bloc/map_state.dart';

class MapCubit extends Cubit<MapCubitState> {
  MapCubit() : super(MapCubitInitial());

  MapboxMap? mapboxMap;
  //initial value for camera
  final CameraOptions camera = CameraOptions(
    center:
        Point(coordinates: Position(106.65607167348008, 10.838242196485027)),
    zoom: 12,
    bearing: 0,
    pitch: 10,
  );

  Future<void> initializeMap(MapboxMap mapboxMap) async {
    double maxZoom = 20.0;
    double minZoom = 10.0;

    this.mapboxMap = mapboxMap;
    // Enable the location component
    await mapboxMap.location.updateSettings(LocationComponentSettings(
      enabled: true,
    ));

    //Camera limitation
    await mapboxMap.setBounds(CameraBoundsOptions(
      maxZoom: maxZoom,
      minZoom: minZoom,
    ));

    //Compass settings
    await mapboxMap.compass.updateSettings(CompassSettings(
        position: OrnamentPosition.BOTTOM_LEFT, marginBottom: 30));

    //Scale bar settings
    await mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));

    //mapbox logo settings
    mapboxMap.logo.updateSettings(LogoSettings(
        position: OrnamentPosition.BOTTOM_RIGHT,
        marginRight: 60,
        marginBottom: 200));

    mapboxMap.attribution.updateSettings(AttributionSettings(
        position: OrnamentPosition.BOTTOM_RIGHT,
        marginRight: 60,
        marginBottom: 200));
  }

  Future<void> fetchRoute() async {
    emit(MapCubitRouteLoading());
    final String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN']!;
    final String url =
        'https://api.mapbox.com/directions/v5/mapbox/cycling/106.780616%2C10.88529%3B106.778378%2C10.874937?alternatives=true&annotations=distance%2Cduration%2Cspeed&continue_straight=true&geometries=polyline&language=en&overview=full&steps=true&access_token=$accessToken';

    try {
      final response = await Dio().get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        final coordinates = data['routes'][0]['geometry'];

        final List<List<num>> decodedPolyline = decodePolyline(coordinates);
        // Convert to lineString
        final List<Position> positions = decodedPolyline
            .map((coord) => Position(coord[1], coord[0]))
            .toList();
        final LineString lineString = LineString(coordinates: positions);

        emit(MapCubitRouteLoaded(lineString: lineString));
      } else {
        throw Exception('Failed to load route');
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

  void changeMapStyle(String style) {
    String styleUri;
    switch (style) {
      case "Mapbox Streets":
        styleUri = MapboxStyles.MAPBOX_STREETS;
        break;
      case "Mapbox Outdoors":
        styleUri = MapboxStyles.OUTDOORS;
        break;
      case "Mapbox Light":
        styleUri = MapboxStyles.LIGHT;
        break;
      case "Mapbox Dark":
        styleUri = MapboxStyles.DARK;
        break;
      case "Mapbox Satellite":
        styleUri = MapboxStyles.SATELLITE;
        break;
      case "Goong Map":
        styleUri = "${AppUrl.goongMaptile}${dotenv.env['GOONG_MAPTILE_TOKEN']}";
        break;
      default:
        styleUri = "${AppUrl.goongMaptile}${dotenv.env['GOONG_MAPTILE_TOKEN']}";
    }
    emit(MapCubitStyleLoaded(styleUri: styleUri));
  }

  void cameraAnimation(Position aniPosition) {
    mapboxMap?.setCamera(CameraOptions(
      zoom: 12,
    ));

    mapboxMap?.flyTo(
        CameraOptions(
            center: Point(coordinates: aniPosition),
            anchor: ScreenCoordinate(x: 0, y: 0),
            zoom: 18),
        MapAnimationOptions(duration: 2000, startDelay: 500));
  }

  void showAlertDialog() {
    emit(MapShowDialogState());
  }
}
