import 'package:Tracio/domain/user/entities/follow_request_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/user/repositories/user_profile_repository.dart';

import '../../../service_locator.dart';

class GetFollowRequestUseCase
    extends Usecase<List<FollowRequestEntity>, NoParams> {
  @override
  Future<Either<Failure, List<FollowRequestEntity>>> call(params) async {
    return await sl<UserProfileRepository>().getFollowRequest();
  }
}
