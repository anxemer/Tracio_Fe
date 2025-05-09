import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:Tracio/core/erorr/failure.dart';

abstract class ImageUrlApiService {
  Future<Either<Failure, Uint8List>> getUint8ListImageUrl(String imageUrl);
}

class ImageUrlApiServiceImpl extends ImageUrlApiService {
  @override
  Future<Either<Failure, Uint8List>> getUint8ListImageUrl(
      String imageUrl) async {
    try {
      final dio = Dio();
      var response = await dio.get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200) {
        final bytes = Uint8List.fromList(response.data!);
        return Right(bytes);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return Left(ExceptionFailure(
          e.response?.data ?? e.message ?? 'An error occurred'));
    } catch (e) {
      return left(
          ExceptionFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
