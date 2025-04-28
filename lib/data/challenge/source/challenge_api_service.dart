import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/data/challenge/models/response/challenge_model.dart';
import 'package:tracio_fe/data/challenge/models/response/challenge_overview_response.dart';
import 'package:tracio_fe/data/challenge/models/response/participants_models.dart';
import 'package:tracio_fe/data/challenge/models/response/participants_response_model.dart';

import '../../../core/constants/api_url.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';

abstract class ChallengeApiService {
  Future<ChallengeOverviewResponseModel> getChallengeOverview();
  Future<ChallengeModel> getChallengeDetail(int challengeId);
  Future<Either> joinChallenge(int challengeId);
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
  Future<Either> joinChallenge(int challengeId) async {
    try {
      var response = await sl<DioClient>()
          .post('${ApiUrl.apiChallenge}/$challengeId/invitation/request');
      if (response.statusCode == 200) {
        return Right(true);
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
}
