import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/exception.dart';
import 'package:tracio_fe/data/user/source/user_api_source.dart';
import 'package:tracio_fe/domain/user/entities/user_profile_entity.dart';
import 'package:tracio_fe/domain/user/repositories/user_profile_repository.dart';

import '../../../core/erorr/failure.dart';

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
}
