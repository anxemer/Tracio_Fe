import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';

abstract class ImageRepository {
  Future<Either<Failure, Uint8List>> getUint8ListImageUrl(String imageUrl);
}
