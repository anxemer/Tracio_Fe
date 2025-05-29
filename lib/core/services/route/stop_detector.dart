import 'package:latlong2/latlong.dart';

class StopDetector {
  final Duration debounceTime;
  final double speedThreshold;
  DateTime? _lastStopTime;
  DateTime? _lastMovingTime;
  bool _isStopped = false;
  double _maxSpeed = 0.0;
  Duration _movingTime = Duration.zero;

  StopDetector({
    this.debounceTime = const Duration(seconds: 2),
    this.speedThreshold = 0.5,
  });

  bool isStopped(double speed, LatLng position, DateTime timestamp) {
    // Update max speed
    if (speed > _maxSpeed) {
      _maxSpeed = speed;
    }

    if (speed >= speedThreshold) {
      if (_isStopped) {
        // Transition from stopped to moving
        _lastMovingTime = timestamp;
      }
      _isStopped = false;
      _lastStopTime = null;
      return false;
    }

    if (_lastStopTime == null) {
      _lastStopTime = timestamp;
      return false;
    }

    final timeSinceLastStop = timestamp.difference(_lastStopTime!);
    if (timeSinceLastStop >= debounceTime) {
      if (!_isStopped) {
        // Transition from moving to stopped
        if (_lastMovingTime != null) {
          _movingTime += timestamp.difference(_lastMovingTime!);
          _lastMovingTime = null;
        }
      }
      _isStopped = true;
    }

    return _isStopped;
  }

  double get maxSpeed => _maxSpeed;
  Duration get movingTime => _movingTime;
  bool get isCurrentlyStopped => _isStopped;

  void reset() {
    _lastStopTime = null;
    _lastMovingTime = null;
    _isStopped = false;
    _maxSpeed = 0.0;
    _movingTime = Duration.zero;
  }
}
