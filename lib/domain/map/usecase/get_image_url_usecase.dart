import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/map/repositories/image_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class GetImageUrlUsecase extends Usecase<dynamic, String> {
  @override
  Future<Either<Failure, Uint8List>> call(String params) async {
    return await sl<ImageRepository>().getUint8ListImageUrl(params);
  }
}
