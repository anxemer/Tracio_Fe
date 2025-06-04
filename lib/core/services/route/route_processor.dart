import 'dart:math';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'kalman_filter.dart';
import 'stop_detector.dart';
import 'jump_detector.dart';

class RouteProcessor {
  // Cycling-specific parameters
  static const double _defaultSmoothingFactor =
      0.2; // Reduced for sharper turns
  static const double _defaultMaxGapDistance = 50.0; // meters
  static const int _defaultMinPointsForSmoothing = 3;
  static const int _defaultUpdateInterval = 1; // seconds - faster updates
  static const int _defaultMinPointsForUpdate = 2; // Reduced for faster updates
  static const double _defaultDouglasPeuckerEpsilon = 0.00003; // ~3 meters

  // Configurable parameters
  final double smoothingFactor;
  final double maxGapDistance;
  final int minPointsForSmoothing;
  final int updateInterval;
  final int minPointsForUpdate;
  final double douglasPeuckerEpsilon;
  final bool enableElevationFiltering;

  // Diagnostics
  int _rawPointsCount = 0;
  int _filteredPointsCount = 0;
  int _jumpRejections = 0;
  int _stopRejections = 0;
  double _totalElevationGain = 0.0;
  double _lastElevation = 0.0;

  final PositionKalmanFilter _kalmanFilter;
  final StopDetector _stopDetector;
  final JumpDetector _jumpDetector;
  final List<Point> _accumulatedPoints = [];
  DateTime? _lastUpdateTime;

  RouteProcessor({
    this.smoothingFactor = _defaultSmoothingFactor,
    this.maxGapDistance = _defaultMaxGapDistance,
    this.minPointsForSmoothing = _defaultMinPointsForSmoothing,
    this.updateInterval = _defaultUpdateInterval,
    this.minPointsForUpdate = _defaultMinPointsForUpdate,
    this.douglasPeuckerEpsilon = _defaultDouglasPeuckerEpsilon,
    this.enableElevationFiltering = true,
    double processNoise = 0.1,
    double measurementNoise = 0.1,
  })  : _kalmanFilter = PositionKalmanFilter(
          processNoise: processNoise,
          measurementNoise: measurementNoise,
        ),
        _stopDetector = StopDetector(),
        _jumpDetector = JumpDetector();

  /// Process a single point and return a processed chunk if ready
  ProcessedChunk? processPoint(
      LatLng position, double speed, double bearing, DateTime timestamp,
      {double? elevation}) {
    _rawPointsCount++;

    // Check for GPS jumps
    if (_jumpDetector.isJump(position, speed, timestamp)) {
      _jumpRejections++;
      return null;
    }

    // Check if stopped
    if (_stopDetector.isStopped(speed, position, timestamp)) {
      _stopRejections++;
      return null;
    }

    // Apply Kalman filter
    final filteredPosition = _kalmanFilter.filterPosition(
      position,
      speed,
      bearing,
      timestamp,
    );

    // Process elevation if available
    if (elevation != null && enableElevationFiltering) {
      final filteredElevation =
          _kalmanFilter.filterElevation(elevation, timestamp);
      _updateElevationGain(filteredElevation);
    }

    // Convert to Mapbox Point
    final point = Point(
        coordinates:
            Position(filteredPosition.longitude, filteredPosition.latitude));
    _accumulatedPoints.add(point);
    _filteredPointsCount++;

    // Check if we should update the route
    if (_shouldUpdateRoute(timestamp)) {
      final processedPoints = _processAccumulatedPoints();
      _accumulatedPoints.clear();
      _lastUpdateTime = timestamp;
      return processedPoints;
    }

    return null;
  }

  void _updateElevationGain(double currentElevation) {
    if (_lastElevation == 0.0) {
      _lastElevation = currentElevation;
      return;
    }

    final elevationDiff = currentElevation - _lastElevation;
    if (elevationDiff > 0) {
      _totalElevationGain += elevationDiff;
    }
    _lastElevation = currentElevation;
  }

  bool _shouldUpdateRoute(DateTime timestamp) {
    if (_lastUpdateTime == null) {
      return _accumulatedPoints.length >= minPointsForUpdate;
    }

    final timeSinceLastUpdate = timestamp.difference(_lastUpdateTime!);
    return timeSinceLastUpdate.inSeconds >= updateInterval ||
        _accumulatedPoints.length >= minPointsForUpdate;
  }

  ProcessedChunk? _processAccumulatedPoints() {
    if (_accumulatedPoints.isEmpty) return null;

    final smoothedPoints = smoothRoute(_accumulatedPoints);
    final gapHandledPoints = handleGaps(smoothedPoints);
    final simplifiedPoints =
        simplifyRoute(gapHandledPoints, douglasPeuckerEpsilon);

    return ProcessedChunk(
      points: simplifiedPoints,
      timestamp: DateTime.now(),
      diagnostics: RouteDiagnostics(
        rawPointsCount: _rawPointsCount,
        filteredPointsCount: _filteredPointsCount,
        jumpRejections: _jumpRejections,
        stopRejections: _stopRejections,
        totalElevationGain: _totalElevationGain,
      ),
    );
  }

  /// Smooths a list of points using a moving average filter
  List<Point> smoothRoute(List<Point> points) {
    if (points.length < minPointsForSmoothing) return points;

    final smoothedPoints = <Point>[];
    smoothedPoints.add(points.first);

    for (int i = 1; i < points.length - 1; i++) {
      final prev = points[i - 1];
      final current = points[i];
      final next = points[i + 1];

      final double smoothedX = current.coordinates.lng +
          smoothingFactor *
              ((prev.coordinates.lng + next.coordinates.lng) / 2 -
                  current.coordinates.lng);
      final double smoothedY = current.coordinates.lat +
          smoothingFactor *
              ((prev.coordinates.lat + next.coordinates.lat) / 2 -
                  current.coordinates.lat);

      smoothedPoints.add(Point(coordinates: Position(smoothedX, smoothedY)));
    }

    smoothedPoints.add(points.last);
    return smoothedPoints;
  }

  /// Detects and handles gaps in the route
  List<Point> handleGaps(List<Point> points) {
    if (points.length < 2) return points;

    final processedPoints = <Point>[];
    processedPoints.add(points.first);

    for (int i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final current = points[i];

      final distance = _calculateDistance(prev, current);
      if (distance > maxGapDistance) {
        // Add intermediate points to fill the gap
        final numPoints = (distance / maxGapDistance).ceil();
        for (int j = 1; j < numPoints; j++) {
          final double fraction = j / numPoints;
          final double interpolatedX = prev.coordinates.lng +
              (current.coordinates.lng - prev.coordinates.lng) * fraction;
          final double interpolatedY = prev.coordinates.lat +
              (current.coordinates.lat - prev.coordinates.lat) * fraction;
          processedPoints
              .add(Point(coordinates: Position(interpolatedX, interpolatedY)));
        }
      }
      processedPoints.add(current);
    }

    return processedPoints;
  }

  /// Simplifies the route using Douglas-Peucker algorithm
  List<Point> simplifyRoute(List<Point> points, double epsilon) {
    if (points.length <= 2) return points;

    double maxDistance = 0;
    int index = 0;

    for (int i = 1; i < points.length - 1; i++) {
      final distance = _pointToLineDistance(
        points[i],
        points.first,
        points.last,
      );
      if (distance > maxDistance) {
        index = i;
        maxDistance = distance;
      }
    }

    if (maxDistance > epsilon) {
      final firstLine = simplifyRoute(points.sublist(0, index + 1), epsilon);
      final secondLine = simplifyRoute(points.sublist(index), epsilon);
      return [...firstLine.sublist(0, firstLine.length - 1), ...secondLine];
    }

    return [points.first, points.last];
  }

  /// Converts LatLng to Point
  Point latLngToPoint(LatLng latLng) {
    return Point(coordinates: Position(latLng.longitude, latLng.latitude));
  }

  /// Converts Point to LatLng
  LatLng pointToLatLng(Point point) {
    return LatLng(
      point.coordinates.lat.toDouble(),
      point.coordinates.lng.toDouble(),
    );
  }

  /// Calculates distance between two points in meters
  double _calculateDistance(Point point1, Point point2) {
    const double earthRadius = 6371000; // meters
    final double lat1 = point1.coordinates.lat * pi / 180;
    final double lat2 = point2.coordinates.lat * pi / 180;
    final double dLat =
        (point2.coordinates.lat - point1.coordinates.lat) * pi / 180;
    final double dLng =
        (point2.coordinates.lng - point1.coordinates.lng) * pi / 180;

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLng / 2) * sin(dLng / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// Calculates distance from a point to a line segment
  double _pointToLineDistance(Point point, Point lineStart, Point lineEnd) {
    final double x = point.coordinates.lng.toDouble();
    final double y = point.coordinates.lat.toDouble();
    final double x1 = lineStart.coordinates.lng.toDouble();
    final double y1 = lineStart.coordinates.lat.toDouble();
    final double x2 = lineEnd.coordinates.lng.toDouble();
    final double y2 = lineEnd.coordinates.lat.toDouble();

    final double A = x - x1;
    final double B = y - y1;
    final double C = x2 - x1;
    final double D = y2 - y1;

    final double dot = A * C + B * D;
    final double lenSq = C * C + D * D;
    double param = -1;

    if (lenSq != 0) {
      param = dot / lenSq;
    }

    double xx, yy;

    if (param < 0) {
      xx = x1;
      yy = y1;
    } else if (param > 1) {
      xx = x2;
      yy = y2;
    } else {
      xx = x1 + param * C;
      yy = y1 + param * D;
    }

    final double dx = x - xx;
    final double dy = y - yy;

    return sqrt(dx * dx + dy * dy);
  }

  /// Converts the route to GeoJSON format
  Map<String, dynamic> toGeoJSON(List<Point> points) {
    final coordinates = points
        .map((point) => [
              point.coordinates.lng.toDouble(),
              point.coordinates.lat.toDouble(),
            ])
        .toList();

    return {
      'type': 'Feature',
      'geometry': {
        'type': 'LineString',
        'coordinates': coordinates,
      },
      'properties': {
        'timestamp': DateTime.now().toIso8601String(),
        'diagnostics': {
          'rawPointsCount': _rawPointsCount,
          'filteredPointsCount': _filteredPointsCount,
          'jumpRejections': _jumpRejections,
          'stopRejections': _stopRejections,
          'totalElevationGain': _totalElevationGain,
        },
      },
    };
  }

  /// Get current diagnostics
  RouteDiagnostics get diagnostics => RouteDiagnostics(
        rawPointsCount: _rawPointsCount,
        filteredPointsCount: _filteredPointsCount,
        jumpRejections: _jumpRejections,
        stopRejections: _stopRejections,
        totalElevationGain: _totalElevationGain,
      );

  void reset() {
    _kalmanFilter.reset();
    _stopDetector.reset();
    _jumpDetector.reset();
    _accumulatedPoints.clear();
    _lastUpdateTime = null;
    _rawPointsCount = 0;
    _filteredPointsCount = 0;
    _jumpRejections = 0;
    _stopRejections = 0;
    _totalElevationGain = 0.0;
    _lastElevation = 0.0;
  }
}

/// Represents a chunk of processed route points
class ProcessedChunk {
  final List<Point> points;
  final DateTime timestamp;
  final RouteDiagnostics diagnostics;

  ProcessedChunk({
    required this.points,
    required this.timestamp,
    required this.diagnostics,
  });
}

/// Contains diagnostic information about route processing
class RouteDiagnostics {
  final int rawPointsCount;
  final int filteredPointsCount;
  final int jumpRejections;
  final int stopRejections;
  final double totalElevationGain;

  RouteDiagnostics({
    required this.rawPointsCount,
    required this.filteredPointsCount,
    required this.jumpRejections,
    required this.stopRejections,
    this.totalElevationGain = 0.0,
  });

  double get filterRatio =>
      rawPointsCount > 0 ? filteredPointsCount / rawPointsCount : 0.0;

  double get rejectionRatio => rawPointsCount > 0
      ? (jumpRejections + stopRejections) / rawPointsCount
      : 0.0;
}
