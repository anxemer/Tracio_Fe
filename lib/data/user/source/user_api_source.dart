import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/constants/api_url.dart';
import 'package:tracio_fe/core/network/dio_client.dart';
import 'package:tracio_fe/data/user/models/user_profile_model.dart';

import '../../../core/erorr/exception.dart';
import '../../../service_locator.dart';

abstract class UserApiSource {
  Future<UserprofileModel> getUserProfile(int userId);
  Future<Either> followUser(int userId);
}

class UserApiSourceImpl extends UserApiSource {
  @override
  Future<UserprofileModel> getUserProfile(int userId) async {
    var response = await sl<DioClient>().get('${ApiUrl.userProfile}/$userId');

    if (response.statusCode == 200) {
      return UserprofileModel.fromMap(response.data['result']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Either> followUser(int userId) async {
    var response = await sl<DioClient>().post('${ApiUrl.follow}/$userId');
    if (response.statusCode == 200) {
      return Right(true);
    } else {
      throw ServerException();
    }
  }
}
