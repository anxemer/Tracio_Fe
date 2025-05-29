import 'dart:math';
import 'package:latlong2/latlong.dart';

class KalmanFilter {
  // Process noise (how much we expect the position to change)
  final double _processNoise;
  // Measurement noise (how much we trust the GPS)
  final double _measurementNoise;
  // State estimate
  double _estimate = 0.0;
  // Error estimate
  double _errorEstimate = 1.0;
  // Last measurement
  double _lastMeasurement = 0.0;
  // Last timestamp
  DateTime? _lastTimestamp;

  final bool adaptiveNoise;
  double _currentProcessNoise;
  double _currentMeasurementNoise;

  // Elevation-specific parameters
  static const double _elevationProcessNoise = 0.15;
  static const double _elevationMeasurementNoise = 0.15;
  static const double _maxElevationChange = 50.0; // meters per second

  KalmanFilter({
    double processNoise = 0.1,
    double measurementNoise = 0.1,
    this.adaptiveNoise = false,
  })  : _processNoise = processNoise,
        _measurementNoise = measurementNoise,
        _currentProcessNoise = processNoise,
        _currentMeasurementNoise = measurementNoise;

  void updateNoiseParameters(double processNoise, double measurementNoise) {
    if (adaptiveNoise) {
      _currentProcessNoise = processNoise;
      _currentMeasurementNoise = measurementNoise;
    }
  }

  double safeFilter(double? measurement, DateTime timestamp) {
    // Skip invalid or null values
    if (measurement == null || !measurement.isFinite) {
      return _estimate;
    }
    return filter(measurement, timestamp);
  }

  double filter(double measurement, DateTime timestamp) {
    if (_lastTimestamp == null) {
      _lastTimestamp = timestamp;
      _lastMeasurement = measurement;
      _estimate = measurement;
      return measurement;
    }

    // Calculate time delta in seconds
    final dt = timestamp.difference(_lastTimestamp!).inMilliseconds / 1000.0;
    _lastTimestamp = timestamp;

    // Prediction
    _errorEstimate = _errorEstimate + _currentProcessNoise * dt;

    // Update
    final kalmanGain =
        _errorEstimate / (_errorEstimate + _currentMeasurementNoise);
    _estimate = _estimate + kalmanGain * (measurement - _estimate);
    _errorEstimate = (1 - kalmanGain) * _errorEstimate;

    _lastMeasurement = measurement;
    return _estimate;
  }

  double filterElevation(double elevation, DateTime timestamp) {
    if (_lastTimestamp == null) {
      _lastTimestamp = timestamp;
      _lastMeasurement = elevation;
      _estimate = elevation;
      return elevation;
    }

    // Calculate time delta in seconds
    final dt = timestamp.difference(_lastTimestamp!).inMilliseconds / 1000.0;
    _lastTimestamp = timestamp;

    // Check for unreasonable elevation changes
    if (_lastMeasurement != null) {
      final elevationChange = (elevation - _lastMeasurement).abs();
      final maxAllowedChange = _maxElevationChange * dt;

      if (elevationChange > maxAllowedChange) {
        // If change is too large, use a weighted average
        elevation = _lastMeasurement +
            (elevationChange > 0 ? 1 : -1) * maxAllowedChange;
      }
    }

    // Prediction
    _errorEstimate = _errorEstimate + _elevationProcessNoise * dt;

    // Update
    final kalmanGain =
        _errorEstimate / (_errorEstimate + _elevationMeasurementNoise);
    _estimate = _estimate + kalmanGain * (elevation - _estimate);
    _errorEstimate = (1 - kalmanGain) * _errorEstimate;

    _lastMeasurement = elevation;
    return _estimate;
  }

  void reset() {
    _estimate = 0.0;
    _errorEstimate = 1.0;
    _lastMeasurement = 0.0;
    _lastTimestamp = null;
  }
}

class PositionKalmanFilter {
  final KalmanFilter _latFilter;
  final KalmanFilter _lngFilter;
  final KalmanFilter _speedFilter;
  final KalmanFilter _bearingFilter;
  final KalmanFilter _elevationFilter;
  final bool adaptiveNoise;

  PositionKalmanFilter({
    double processNoise = 0.1,
    double measurementNoise = 0.1,
    this.adaptiveNoise = false,
  })  : _latFilter = KalmanFilter(
          processNoise: processNoise,
          measurementNoise: measurementNoise,
          adaptiveNoise: adaptiveNoise,
        ),
        _lngFilter = KalmanFilter(
          processNoise: processNoise,
          measurementNoise: measurementNoise,
          adaptiveNoise: adaptiveNoise,
        ),
        _speedFilter = KalmanFilter(
          processNoise: processNoise * 2,
          measurementNoise: measurementNoise * 2,
          adaptiveNoise: adaptiveNoise,
        ),
        _bearingFilter = KalmanFilter(
          processNoise: processNoise * 3,
          measurementNoise: measurementNoise * 3,
          adaptiveNoise: adaptiveNoise,
        ),
        _elevationFilter = KalmanFilter(
          processNoise: processNoise * 1.5,
          measurementNoise: measurementNoise * 1.5,
          adaptiveNoise: adaptiveNoise,
        );

  void updateNoiseParameters(double speed, double elevation) {
    if (!adaptiveNoise) return;

    // Adjust noise based on speed
    final speedFactor = speed / 30.0; // Normalize to 30 m/s
    final processNoise = 0.1 * (1 + speedFactor);
    final measurementNoise = 0.1 * (1 - speedFactor * 0.5);

    // Adjust elevation noise based on speed and elevation change
    final elevationProcessNoise = 0.15 * (1 + speedFactor * 0.5);
    final elevationMeasurementNoise = 0.15 * (1 - speedFactor * 0.3);

    _latFilter.updateNoiseParameters(processNoise, measurementNoise);
    _lngFilter.updateNoiseParameters(processNoise, measurementNoise);
    _speedFilter.updateNoiseParameters(processNoise * 2, measurementNoise * 2);
    _bearingFilter.updateNoiseParameters(
        processNoise * 3, measurementNoise * 3);
    _elevationFilter.updateNoiseParameters(
        elevationProcessNoise, elevationMeasurementNoise);
  }

  LatLng filterPosition(
      LatLng position, double speed, double bearing, DateTime timestamp,
      {double smoothingFactor = 0.3}) {
    // First apply Kalman filtering
    final smoothedLat = _latFilter.safeFilter(position.latitude, timestamp);
    final smoothedLng = _lngFilter.safeFilter(position.longitude, timestamp);
    final filteredSpeed = _speedFilter.safeFilter(speed, timestamp);
    final filteredBearing = _bearingFilter.safeFilter(bearing, timestamp);

    // Calculate adaptive smoothing based on speed and bearing change
    final speedBasedSmoothing = filteredSpeed > 0
        ? smoothingFactor * (1 - (filteredSpeed / 30.0).clamp(0.0, 0.8))
        : smoothingFactor;

    // Adjust smoothing based on bearing change
    final bearingChange = (bearing - filteredBearing).abs();
    final bearingBasedSmoothing = bearingChange > 45
        ? speedBasedSmoothing * 0.5 // Reduce smoothing during sharp turns
        : speedBasedSmoothing;

    // Apply position smoothing with combined factors
    final finalLat = position.latitude * (1 - bearingBasedSmoothing) +
        smoothedLat * bearingBasedSmoothing;
    final finalLng = position.longitude * (1 - bearingBasedSmoothing) +
        smoothedLng * bearingBasedSmoothing;

    // Update noise parameters based on filtered values
    updateNoiseParameters(
        filteredSpeed, 0.0); // elevation not needed for position filtering

    return LatLng(finalLat, finalLng);
  }

  double filterElevation(double elevation, DateTime timestamp) {
    return _elevationFilter.filterElevation(elevation, timestamp);
  }

  void reset() {
    _latFilter.reset();
    _lngFilter.reset();
    _speedFilter.reset();
    _bearingFilter.reset();
    _elevationFilter.reset();
  }
}
