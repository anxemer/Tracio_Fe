import 'dart:math';

class Point {
  final double x;
  final double y;

  Point(this.x, this.y);
}

class DouglasPeucker {
  static List<Point> simplify(List<Point> points,
      {double tolerance = 1, bool highestQuality = false}) {
    if (points.length < 2) return points;

    final double sqTolerance = pow(tolerance, 2) as double;

    if (!highestQuality) {
      points = simplifyRadialDistance(points, sqTolerance);
    }

    return simplifyDouglasPeucker(points, sqTolerance);
  }

  static List<Point> simplifyRadialDistance(
      List<Point> points, double sqTolerance) {
    Point prevPoint = points[0];
    List<Point> newPoints = [prevPoint];

    for (var point in points) {
      if (getSquareDistance(point, prevPoint) > sqTolerance) {
        newPoints.add(point);
        prevPoint = point;
      }
    }

    return newPoints;
  }

  static double getSquareDistance(Point p1, Point p2) {
    final dx = p1.x - p2.x;
    final dy = p1.y - p2.y;
    return (dx * dx) + (dy * dy);
  }

  static double getSquareSegmentDistance(Point p, Point p1, Point p2) {
    double x = p1.x;
    double y = p1.y;
    double dx = p2.x - x;
    double dy = p2.y - y;

    if (dx != 0 || dy != 0) {
      final double t = ((p.x - x) * dx + (p.y - y) * dy) / (dx * dx + dy * dy);
      if (t > 1) {
        x = p2.x;
        y = p2.y;
      } else if (t > 0) {
        x += dx * t;
        y += dy * t;
      }
    }

    dx = p.x - x;
    dy = p.y - y;
    return dx * dx + dy * dy;
  }

  static List<Point> simplifyDouglasPeucker(
      List<Point> points, double sqTolerance) {
    final int len = points.length;
    List<bool> markers = List<bool>.filled(len, false);

    markers[0] = markers[len - 1] = true;
    List<int> firstStack = [];
    List<int> lastStack = [];

    firstStack.add(0);
    lastStack.add(len - 1);

    while (firstStack.isNotEmpty) {
      int first = firstStack.removeLast();
      int last = lastStack.removeLast();
      double maxSqDist = 0;
      int index = 0;

      for (int i = first + 1; i < last; i++) {
        double sqDist =
            getSquareSegmentDistance(points[i], points[first], points[last]);
        if (sqDist > maxSqDist) {
          index = i;
          maxSqDist = sqDist;
        }
      }

      if (maxSqDist > sqTolerance) {
        markers[index] = true;
        firstStack.add(first);
        lastStack.add(index);
        firstStack.add(index);
        lastStack.add(last);
      }
    }

    List<Point> newPoints = [];
    for (int i = 0; i < len; i++) {
      if (markers[i]) newPoints.add(points[i]);
    }

    return newPoints;
  }
}
