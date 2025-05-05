import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/constants/api_url.dart';
import 'package:tracio_fe/core/network/dio_client.dart';
import 'package:tracio_fe/data/user/models/user_profile_model.dart';

import '../../../core/erorr/exception.dart';
import '../../../service_locator.dart';
import '../models/edit_user_profile_req.dart';

abstract class UserApiSource {
  Future<UserprofileModel> getUserProfile(int userId);
  Future<Either> followUser(int userId);
  Future<Either> editProfile(EditUserProfileReq userProfile);
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
  Future<Either> editProfile(EditUserProfileReq userProfile) async{
     var response = await sl<DioClient>().put(ApiUrl.userProfile,data: userProfile);
    if (response.statusCode == 200) {
      return Right(true);
    } else {
      throw ServerException();
    }
  }
}
