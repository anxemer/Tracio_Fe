import 'package:Tracio/domain/user/entities/follow_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/user/repositories/user_profile_repository.dart';

import '../../../service_locator.dart';

class GetFollowingUseCase extends Usecase<List<FollowEntity>, int> {
  @override
  Future<Either<Failure, List<FollowEntity>>> call(params) async {
    return await sl<UserProfileRepository>().getFollowing(params);
  }
}
