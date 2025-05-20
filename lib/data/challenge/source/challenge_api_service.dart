import 'package:Tracio/data/challenge/models/request/create_challenge_req.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/data/challenge/models/response/challenge_model.dart';
import 'package:Tracio/data/challenge/models/response/challenge_overview_response.dart';
import 'package:Tracio/data/challenge/models/response/participants_response_model.dart';

import '../../../core/constants/api_url.dart';
import '../../../core/network/dio_client.dart';
import '../../../domain/challenge/entities/challenge_reward.dart';
import '../../../service_locator.dart';
import '../models/response/challenge_reward_model.dart';

abstract class ChallengeApiService {
  Future<ChallengeOverviewResponseModel> getChallengeOverview();
  Future<ChallengeModel> getChallengeDetail(int challengeId);
  Future<List<ChallengeRewardEntity>> getRewardUser(int userId);
  Future<int> joinChallenge(int challengeId);
  Future<Either> leaveChallenge(int challengeId);
  Future<ChallengeModel> creteChallenge(CreateChallengeReq challenge);
  Future<Either> requestChallenge(int challengeId);
  Future<ParticipantsResponseModel> getParticipant(int challengeId);
}

class ChallengeApiServiceImpl extends ChallengeApiService {
  @override
  Future<ChallengeOverviewResponseModel> getChallengeOverview() async {
    try {
      var response = await sl<DioClient>().get(ApiUrl.getChallengeOverview);
      if (response.statusCode == 200) {
        return ChallengeOverviewResponseModel.fromMap(response.data['result']);
      }
      if (response.statusCode == 401) {
        throw AuthenticationFailure('');
      }
      throw throw ExceptionFailure('');
    } on DioException catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ChallengeModel> getChallengeDetail(int challengeId) async {
    try {
      var response =
          await sl<DioClient>().get('${ApiUrl.apiChallenge}/$challengeId');
      if (response.statusCode == 200) {
        return ChallengeModel.fromJson(response.data['result']);
      }
      if (response.statusCode == 401) {
        throw AuthenticationFailure('');
      }
      throw throw ExceptionFailure('');
    } on DioException catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<int> joinChallenge(int challengeId) async {
    try {
      var response = await sl<DioClient>()
          .post('${ApiUrl.apiChallenge}/$challengeId/invitation/request');
      if (response.statusCode == 200) {
        final data = response.data['result'];
        final int joinedChallengeId = data['challengeId'];
        return joinedChallengeId;
      }
      if (response.statusCode == 401) {
        throw AuthenticationFailure('');
      }
      throw throw ExceptionFailure('');
    } on DioException catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ParticipantsResponseModel> getParticipant(int challengeId) async {
    try {
      var response = await sl<DioClient>()
          .get('${ApiUrl.apiChallenge}/$challengeId/participant');
      if (response.statusCode == 200) {
        return ParticipantsResponseModel.fromMap(response.data['result']);
      }
      if (response.statusCode == 401) {
        throw AuthenticationFailure('');
      }
      throw throw ExceptionFailure('');
    } on DioException catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<ChallengeRewardModel>> getRewardUser(int userId) async {
    try {
      final queryParams = {
        "userId": userId.toString(),
      };
      Uri apiUrl = ApiUrl.urlGetBlog(queryParams);
      var response = await sl<DioClient>().get(apiUrl.toString());
      if (response.statusCode == 200) {
        final items = response.data['result']['items'];
        if (items != null) {
          return List<ChallengeRewardModel>.from(
              items.map((c) => ChallengeRewardModel.fromJson(c)));
        } else {
          return [];
        }
      }
      if (response.statusCode == 401) {
        throw AuthenticationFailure('');
      }
      throw throw ExceptionFailure('');
    } on DioException catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<Either> leaveChallenge(int challengeId) async {
    try {
      await sl<DioClient>()
          .delete('${ApiUrl.apiChallenge}/$challengeId/participant/leave');

      return Right(true);
    } on DioException catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ChallengeModel> creteChallenge(CreateChallengeReq challenge) async {
    try {
      var response = await sl<DioClient>()
          .post(ApiUrl.apiChallenge, data: challenge.toJson());

      if (response.statusCode == 201) {
        return ChallengeModel.fromJson(response.data['result']);
      } else {
        throw AuthorizationFailure(
            response.data['message'], response.statusCode!);
      }
    } on DioException catch (e) {
      throw ServerFailure(e.toString());
    } on AuthenticationFailure catch (e) {
      throw AuthenticationFailure(e.message);
    }
  }

  @override
  Future<Either> requestChallenge(int challengeId) async {
    try {
      await sl<DioClient>().patch('${ApiUrl.requestChallenge}/$challengeId');

      return Right(true);
    } on DioException catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
