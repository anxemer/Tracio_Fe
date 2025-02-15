import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracio_fe/core/configs/utils/permission_handler_service.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:tracio_fe/core/constants/app_urls.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapboxMap mapboxMap;

  List<String> mapStyles = [
    "Mapbox Streets",
    "Mapbox Outdoors",
    "Mapbox Light",
    "Mapbox Dark",
    "Mapbox Satellite",
    "Goong Map"
  ];

  final _permissionHandlerService = PermissionHandlerService();
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await _permissionHandlerService.requestPermission(
      Permission.location,
      "Location",
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    //Camera options
    CameraOptions camera = CameraOptions(
      center:
          Point(coordinates: Position(106.65607167348008, 10.838242196485027)),
      zoom: 12,
      bearing: 0,
      pitch: 10,
    );

    return Scaffold(
      body: Stack(
        children: [
          // Map
          MapWidget(
            cameraOptions: camera,
            onMapCreated: _onMapCreate,
          ),

          // Input field for searching location
          Positioned(
            top: 30,
            left: 20,
            right: 20,
            child: TextField(
              onTapOutside: (PointerDownEvent event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: InputDecoration(
                hintText: 'Search route...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          // Floating Action Button
          Positioned(
            bottom: 30,
            right: 10,
            child: FloatingActionButton(
              onPressed: _showStyleSelectionDialog,
              child: Icon(Icons.map),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onMapCreate(MapboxMap controller) async {
    // Variables
    final southwest = Point(coordinates: Position(8.5, 104.6667));
    final northeast = Point(coordinates: Position(23.5, 110.5));
    double maxZoom = 20.0;
    double minZoom = 10.0;

    mapboxMap = controller;

    // Enable the location component
    await mapboxMap.location.updateSettings(LocationComponentSettings(
      enabled: true,
      showAccuracyRing: true,
      accuracyRingColor: Colors.blue.r.toInt(),
      accuracyRingBorderColor: Colors.white.r.toInt(),
      pulsingEnabled: true,
      pulsingColor: Colors.blue.r.toInt(),
    ));

    //Camera limitation
    await mapboxMap.setBounds(CameraBoundsOptions(
      bounds: CoordinateBounds(
        southwest: southwest,
        northeast: northeast,
        infiniteBounds: true,
      ),
      maxZoom: maxZoom,
      minZoom: minZoom,
    ));

    //Compass settings
    mapboxMap.compass.updateSettings(CompassSettings(
        position: OrnamentPosition.BOTTOM_LEFT, marginBottom: 30));

    //Scale bar settings
    mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));

    //camera animation
    //TODO: Get User Location
    mapboxMap.flyTo(
        CameraOptions(
            center: Point(coordinates: Position(-80.1263, 25.7845)),
            anchor: ScreenCoordinate(x: 0, y: 0),
            zoom: 18,
            bearing: 180,
            pitch: 30),
        MapAnimationOptions(duration: 2000, startDelay: 0));

    String terrainRgbUrl =
        "${AppUrl.terrainRgbStyle}${dotenv.env['MAPBOX_ACCESS_TOKEN']}";
    addTerrainSourceAndLayer(terrainRgbUrl);
  }

  Future<void> addTerrainSourceAndLayer(String terrainRgbUrl) async {
    try {
      // Attempt to add the source
      final rasterSource = RasterSource(
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
      final rasterLayer = RasterLayer(
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

    mapboxMap.loadStyleURI(styleUri);
  }
}
