import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/data/map/source/image_url_api_service.dart';
import 'package:tracio_fe/domain/map/repositories/image_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class ImageRepositoryImpl extends ImageRepository {
  @override
  Future<Either<Failure, Uint8List>> getUint8ListImageUrl(
      String imageUrl) async {
    var returnedData =
        await sl<ImageUrlApiService>().getUint8ListImageUrl(imageUrl);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }
}
