import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/data/user/models/send_fcm_req.dart';
import 'package:dartz/dartz.dart';
import 'package:Tracio/core/constants/api_url.dart';
import 'package:Tracio/core/network/dio_client.dart';
import 'package:Tracio/data/user/models/user_profile_model.dart';

import '../../../core/erorr/exception.dart';
import '../../../service_locator.dart';
import '../models/edit_user_profile_req.dart';

abstract class UserApiSource {
  Future<UserprofileModel> getUserProfile(int userId);
  Future<Either> followUser(int userId);
  Future<Either> unFollowUser(int userId);
  Future<Either> editProfile(EditUserProfileReq userProfile);
  Future<Either> sendFcm(SendFcmReq fcm);
}

class UserApiSourceImpl extends UserApiSource {
  @override
  Future<UserprofileModel> getUserProfile(int userId) async {
    var response = await sl<DioClient>().get('${ApiUrl.userProfile}/$userId');

    if (response.statusCode == 200) {
      return UserprofileModel.fromJson(response.data['result']);
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

  @override
  Future<Either> editProfile(EditUserProfileReq userProfile) async {
    var response =
        await sl<DioClient>().put(ApiUrl.userProfile, data: userProfile);
    if (response.statusCode == 200) {
      return Right(true);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Either> sendFcm(SendFcmReq fcm) async {
    final dioClient = DioClient(baseUrl: ApiUrl.notiPort);
    final response = await dioClient.post('/api/fcm', data: fcm.toJson());
    if (response.statusCode == 201) {
      return Right(true);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Either> unFollowUser(int userId) async {
    try {
      var response =
          await sl<DioClient>().delete('${ApiUrl.follow}/unfollow/$userId');
      if (response.statusCode == 204) {
        return Right(true);
      } else {
        throw ServerException();
      }
    } on AuthenticationFailure catch (e) {
      throw AuthenticationFailure('');
    }
  }
}
