import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tracio_fe/common/helper/custom_paint/numbered_circle_painter.dart';
import 'package:tracio_fe/core/configs/utils/color_utils.dart';
import 'package:tracio_fe/core/constants/api_url.dart';
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

  Uri? snapshotImageUrl;

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

  Future<void> getSnapshot(
      LineString lineString, Position start, Position end) async {
    emit(StaticImageLoading());
    try {
      // Encode the polyline coordinates to a string

      String polylineEncoded = encodePolyline(lineString.coordinates
          .map((point) => [point.lat, point.lng])
          .toList());

      if (polylineEncoded.isNotEmpty) {
        snapshotImageUrl = ApiUrl.urlGetStaticImageMapbox(
          dotenv.env['MAPBOX_ACCESS_TOKEN']!,
          [start.lng, start.lat],
          [end.lng, end.lat],
          polylineEncoded,
        );

        // Assuming `snapshotImage` is set properly with the image URL
        emit(StaticImageLoaded(snapshot: snapshotImageUrl));
      } else {
        emit(StaticImageFailure(errorMessage: "Error capturing snapshot"));
      }
    } catch (e) {
      emit(StaticImageFailure(errorMessage: "Error capturing snapshot: $e"));
    }
  }
}
