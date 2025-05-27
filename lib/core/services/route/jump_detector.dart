import 'package:latlong2/latlong.dart';

class JumpDetector {
  final double maxSpeedJump;
  final double maxDistanceJump;
  LatLng? _lastPosition;
  double? _lastSpeed;
  DateTime? _lastTimestamp;

  JumpDetector({
    this.maxSpeedJump = 20.0,
    this.maxDistanceJump = 50.0,
  });

  bool isJump(LatLng position, double speed, DateTime timestamp) {
    if (_lastPosition == null || _lastSpeed == null || _lastTimestamp == null) {
      _updateState(position, speed, timestamp);
      return false;
    }

    final timeDelta = timestamp.difference(_lastTimestamp!).inSeconds;
    if (timeDelta == 0) return false;

    // Calculate speed jump
    final speedJump = (speed - _lastSpeed!).abs();
    if (speedJump > maxSpeedJump) {
      _updateState(position, speed, timestamp);
      return true;
    }

    // Calculate distance jump
    final distance = const Distance().distance(_lastPosition!, position);
    final timeInHours = timeDelta / 3600;
    final maxPossibleDistance = _lastSpeed! * timeInHours + maxDistanceJump;

    if (distance > maxPossibleDistance) {
      _updateState(position, speed, timestamp);
      return true;
    }

    _updateState(position, speed, timestamp);
    return false;
  }

  void _updateState(LatLng position, double speed, DateTime timestamp) {
    _lastPosition = position;
    _lastSpeed = speed;
    _lastTimestamp = timestamp;
  }

  void reset() {
    _lastPosition = null;
    _lastSpeed = null;
    _lastTimestamp = null;
  }
}
