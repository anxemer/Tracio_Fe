import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/domain/user/entities/user_profile_entity.dart';

abstract class UserProfileRepository {
  Future<Either<Failure,UserProfileEntity>> getUserProfile(int userId);
}
