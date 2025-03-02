import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tracio_fe/core/configs/utils/color_utils.dart';
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

  PolylineAnnotationManager? polylineAnnotationManager;

  Position? lastSearchedPosition;

  PointAnnotation? searchedAnnotation;
  PointAnnotationOptions? searchAnnotationPoint;

  PolygonAnnotationManager? polygonAnnotationManager;

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

  Future<void> initializeMapForRiding(MapboxMap mapboxMap) async {
    double maxZoom = 20.0;
    double minZoom = 10.0;

    this.mapboxMap = mapboxMap;
    // Enable the location component
    await mapboxMap.location.updateSettings(
        LocationComponentSettings(enabled: true, puckBearingEnabled: true));
    //Camera limitation
    await mapboxMap.setBounds(CameraBoundsOptions(
      maxZoom: maxZoom,
      minZoom: minZoom,
    ));
    //Scale bar settings
    await mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    //mapbox logo settings
    mapboxMap.logo.updateSettings(LogoSettings(
        position: OrnamentPosition.BOTTOM_RIGHT,
        marginRight: 80,
        marginBottom: 80));
    mapboxMap.attribution.updateSettings(AttributionSettings(
        position: OrnamentPosition.BOTTOM_RIGHT,
        marginRight: 65,
        marginBottom: 80));
    mapboxMap.compass.updateSettings(CompassSettings(
        position: OrnamentPosition.BOTTOM_RIGHT,
        marginRight: 20,
        marginBottom: 80));
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

  Future<void> addPointAnnotationForChoosing(Position position) async {
    pointAnnotationManager ??=
        await mapboxMap?.annotations.createPointAnnotationManager();

    final ByteData bytes =
        await rootBundle.load('assets/images/search_location_marker.png');
    final Uint8List list = bytes.buffer.asUint8List();

    searchAnnotationPoint = PointAnnotationOptions(
        geometry: Point(coordinates: position),
        image: list,
        iconOffset: [-10.0, 20.0],
        iconSize: 0.5);

    // Ensure it gets added to the map
    await pointAnnotationManager?.create(searchAnnotationPoint!);
  }

  Future<void> addPolylineRouteToMap(LineString lineString) async {
    // Add the route to the map
    polylineAnnotationManager ??=
        await mapboxMap?.annotations.createPolylineAnnotationManager();
    PolylineAnnotationOptions? polylineAnnotationOptions;

    polylineAnnotationOptions = PolylineAnnotationOptions(
        geometry: lineString,
        lineJoin: LineJoin.ROUND,
        lineColor: Colors.blue.toInt(),
        lineWidth: 3.0);
    // Add the annotation to the map
    polylineAnnotationManager?.create(polylineAnnotationOptions);
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
        iconOffset: [-5, -20],
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

      List<PointAnnotationOptions> updatedAnnotations =
          List.from(pointAnnotationOptions);
      if (searchAnnotationPoint != null) {
        updatedAnnotations.add(searchAnnotationPoint!);
      }

      if (updatedAnnotations.isNotEmpty) {
        await pointAnnotationManager?.createMulti(updatedAnnotations);
      }
    }
  }

  Future<void> addPolygonGeoJson(Uri mapboxRequest) async {
    await removePolygonGeoJson();

    await mapboxMap?.style.addSource(
        GeoJsonSource(id: "geojson_data", data: mapboxRequest.toString()));

    await mapboxMap?.style.addLayer(FillLayer(
      id: "geojson_layer",
      sourceId: "geojson_data",
      fillColor: Colors.blue.toInt(),
      fillOpacity: 0.3,
    ));

    // Line Layer (Border of the Polygon)
    await mapboxMap?.style.addLayer(LineLayer(
      id: "geojson_border",
      sourceId: "geojson_data",
      lineColor: Colors.blue.shade800.toInt(),
      lineWidth: 3.5,
    ));

    mapboxMap?.flyTo(CameraOptions(zoom: 15),
        MapAnimationOptions(duration: 2000, startDelay: 500));
  }

  Future<void> removePolygonGeoJson() async {
    try {
      await mapboxMap?.style.removeStyleLayer("geojson_layer");
      await mapboxMap?.style.removeStyleLayer("geojson_border");
      await mapboxMap?.style.removeStyleSource("geojson_data");
    } catch (e) {
      print("Error removing existing polygon: $e");
    }
  }

  void onBottomSheetClosed() {
    emit(MapAnnotationsUpdated(annotations: List.from(pointAnnotationOptions)));

    if (searchAnnotationPoint != null) {
      pointAnnotationOptions.remove(searchAnnotationPoint!);
      searchAnnotationPoint = null;
    }

    _updateAnnotationsOnMap();
  }
}
