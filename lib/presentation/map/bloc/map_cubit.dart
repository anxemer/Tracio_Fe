import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tracio_fe/common/helper/custom_paint/numbered_circle_painter.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/configs/utils/color_utils.dart';
import 'package:tracio_fe/core/constants/app_urls.dart';
import 'package:tracio_fe/presentation/map/bloc/map_state.dart';

class MapCubit extends Cubit<MapCubitState> {
  MapCubit() : super(MapCubitInitial());

  MapboxMap? mapboxMap;
  final CameraOptions camera = CameraOptions(
    center:
        Point(coordinates: Position(106.65607167348008, 10.838242196485027)),
    zoom: 12,
    bearing: 0,
    pitch: 10,
  );

  Snapshotter? _snapshotter;
  Image? snapshotImage;

  List<PointAnnotationOptions> pointAnnotations = [];
  PointAnnotationManager? pointAnnotationManager;
  PolylineAnnotationManager? polylineAnnotationManager;
  PolygonAnnotationManager? polygonAnnotationManager;
  PointAnnotationOptions? searchAnnotation;

  Future<void> initializeMap(MapboxMap mapboxMap,
      {bool forRiding = false}) async {
    this.mapboxMap = mapboxMap;

    await mapboxMap.location.updateSettings(LocationComponentSettings(
        enabled: true, puckBearingEnabled: forRiding));

    await mapboxMap
        .setBounds(CameraBoundsOptions(maxZoom: 20.0, minZoom: 10.0));
    await mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));

    mapboxMap.logo.updateSettings(LogoSettings(
      position: OrnamentPosition.BOTTOM_RIGHT,
      marginRight: forRiding ? 80 : 60,
      marginBottom: forRiding ? 80 : 200,
    ));

    mapboxMap.attribution.updateSettings(AttributionSettings(
      position: OrnamentPosition.BOTTOM_RIGHT,
      marginRight: forRiding ? 65 : 60,
      marginBottom: forRiding ? 80 : 200,
    ));

    if (forRiding) {
      mapboxMap.compass.updateSettings(CompassSettings(
        position: OrnamentPosition.BOTTOM_RIGHT,
        marginRight: 20,
        marginBottom: 80,
      ));
    } else {
      mapboxMap.gestures.updateSettings(GesturesSettings(rotateEnabled: false));
    }
  }

  void changeMapStyle(String style) {
    String customTileUrl = "mapbox://styles/trminloc/cm7brl3yq006m01qyhqlx2kze";
    String styleUri = {
          "Mapbox Streets": MapboxStyles.MAPBOX_STREETS,
          "Mapbox Outdoors": MapboxStyles.OUTDOORS,
          "Mapbox Light": MapboxStyles.LIGHT,
          "Mapbox Dark": MapboxStyles.DARK,
          "Mapbox Satellite": MapboxStyles.SATELLITE,
          "Goong Map":
              "${AppUrl.goongMaptile}${dotenv.env['GOONG_MAPTILE_TOKEN']}",
          "Terrain-v2": customTileUrl
        }[style] ??
        MapboxStyles.OUTDOORS;
    emit(MapCubitStyleLoaded(styleUri: styleUri));
  }

  void animateCamera(Position position) {
    mapboxMap?.flyTo(
      CameraOptions(
        center: Point(coordinates: position),
        anchor: ScreenCoordinate(x: 0, y: 0),
        zoom: 18,
      ),
      MapAnimationOptions(duration: 2000, startDelay: 500),
    );
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

  Future<Uint8List> _getImageDataForOrderedPoint(int index) async {
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

  Future<void> addPointAnnotation(Position position) async {
    pointAnnotationManager ??=
        await mapboxMap?.annotations.createPointAnnotationManager();

    pointAnnotationManager?.setIconAllowOverlap(true);

    final Uint8List imageData =
        await _getImageDataForOrderedPoint(pointAnnotations.length);

    final annotation = PointAnnotationOptions(
        geometry: Point(coordinates: position),
        image: imageData,
        iconAnchor: IconAnchor.BOTTOM);

    pointAnnotationManager?.create(annotation);

    pointAnnotations.add(annotation);
    emit(MapAnnotationsUpdated(annotations: List.from(pointAnnotations)));
  }

  Future<void> addSearchAnnotation(Position position) async {
    pointAnnotationManager ??=
        await mapboxMap?.annotations.createPointAnnotationManager();
    pointAnnotationManager?.setIconAllowOverlap(true);
    final Uint8List imageData =
        await _getMarkerBytes('assets/images/search_location_marker.png');

    searchAnnotation = PointAnnotationOptions(
      geometry: Point(coordinates: position),
      image: imageData,
      iconOffset: [-10.0, 20.0],
      iconSize: 0.5,
    );

    await pointAnnotationManager?.create(searchAnnotation!);
  }

  Future<void> addPolylineRoute(LineString lineString) async {
    polylineAnnotationManager ??=
        await mapboxMap?.annotations.createPolylineAnnotationManager();

    final polylineOptions = PolylineAnnotationOptions(
      geometry: lineString,
      lineJoin: LineJoin.ROUND,
      lineColor: Colors.blue.toInt(),
      lineWidth: 3.0,
    );

    await polylineAnnotationManager?.create(polylineOptions);
  }

  Future<void> addMultiplePointAnnotations(List<Position> positions) async {
    pointAnnotationManager ??=
        await mapboxMap?.annotations.createPointAnnotationManager();
    pointAnnotationManager?.setIconAllowOverlap(true);

    final futures = positions.asMap().entries.map((entry) async {
      final Uint8List imageData = await _getImageDataForOrderedPoint(entry.key);
      return PointAnnotationOptions(
        geometry: Point(coordinates: entry.value),
        image: imageData,
      );
    });

    final annotations = await Future.wait(futures);
    pointAnnotations.clear();
    pointAnnotations.addAll(annotations);
    emit(MapAnnotationsUpdated(annotations: List.from(pointAnnotations)));
    _updateAnnotationsOnMap();
  }

  Future<void> removeLastAnnotation() async {
    if (pointAnnotations.isNotEmpty) {
      pointAnnotations.removeLast();
      emit(MapAnnotationsUpdated(annotations: List.from(pointAnnotations)));
      _updateAnnotationsOnMap();
    } else {
      await clearAnnotations();
    }
  }

  Future<void> clearAnnotations() async {
    pointAnnotations.clear();
    emit(MapAnnotationsUpdated(annotations: []));
    _updateAnnotationsOnMap();
  }

  Future<void> _updateAnnotationsOnMap() async {
    pointAnnotationManager?.deleteAll();
    final List<PointAnnotationOptions> annotations =
        List.from(pointAnnotations);
    if (searchAnnotation != null) annotations.add(searchAnnotation!);
    if (annotations.isNotEmpty) {
      await pointAnnotationManager?.createMulti(annotations);
    }
  }

  Future<void> addPolygonGeoJson(Uri mapboxRequest) async {
    await removePolygonGeoJson();

    await mapboxMap?.style.addSource(GeoJsonSource(
      id: "geojson_data",
      data: mapboxRequest.toString(),
    ));

    await mapboxMap?.style.addLayer(FillLayer(
        id: "geojson_layer",
        sourceId: "geojson_data",
        fillColor: Colors.blue.toInt(),
        fillOpacity: 0.3,
        slot: "MIDDLE"));

    await mapboxMap?.style.addLayer(LineLayer(
        id: "geojson_border",
        sourceId: "geojson_data",
        lineColor: Colors.blue.shade800.toInt(),
        lineWidth: 3.5,
        slot: "MIDDLE"));

    mapboxMap?.flyTo(CameraOptions(zoom: 15),
        MapAnimationOptions(duration: 2000, startDelay: 500));
  }

  Future<void> removePolygonGeoJson() async {
    try {
      await mapboxMap?.style.removeStyleLayer("geojson_layer");
      await mapboxMap?.style.removeStyleLayer("geojson_border");
      await mapboxMap?.style.removeStyleSource("geojson_data");
    } catch (e) {
      print("Error removing polygon: $e");
    }
  }

  void onBottomSheetClosed() {
    emit(MapAnnotationsUpdated(annotations: List.from(pointAnnotations)));

    if (searchAnnotation != null) {
      pointAnnotations.remove(searchAnnotation!);
      searchAnnotation = null;
    }

    _updateAnnotationsOnMap();
  }

  Future<void> initSnapshot({
    double width = 400,
    double height = 600,
    String styleURI = MapboxStyles.MAPBOX_STREETS,
  }) async {
    _snapshotter = await Snapshotter.create(
      options: MapSnapshotOptions(
        size: Size(width: width, height: height),
        pixelRatio: 2.0,
        showsAttribution: false,
        showsLogo: false,
      ),
    );

    _snapshotter?.style.setStyleURI(styleURI);
  }

  Future<void> getSnapshot(
      LineString lineString, Position start, Position end) async {
    emit(StaticImageLoading());
    await initSnapshot();
    if (mapboxMap == null || _snapshotter == null) {
      emit(StaticImageFailure(
          errorMessage: "Mapbox Snapshotter not initialized"));
      return;
    }

    try {
      // 🔹 Compute Bounding Box (Fit all points in view)
      final cameraOptions = _calculateBoundingCamera(lineString.coordinates);
      _snapshotter?.setCamera(cameraOptions);

      // 🔹 Add Polyline & Waypoints
      await _addPolylineToSnapshot(lineString);
      await _addWaypointsToSnapshot([start, end]);

      final snapshot = await _snapshotter?.start();

      if (snapshot != null) {
        snapshotImage = Image.memory(snapshot);
        emit(StaticImageLoaded(snapshot: snapshotImage));
      } else {
        emit(StaticImageFailure(errorMessage: "Error capturing snapshot"));
      }
    } catch (e) {
      emit(StaticImageFailure(errorMessage: "Error capturing snapshot: $e"));
    }
  }

  void cancelSnapshot() async {
    snapshotImage = null;
    _snapshotter?.clearData();
    _snapshotter?.cancel();

    try {
      // ✅ Remove polyline source & layer
      await _snapshotter?.style.removeStyleLayer("polyline_layer");
      await _snapshotter?.style.removeStyleSource("polyline_source");

      // ✅ Remove all waypoint sources & layers
      for (int i = 0; i < 10; i++) {
        // Assume max 10 waypoints
        await _snapshotter?.style.removeStyleLayer("waypoint_layer_$i");
        await _snapshotter?.style.removeStyleSource("waypoint_source_$i");
      }
    } catch (e) {
      print("Error removing sources: $e");
    }

    emit(StaticImageFailure(errorMessage: "Snapshot Cancelled"));
  }

  Future<void> _addPolylineToSnapshot(LineString lineString) async {
    final polylineSource = GeoJsonSource(
      id: "polyline_source",
      data: jsonEncode({
        "type": "Feature",
        "geometry": {
          "type": "LineString",
          "coordinates":
              lineString.coordinates.map((pos) => [pos.lng, pos.lat]).toList(),
        },
      }),
    );

    await _snapshotter!.style.addSource(polylineSource);

    final polylineLayer = LineLayer(
      id: "polyline_layer",
      sourceId: "polyline_source",
      lineColor: AppColors.secondBackground.toInt(),
      lineWidth: 10.0,
    );

    await _snapshotter!.style.addLayer(polylineLayer);
  }

  Future<void> _addWaypointsToSnapshot(List<Position> waypoints) async {
    if (waypoints.length < 2) return;
    await _addStyleImage("start-flag", "assets/images/start-flag.png");
    await _addStyleImage("end-flag", "assets/images/end-flag.png");
    for (var i = 0; i < waypoints.length; i++) {
      String markerType = (i == 0)
          ? "start-flag"
          : (i == waypoints.length - 1)
              ? "end-flag"
              : "marker-icon";

      final waypointSource = GeoJsonSource(
        id: "waypoint_source_$i",
        data: jsonEncode({
          "type": "Feature",
          "geometry": {
            "type": "Point",
            "coordinates": [waypoints[i].lng, waypoints[i].lat],
          },
        }),
      );

      await _snapshotter!.style.addSource(waypointSource);

      final waypointLayer = SymbolLayer(
        id: "waypoint_layer_$i",
        sourceId: "waypoint_source_$i",
        iconImage: markerType,
        iconSize: 1, // Adjust marker size
        iconAnchor: IconAnchor.BOTTOM, // Ensure bottom aligns with position
      );

      await _snapshotter!.style.addLayer(waypointLayer);
    }
  }

  CameraOptions _calculateBoundingCamera(List<Position> positions) {
    double minLat = double.infinity, maxLat = double.negativeInfinity;
    double minLng = double.infinity, maxLng = double.negativeInfinity;

    for (var pos in positions) {
      if (pos.lat < minLat) minLat = pos.lat.toDouble();
      if (pos.lat > maxLat) maxLat = pos.lat.toDouble();
      if (pos.lng < minLng) minLng = pos.lng.toDouble();
      if (pos.lng > maxLng) maxLng = pos.lng.toDouble();
    }

    final center = Position((minLng + maxLng) / 2, (minLat + maxLat) / 2);
    final zoom = _calculateOptimalZoom(minLat, maxLat, minLng, maxLng);

    return CameraOptions(
      center: Point(coordinates: center),
      zoom: zoom,
      pitch: 0,
      bearing: 0,
    );
  }

// 🔹 Function: Calculate Optimal Zoom Level
  double _calculateOptimalZoom(
      double minLat, double maxLat, double minLng, double maxLng) {
    final latDiff = maxLat - minLat;
    final lngDiff = maxLng - minLng;
    final maxDiff = latDiff > lngDiff ? latDiff : lngDiff;

    if (maxDiff < 0.01) return 16; // Very close
    if (maxDiff < 0.1) return 13; // Medium distance
    if (maxDiff < 1) return 10; // Large distance
    return 7; // Very large distance
  }

  /// 📌 **Load & Resize Image to Valid Dimensions**
  Future<void> _addStyleImage(String imageId, String assetPath) async {
    final ByteData bytes = await rootBundle.load(assetPath);
    final Uint8List imageData = bytes.buffer.asUint8List();

    // 🛠 Ensure Image is a Power-of-Two Size
    Uint8List resizedImage =
        await _resizeImageToPowerOfTwo(imageData, 64, 64); // Resize to 64x64

    MbxImage mbxImage = MbxImage(
      width: 64, // Must be power-of-two
      height: 64, // Must be power-of-two
      data: resizedImage,
    );

    await _snapshotter!.style.addStyleImage(
      imageId,
      1.0, // Scale factor
      mbxImage,
      false, // SDF (Symbol Distance Field) - set to false
      [], // Stretch X
      [], // Stretch Y
      null, // Image content
    );
  }

  /// 📌 **Resize Image to Power-of-Two Dimensions**
  Future<Uint8List> _resizeImageToPowerOfTwo(
      Uint8List imageData, int targetWidth, int targetHeight) async {
    ui.Codec codec = await ui.instantiateImageCodec(imageData,
        targetWidth: targetWidth, targetHeight: targetHeight);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    ui.Image resizedImage = frameInfo.image;

    ByteData? byteData =
        await resizedImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
