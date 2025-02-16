import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:tracio_fe/core/constants/app_urls.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late mapbox.MapboxMap mapboxMap;

  StreamSubscription? userPositionStream;

  List<String> mapStyles = [
    "Mapbox Streets",
    "Mapbox Outdoors",
    "Mapbox Light",
    "Mapbox Dark",
    "Mapbox Satellite",
    "Goong Map"
  ];

  @override
  void initState() {
    super.initState();
    _setupPositionTracking();
  }

  @override
  void dispose() {
    userPositionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Camera options
    mapbox.CameraOptions camera = mapbox.CameraOptions(
      center: mapbox.Point(
          coordinates: mapbox.Position(106.65607167348008, 10.838242196485027)),
      zoom: 12,
      bearing: 0,
      pitch: 10,
    );

    return mapbox.MapWidget(
      cameraOptions: camera,
      onMapCreated: _onMapCreate,
    );
  }

  Future<void> _onMapCreate(mapbox.MapboxMap controller) async {
    // Variables
    final southwest = mapbox.Point(coordinates: mapbox.Position(8.5, 104.6667));
    final northeast = mapbox.Point(coordinates: mapbox.Position(23.5, 110.5));
    double maxZoom = 20.0;
    double minZoom = 10.0;

    setState(() {
      mapboxMap = controller;
    });

    // Enable the location component
    await mapboxMap.location.updateSettings(mapbox.LocationComponentSettings(
      enabled: true,
      pulsingEnabled: true,
    ));

    //Camera limitation
    await mapboxMap.setBounds(mapbox.CameraBoundsOptions(
      bounds: mapbox.CoordinateBounds(
        southwest: southwest,
        northeast: northeast,
        infiniteBounds: true,
      ),
      maxZoom: maxZoom,
      minZoom: minZoom,
    ));

    //Compass settings
    mapboxMap.compass.updateSettings(mapbox.CompassSettings(
        position: mapbox.OrnamentPosition.BOTTOM_LEFT, marginBottom: 30));

    //Scale bar settings
    mapboxMap.scaleBar.updateSettings(mapbox.ScaleBarSettings(enabled: false));

    String terrainRgbUrl =
        "${AppUrl.terrainRgbStyle}${dotenv.env['MAPBOX_ACCESS_TOKEN']}";
    _addTerrainSourceAndLayer(terrainRgbUrl);
  }

  Future<void> _setupPositionTracking() async {
    bool serviceEnabled;
    geolocator.LocationPermission permission;

    serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied) {
      permission = await geolocator.Geolocator.requestPermission();
      if (permission == geolocator.LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
    }
    if (permission == geolocator.LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
    geolocator.LocationSettings locationSettings = geolocator.LocationSettings(
        accuracy: geolocator.LocationAccuracy.high, distanceFilter: 100);

    userPositionStream?.cancel();
    userPositionStream = geolocator.Geolocator.getPositionStream(
            locationSettings: locationSettings)
        .listen((
      geolocator.Position? position,
    ) {
      if (position != null) {
        _cameraAnimation(mapbox.Position(
          position.longitude,
          position.latitude,
        ));
      }
    });
  }

  void _cameraAnimation(mapbox.Position aniPosition) {
    mapboxMap.setCamera(mapbox.CameraOptions(
      zoom: 12,
    ));

    mapboxMap.flyTo(
        mapbox.CameraOptions(
            center: mapbox.Point(coordinates: aniPosition),
            anchor: mapbox.ScreenCoordinate(x: 0, y: 0),
            zoom: 18),
        mapbox.MapAnimationOptions(duration: 2000, startDelay: 500));
  }

  Future<void> _addTerrainSourceAndLayer(String terrainRgbUrl) async {
    try {
      // Attempt to add the source
      final rasterSource = mapbox.RasterSource(
        id: "terrain-rgb-source",
        tiles: [terrainRgbUrl],
        tileSize: 256,
      );

      await mapboxMap.style.addSource(rasterSource);
    } catch (e) {
      // Handle the case where the source already exists
      debugPrint(
          "Source 'terrain-rgb-source' already exists or another error occurred: $e");
    }

    // Now add the layer
    try {
      final rasterLayer = mapbox.RasterLayer(
        id: "terrain-rgb-layer",
        sourceId: "terrain-rgb-source",
        slot: "middle",
      );

      await mapboxMap.style.addLayer(rasterLayer);
    } catch (e) {
      // Handle the case where the layer already exists
      debugPrint(
          "Layer 'terrain-rgb-layer' already exists or another error occurred: $e");
    }
  }

  void _showStyleSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Map Style"),
          content: SingleChildScrollView(
            child: ListBody(
              children: mapStyles.map((style) {
                return ListTile(
                  title: Text(style),
                  onTap: () {
                    _changeMapStyle(style);
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

  void _changeMapStyle(String style) {
    String styleUri;

    switch (style) {
      case "Mapbox Streets":
        styleUri = mapbox.MapboxStyles.MAPBOX_STREETS;
        break;
      case "Mapbox Outdoors":
        styleUri = mapbox.MapboxStyles.OUTDOORS;
        break;
      case "Mapbox Light":
        styleUri = mapbox.MapboxStyles.LIGHT;
        break;
      case "Mapbox Dark":
        styleUri = mapbox.MapboxStyles.DARK;
        break;
      case "Mapbox Satellite":
        styleUri = mapbox.MapboxStyles.SATELLITE;
        break;
      case "Goong Map":
        styleUri = "${AppUrl.goongMaptile}${dotenv.env['GOONG_MAPTILE_TOKEN']}";
        break;
      default:
        styleUri = "${AppUrl.goongMaptile}${dotenv.env['GOONG_MAPTILE_TOKEN']}";
    }

    mapboxMap.loadStyleURI(styleUri);
  }
}
