import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapboxMap mapboxMap;

  @override
  Widget build(BuildContext context) {
    String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? "";

    if (accessToken.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            "Mapbox access token is not provided. Please set MAPBOX_ACCESS_TOKEN in .env file.",
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    MapboxOptions.setAccessToken(accessToken);

    CameraOptions camera = CameraOptions(
      //TODO: Get User Location
      center:
          Point(coordinates: Position(106.65607167348008, 10.838242196485027)),
      zoom: 16,
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
            top: 50,
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

          // Show the list of nearby places
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nearby Places",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text("Placeholder for nearby places list"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onMapCreate(MapboxMap controller) async {
    //variables
    String goongMapTileToken = dotenv.env['GOONG_MAPTILE_TOKEN'] ?? "";
    final southwest = Point(coordinates: Position(8.5, 104.6667));
    final northeast = Point(coordinates: Position(23.5, 110.5));
    double maxZoom = 20.0;
    double minZoom = 10.0;

    mapboxMap = controller;

    final customStyleUri = goongMapTileToken.isNotEmpty
        ? "https://tiles.goong.io/assets/goong_map_web.json?api_key=$goongMapTileToken"
        : "";

    await mapboxMap.setBounds(CameraBoundsOptions(
      bounds: CoordinateBounds(
        southwest: southwest,
        northeast: northeast,
        infiniteBounds: true,
      ),
      maxZoom: maxZoom,
      minZoom: minZoom,
    ));

    //Load style
    mapboxMap.loadStyleURI(customStyleUri);
  }
}
