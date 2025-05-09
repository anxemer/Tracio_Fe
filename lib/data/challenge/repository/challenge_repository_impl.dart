// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Tracio/data/challenge/models/request/create_challenge_req.dart';
import 'package:dartz/dartz.dart';

import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/data/challenge/source/challenge_api_service.dart';
import 'package:Tracio/domain/challenge/entities/challenge_entity.dart';
import 'package:Tracio/domain/challenge/entities/challenge_overview_response_entity.dart';
import 'package:Tracio/domain/challenge/repository/challenge_repository.dart';

import '../../../domain/challenge/entities/challenge_reward.dart';
import '../../../domain/challenge/entities/participants_response_entity.dart';
import '../models/response/challenge_model.dart';

class ChallengeRepositoryImpl extends ChallengeRepository {
  final ChallengeApiService remoteDataSource;
  ChallengeRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, ChallengeOverviewResponseEntity>>
      getChallengeOverview() async {
    try {
      var returnedData = await remoteDataSource.getChallengeOverview();
      return Right(returnedData);
    } on ServerFailure {
      return Left(ServerFailure(''));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, ChallengeEntity>> getChallengeDetail(
      int challengeId) async {
    try {
      var returnedData = await remoteDataSource.getChallengeDetail(challengeId);
      return Right(returnedData);
    } on ServerFailure {
      return Left(ServerFailure(''));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, int>> joinChallenge(int challengeId) async {
    try {
      var returnedData = await remoteDataSource.joinChallenge(challengeId);
      return Right(returnedData);
    } on ServerFailure {
      return Left(ServerFailure(''));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, ParticipantsResponseEntity>> getParticipants(
      int challengeId) async {
    try {
      var returnedData = await remoteDataSource.getParticipant(challengeId);
      return Right(returnedData);
    } on ServerFailure {
      return Left(ServerFailure(''));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, List<ChallengeRewardEntity>>> getUserReward(
      int userId) async {
    try {
      var returnedData = await remoteDataSource.getRewardUser(userId);
      return Right(returnedData);
    } on ServerFailure {
      return Left(ServerFailure(''));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, bool>> leaveChallenge(int challengeId) async {
    try {
      var returnedData = await remoteDataSource.leaveChallenge(challengeId);
      return Right(true);
    } on ServerFailure {
      return Left(ServerFailure(''));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, ChallengeEntity>> createChallenge(
      CreateChallengeReq challenge) async {
    try {
      var result = await remoteDataSource.creteChallenge(challenge);
      return Right(result);
    } on ServerFailure {
      return Left(ServerFailure(''));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, bool>> requestChallenge(int challengeId) async {
    try {
      await remoteDataSource.requestChallenge(challengeId);
      return Right(true);
    } on ServerFailure {
      return Left(ServerFailure(''));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }
}
