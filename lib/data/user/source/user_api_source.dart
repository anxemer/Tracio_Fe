import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/data/user/models/daily_activity_model.dart';
import 'package:Tracio/data/user/models/follow_request_model.dart'
    show FollowRequestModel;
import 'package:Tracio/data/user/models/resolve_follow_request_req.dart';
import 'package:Tracio/data/user/models/send_fcm_req.dart';
import 'package:dartz/dartz.dart';
import 'package:Tracio/core/constants/api_url.dart';
import 'package:Tracio/core/network/dio_client.dart';
import 'package:Tracio/data/user/models/user_profile_model.dart';
import 'package:dio/dio.dart';

import '../../../core/erorr/exception.dart';
import '../../../service_locator.dart';
import '../models/edit_user_profile_req.dart';

abstract class UserApiSource {
  Future<UserprofileModel> getUserProfile(int userId);
  Future<Either> followUser(int userId);
  Future<Either> resolveFollowRequestUser(ResolveFollowRequestReq resolve);
  Future<Either> unFollowUser(int userId);
  Future<UserprofileModel> editProfile(EditUserProfileReq userProfile);
  Future<Either> sendFcm(SendFcmReq fcm);
  Future<DailyActivityModel> getDailyActivity();
  Future<List<FollowRequestModel>> getFollowRequest();
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
  Future<UserprofileModel> editProfile(EditUserProfileReq userProfile) async {
    var response =
        await sl<DioClient>().put(ApiUrl.userProfile, data: userProfile);
    if (response.statusCode == 200) {
      return UserprofileModel.fromJson(response.data['result']);
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
    } else if (response.statusCode == 401) {
      throw AuthenticationFailure('Unauthentication');
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

  @override
  Future<DailyActivityModel> getDailyActivity() async {
    var response = await sl<DioClient>()
        .get(ApiUrl.dailyActivity, queryParameters: {'getBy': 'Daily'});

    if (response.statusCode == 200) {
      final result = response.data['result'];

      if (result is List && result.isNotEmpty) {
        return DailyActivityModel.fromJson(result[0]);
      } else if (result is Map && result.containsKey('items')) {
        final items = result['items'];
        if (items is List && items.isNotEmpty) {
          return DailyActivityModel.fromJson(items[0]);
        }
      }

      // Nếu không có dữ liệu phù hợp
      throw Exception("No activity found.");
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<FollowRequestModel>> getFollowRequest() async {
    var response =
        await sl<DioClient>().get('${ApiUrl.follow}/follow-requests/pending');

    if (response.statusCode == 200) {
      return List<FollowRequestModel>.from(response.data['result']['items']
          .map((x) => FollowRequestModel.fromJson(x)));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Either> resolveFollowRequestUser(
      ResolveFollowRequestReq resolve) async {
    final formData = FormData.fromMap({
      "isApproved": resolve.isApproved,

      // "password": params.password,
    });
    var response = await sl<DioClient>().post(
        '${ApiUrl.follow}/respond/${resolve.followerId}',
        isMultipart: true,
        data: formData);
    if (response.statusCode == 200) {
      return Right(true);
    } else {
      throw ServerException();
    }
  }
}
