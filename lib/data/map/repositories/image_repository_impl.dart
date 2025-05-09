import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/data/map/source/image_url_api_service.dart';
import 'package:Tracio/domain/map/repositories/image_repository.dart';
import 'package:Tracio/service_locator.dart';

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
