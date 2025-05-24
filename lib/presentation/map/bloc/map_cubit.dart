import 'dart:async';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:Tracio/core/configs/utils/color_utils.dart';
import 'package:Tracio/core/constants/api_url.dart';
import 'package:Tracio/core/constants/app_urls.dart';
import 'package:Tracio/core/network/dio_client.dart';
import 'package:Tracio/domain/map/usecase/get_image_url_usecase.dart';
import 'package:Tracio/presentation/map/bloc/map_state.dart';
import 'package:Tracio/service_locator.dart';

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

  final Map<String, PointAnnotation> _userAnnotations = {};
  final Map<String, PointAnnotationManager> _managers = {};
  final Map<String, Uint8List> _imageCache = {};

  Future<void> initializeMap(MapboxMap mapboxMap,
      {LocationComponentSettings? locationSetting,
      LogoSettings? logoSetting,
      AttributionSettings? attributionSetting,
      CompassSettings? compassSetting,
      GesturesSettings? gesturesSetting,
      Snapshotter? snapshotterSetting}) async {
    this.mapboxMap = mapboxMap;

    // Location setting
    await mapboxMap.location.updateSettings(
      locationSetting ??
          LocationComponentSettings(
            enabled: true,
            puckBearingEnabled: true,
          ),
    );
    await mapboxMap
        .setBounds(CameraBoundsOptions(maxZoom: 20.0, minZoom: 10.0));
    await mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));

    await mapboxMap.logo.updateSettings(
      logoSetting ??
          LogoSettings(
            position: OrnamentPosition.BOTTOM_RIGHT,
            marginRight: 60,
            marginBottom: 200,
          ),
    );

    // Attribution setting
    await mapboxMap.attribution.updateSettings(
      attributionSetting ??
          AttributionSettings(
            position: OrnamentPosition.BOTTOM_RIGHT,
            marginRight: 60,
            marginBottom: 200,
          ),
    );

    // Compass setting
    await mapboxMap.compass.updateSettings(
      compassSetting ??
          CompassSettings(
            position: OrnamentPosition.BOTTOM_LEFT,
            marginLeft: 10,
            marginBottom: 130,
            enabled: true,
          ),
    );

    // Gesture setting
    await mapboxMap.gestures.updateSettings(
      gesturesSetting ??
          GesturesSettings(
            rotateEnabled: true,
          ),
    );
  }

  void changeMapStyle(String style) {
    String styleUri = {
          "Mapbox Streets": MapboxStyles.MAPBOX_STREETS,
          "Mapbox Outdoors": MapboxStyles.OUTDOORS,
          "Mapbox Light": MapboxStyles.LIGHT,
          "Mapbox Dark": MapboxStyles.DARK,
          "Mapbox Satellite": MapboxStyles.SATELLITE,
          "Goong Map":
              "${AppUrl.goongMaptile}${dotenv.env['GOONG_MAPTILE_TOKEN']}",
          "Terrain-v2": ApiUrl.urlCustomMapTile
        }[style] ??
        MapboxStyles.OUTDOORS;
    emit(MapCubitStyleLoaded(styleUri: styleUri));
  }

  void animateCamera(
    Position position, {
    double zoom = 18,
  }) {
    mapboxMap?.flyTo(
      CameraOptions(
        center: Point(coordinates: position),
        anchor: ScreenCoordinate(x: 0, y: 0),
        zoom: zoom,
      ),
      MapAnimationOptions(duration: 2000, startDelay: 500),
    );
  }

  Future<void> addPointAnnotation(Position position, Uint8List imageData,
      {IconAnchor iconAnchor = IconAnchor.BOTTOM,
      List<double?>? iconOffset,
      double iconSize = 1,
      PointAnnotationManager? pointAnnotation}) async {
    pointAnnotationManager ??= pointAnnotation ??
        await mapboxMap?.annotations.createPointAnnotationManager();

    pointAnnotationManager?.setIconAllowOverlap(true);

    final annotation = PointAnnotationOptions(
        geometry: Point(coordinates: position),
        image: imageData,
        iconSize: iconSize,
        iconAnchor: iconAnchor);

    await pointAnnotationManager?.create(annotation);
    pointAnnotations.add(annotation);
    emit(MapAnnotationsUpdated());
  }

  Future<void> addPolylineRoute(LineString lineString,
      {double lineWidth = 5.0,
      Color lineColor = Colors.deepOrange,
      double lineOpacity = 0.6,
      Color lineBorderColor = Colors.white,
      double lineBorderWidth = 1.0}) async {
    try {
      polylineAnnotationManager ??= await mapboxMap?.annotations
          .createPolylineAnnotationManager(
              id: "polyline-layer", below: "mapbox-location-indicator-layer");

      final polylineOptions = PolylineAnnotationOptions(
        geometry: lineString,
        lineJoin: LineJoin.ROUND,
        lineColor: lineColor.toInt(),
        lineWidth: lineWidth,
        lineBorderWidth: lineBorderWidth,
        lineBorderColor: lineBorderColor.toInt(),
        lineOpacity: lineOpacity,
      );

      await polylineAnnotationManager?.create(polylineOptions);
    } catch (e) {
      debugPrint('Error adding polyline: $e');
    }
  }

  Future<void> clearAnnotations() async {
    pointAnnotations.clear();
    emit(MapAnnotationsUpdated());
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
      debugPrint("Error removing polygon: $e");
    }
  }

  void onBottomSheetClosed() {
    emit(MapAnnotationsUpdated());

    if (searchAnnotation != null) {
      pointAnnotations.remove(searchAnnotation!);
      searchAnnotation = null;
    }

    _updateAnnotationsOnMap();
  }

  Future<void> getSnapshot(LineString lineString, Position start, Position end,
      {int width = 400, int height = 700}) async {
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
            width: width,
            height: height);

        // Assuming `snapshotImage` is set properly with the image URL
        emit(StaticImageLoaded(snapshot: snapshotImageUrl));
      } else {
        emit(StaticImageFailure(errorMessage: "Error capturing snapshot"));
      }
    } catch (e) {
      emit(StaticImageFailure(errorMessage: "Error capturing snapshot: $e"));
    }
  }

  Future<void> addUserMarker({
    required String id,
    required String imageUrl,
    required Position position,
    double imageSize = 1.0,
    Color borderColor = Colors.black54,
    double borderSize = 6.0,
  }) async {
    final bytes = await _fetchAndResizeImage(
        url: imageUrl,
        size: 80,
        borderColor: borderColor,
        borderSize: borderSize,
        borderRadius: 50);

    final manager = await mapboxMap?.annotations
        .createPointAnnotationManager(id: 'user_$id');
    final annotation = await manager?.create(
      PointAnnotationOptions(
        geometry: Point(coordinates: position),
        image: bytes,
      ),
    );

    _userAnnotations[id] = annotation!;
    _managers[id] = manager!;
  }

  Future<void> updateUserMarker({
    required String id,
    required String imageUrl,
    required Position newPosition,
  }) async {
    if (!_userAnnotations.containsKey(id) || !_managers.containsKey(id)) {
      debugPrint("🔍 No marker found for user $id — creating new one.");
      await addUserMarker(id: id, imageUrl: imageUrl, position: newPosition);
      return;
    }

    final marker = _userAnnotations[id]!;
    final manager = _managers[id];

    if (manager == null) {
      debugPrint("❌ No annotation manager found for user $id.");
      return;
    }

    try {
      final updated = PointAnnotation(
        id: marker.id,
        geometry: Point(coordinates: newPosition),
      );

      await manager.update(updated);
      _userAnnotations[id] = updated;

      debugPrint(
          "✅ Marker updated for user $id at (${newPosition.lng}, ${newPosition.lat})");
    } catch (e, stackTrace) {
      debugPrint("❌ Failed to update marker for user $id: $e\n$stackTrace");
    }
  }

  Future<void> clearAllMarkers() async {
    for (final manager in _managers.values) {
      await manager.deleteAll();
    }
    _userAnnotations.clear();
    _managers.clear();
  }

  Future<Uint8List> _fetchAndResizeImage({
    required String url,
    required int size,
    required Color borderColor,
    required double borderSize,
    required double borderRadius,
  }) async {
    if (_imageCache.containsKey(url)) {
      return _imageCache[url]!;
    }

    final response = await sl<GetImageUrlUsecase>().call(url);
    return response.fold(
      (error) {
        debugPrint('[Image Error] ${error.message}');
        throw Exception("Failed to load image from $url");
      },
      (data) async {
        final image = Uint8List.fromList(data);
        final resized = await createMarkerImage(
            image, size, borderColor, borderSize,
            borderRadius: borderRadius);
        _imageCache[url] = resized;
        return resized;
      },
    );
  }

  Future<Uint8List> createMarkerImage(
    Uint8List data,
    int size,
    Color borderColor,
    double borderSize, {
    double borderRadius = 8,
    double triangleHeight = 10,
  }) async {
    final codec = await ui.instantiateImageCodec(
      data,
      targetWidth: size,
      targetHeight: size,
    );
    final frame = await codec.getNextFrame();
    final uiImage = frame.image;

    final width = size;
    final height = size;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final paint = Paint();
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderSize;

    final rect = Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    // Only save layer for clipping image
    canvas.save();
    canvas.clipRRect(rrect);

    // Draw the resized image inside clipped area
    canvas.drawImageRect(
      uiImage,
      Rect.fromLTWH(0, 0, uiImage.width.toDouble(), uiImage.height.toDouble()),
      rect,
      paint,
    );

    canvas.restore(); // <-- restore to remove clipping for next drawing

    // Now draw border (outside clip)
    canvas.drawRRect(rrect.deflate(borderSize / 2), borderPaint);

    // Draw triangle at bottom center
    final path = Path();
    path.moveTo(width / 2 - 5, height.toDouble());
    path.lineTo(width / 2, height.toDouble() + triangleHeight);
    path.lineTo(width / 2 + 5, height.toDouble());
    path.close();

    final trianglePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, trianglePaint);

    final picture = recorder.endRecording();
    final finalImage =
        await picture.toImage(width, (height + triangleHeight).toInt());
    final byteData =
        await finalImage.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  Future<Uint8List> getNetworkImageData(Uri imageUrl) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        imageUrl.toString(),
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200 && response.data != null) {
        Uint8List originalBytes = response.data as Uint8List;
        return await createMarkerImage(originalBytes, 40, Colors.black87, 4);
      } else {
        throw Exception('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching image: $e');
    }
  }
}
