import 'package:Tracio/data/user/models/edit_user_profile_req.dart';
import 'package:Tracio/data/user/models/resolve_follow_request_req.dart';
import 'package:Tracio/domain/user/entities/daily_activity_entity.dart';
import 'package:Tracio/domain/user/entities/follow_request_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/domain/user/entities/user_profile_entity.dart';

abstract class UserProfileRepository {
  Future<Either<Failure, UserProfileEntity>> getUserProfile(int userId);
  Future<Either<Failure, List<FollowRequestEntity>>> getFollowRequest();
  Future<Either<Failure, UserProfileEntity>> editUserProfile(
      EditUserProfileReq userId);
  Future<Either<Failure, DailyActivityEntity>> getDailyActivity();
  Future<Either<Failure, bool>> followUser(int userId);
  Future<Either<Failure, bool>> resolveRequest(ResolveFollowRequestReq resolve);
  Future<Either<Failure, bool>> unFollowUser(int userId);
}
