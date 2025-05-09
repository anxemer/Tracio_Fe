import 'package:dartz/dartz.dart';

abstract class ElevationRepository {
  Future<Either> postElevationFromPolylineEncoded(String encodedPolyline);
}
