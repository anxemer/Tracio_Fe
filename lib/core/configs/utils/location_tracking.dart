import 'dart:async';
import 'package:geolocator/geolocator.dart' as geolocator;

class LocationTracking {
  StreamSubscription<geolocator.Position>? userPositionStream;

  Future<StreamSubscription<geolocator.Position>?>
      setupPositionTracking() async {
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

    userPositionStream?.cancel();
    return userPositionStream;
  }
}
