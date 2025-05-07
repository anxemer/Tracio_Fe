import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/domain/user/entities/user_profile_entity.dart';

abstract class UserProfileRepository {
  Future<Either<Failure,UserProfileEntity>> getUserProfile(int userId);
  Future<Either<Failure,bool>> followUser(int userId);
}
