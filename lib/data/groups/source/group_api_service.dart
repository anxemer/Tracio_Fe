import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tracio_fe/core/constants/api_url.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/network/dio_client.dart';
import 'package:tracio_fe/data/groups/models/request/post_group_req.dart';
import 'package:tracio_fe/service_locator.dart';

abstract class GroupApiService {
  Future<Either<Failure, dynamic>> createGroup(PostGroupReq request);
  //  Future<Either<Failure, dynamic>> getGroups();
  // Future<Either<Failure, dynamic>> updateGroupInvitation();
  // Future<Either<Failure, dynamic>> updateGroupRequestJoin();
}

class GroupApiServiceImpl extends GroupApiService {
  @override
  Future<Either<Failure, dynamic>> createGroup(PostGroupReq request) async {
    try {
      FormData formData = await request.toFormData();
      var response = await sl<DioClient>()
          .post(ApiUrl.postGroup, data: formData, isMultipart: true);

      if (response.statusCode == 201) {
        return right(response.data);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(ExceptionFailure(
          e.response?.data ?? e.message ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }
}
