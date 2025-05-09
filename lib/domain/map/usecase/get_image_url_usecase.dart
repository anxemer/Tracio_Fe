import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/map/repositories/image_repository.dart';
import 'package:Tracio/service_locator.dart';

class GetImageUrlUsecase extends Usecase<dynamic, String> {
  @override
  Future<Either<Failure, Uint8List>> call(String params) async {
    return await sl<ImageRepository>().getUint8ListImageUrl(params);
  }
}
