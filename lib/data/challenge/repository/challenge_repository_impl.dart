// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/data/challenge/source/challenge_api_service.dart';
import 'package:tracio_fe/domain/challenge/entities/challenge_entity.dart';
import 'package:tracio_fe/domain/challenge/entities/challenge_overview_response_entity.dart';
import 'package:tracio_fe/domain/challenge/repository/challenge_repositories.dart';

import '../../../domain/challenge/entities/participants_response_entity.dart';

class ChallengeRepositoryImpl extends ChallengeRepositories {
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
  Future<Either<Failure, bool>> joinChallenge(int challengeId) async {
    try {
      var returnedData = await remoteDataSource.joinChallenge(challengeId);
      return Right(true);
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
  Future<Either<Failure, ChallengeEntity>> getRewardUser(int userId) async {
    try {
      var returnedData = await remoteDataSource.getRewardUser(userId);
      return Right(returnedData);
    } on ServerFailure {
      return Left(ServerFailure(''));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }
}
