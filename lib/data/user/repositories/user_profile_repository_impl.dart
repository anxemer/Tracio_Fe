import 'dart:io';

import 'package:Tracio/data/user/models/edit_user_profile_req.dart';
import 'package:Tracio/data/user/models/resolve_follow_request_req.dart';
import 'package:Tracio/domain/user/entities/daily_activity_entity.dart';
import 'package:Tracio/domain/user/entities/follow_entity.dart';
import 'package:Tracio/domain/user/entities/follow_response_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/exception.dart';
import 'package:Tracio/data/user/source/user_api_source.dart';
import 'package:Tracio/domain/user/entities/user_profile_entity.dart';
import 'package:Tracio/domain/user/repositories/user_profile_repository.dart';

import '../../../core/erorr/failure.dart';
import '../models/get_follow_req.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserApiSource dataSource;

  UserProfileRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile(int userId) async {
    try {
      final userProfile = await dataSource.getUserProfile(userId);
      return Right(userProfile);
    } on ServerException {
      return Left(ServerFailure('Get User profile failure'));
    }
  }

  @override
  Future<Either<Failure, bool>> followUser(int userId) async {
    try {
      await dataSource.followUser(userId);
      return Right(true);
    } on ServerException {
      return Left(ServerFailure('Get User profile failure'));
    } on AuthenticationFailure {
      throw AuthenticationFailure('UnAuthentication');
    }
  }

  @override
  Future<Either<Failure, bool>> unFollowUser(int userId) async {
    try {
      await dataSource.unFollowUser(userId);
      return Right(true);
    } on ServerException {
      return Left(ServerFailure('Get User profile failure'));
    } on AuthenticationFailure {
      throw AuthenticationFailure('UnAuthentication');
    }
  }

  @override
  Future<Either<Failure, DailyActivityEntity>> getDailyActivity() async {
    try {
      final userProfile = await dataSource.getDailyActivity();
      return Right(userProfile);
    } on ServerException {
      return Left(ServerFailure('Get User profile failure'));
    } on AuthenticationFailure {
      throw AuthenticationFailure('UnAuthentication');
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> editUserProfile(
      EditUserProfileReq user) async {
    try {
      final userProfile = await dataSource.editProfile(user);
      return Right(userProfile);
    } on ServerException {
      return Left(ServerFailure('Get User profile failure'));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthentication'));
    }
  }

  @override
  Future<Either<Failure, List<FollowEntity>>> getFollowRequest() async {
    try {
      final follow = await dataSource.getFollowRequest();
      return Right(follow);
    } on ServerException {
      return Left(ServerFailure('Get User profile failure'));
    }
  }

  @override
  Future<Either<Failure, bool>> resolveRequest(
      ResolveFollowRequestReq resolve) async {
    try {
      await dataSource.resolveFollowRequestUser(resolve);
      return Right(true);
    } on ServerException {
      return Left(ServerFailure('Get User profile failure'));
    } on AuthenticationFailure {
      throw AuthenticationFailure('UnAuthentication');
    }
  }

  @override
  Future<Either<Failure, FollowResponseEntity>> getFollower(
      GetFollowReq params) async {
    try {
      final follow = await dataSource.getFollower(params);
      return Right(follow);
    } on ServerException {
      return Left(ServerFailure('Get User profile failure'));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('Unauthentication'));
    }
  }

  @override
  Future<Either<Failure, FollowResponseEntity>> getFollowing(
      GetFollowReq params) async {
    try {
      final follow = await dataSource.getFollowing(params);
      return Right(follow);
    } on ServerException {
      return Left(ServerFailure('Get User profile failure'));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('Unauthentication'));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> updateAvatar(File avatar) async {
    try {
      final userProfile = await dataSource.updateAvatar(avatar);
      return Right(userProfile);
    } on ServerException {
      return Left(ServerFailure('Get User profile failure'));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthentication'));
    }
  }
}
