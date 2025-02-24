import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
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

  List<PointAnnotationOptions> pointAnnotationOptions = [];
  PointAnnotationManager? pointAnnotationManager;

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
    await mapboxMap.gestures
        .updateSettings(GesturesSettings(rotateEnabled: false));
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
        ('Error fetching route: $e');
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
      case "Terrain-v2":
        styleUri = "mapbox://styles/trminloc/cm7brl3yq006m01qyhqlx2kze";
        break;
      default:
        styleUri = MapboxStyles.OUTDOORS;
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

  Future<void> addPointAnnotation(Position position) async {
    // Create a new PointAnnotationManager if it doesn't exist
    pointAnnotationManager ??=
        await mapboxMap?.annotations.createPointAnnotationManager();

    final ByteData bytes =
        await rootBundle.load('assets/images/location_icon.png');
    final Uint8List list = bytes.buffer.asUint8List();

    final pointAnnotationOption = PointAnnotationOptions(
      geometry: Point(coordinates: position),
      image: list,
      iconOffset: [-10.0, 20.0],

    );

    pointAnnotationOptions.add(pointAnnotationOption);

    emit(MapAnnotationsUpdated(annotations: List.from(pointAnnotationOptions)));
    
    _updateAnnotationsOnMap();
  }

  Future<void> addListPointsAnnotation(List<Position> positions) async {
    // Create a new PointAnnotationManager if it doesn't exist
    pointAnnotationManager ??=
        await mapboxMap?.annotations.createPointAnnotationManager();

    final ByteData bytes =
        await rootBundle.load('assets/images/location_icon.png');
    final Uint8List list = bytes.buffer.asUint8List();

    // Create PointAnnotationOptions for each position
    List<PointAnnotationOptions> newAnnotations = positions.map((position) {
      return PointAnnotationOptions(
        geometry: Point(coordinates: position),
        image: list,
        iconOffset: [-5,-20],
      );
    }).toList();

    // Add new annotations to the existing list
    pointAnnotationOptions.addAll(newAnnotations);

    // Emit new state with updated annotations
    emit(MapAnnotationsUpdated(annotations: List.from(pointAnnotationOptions)));

    // Update annotations on the map
    _updateAnnotationsOnMap();
  }

  Future<void> removeLastAnnotation() async {
    if (pointAnnotationOptions.isNotEmpty) {
      pointAnnotationOptions.removeLast();
      emit(MapAnnotationsUpdated(
          annotations: List.from(pointAnnotationOptions)));
      await _updateAnnotationsOnMap();
    } else {
      await clearAnnotations();
    }
  }

  Future<void> clearAnnotations() async {
    pointAnnotationOptions.clear();
    emit(MapAnnotationsUpdated(annotations: List.from(pointAnnotationOptions)));
    await _updateAnnotationsOnMap();
  }

  Future<void> _updateAnnotationsOnMap() async {
    if (pointAnnotationManager != null) {
      await pointAnnotationManager!.deleteAll();
      if (pointAnnotationOptions.isNotEmpty) {
        await pointAnnotationManager?.createMulti(pointAnnotationOptions);
      }
    }
  }
}
