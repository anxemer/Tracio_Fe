import 'package:Tracio/data/user/models/edit_user_profile_req.dart';
import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/user/entities/user_profile_entity.dart';
import 'package:Tracio/domain/user/repositories/user_profile_repository.dart';

import '../../../service_locator.dart';

class EditUserProfileUseCase
    extends Usecase<UserProfileEntity, EditUserProfileReq> {
  @override
  Future<Either<Failure, UserProfileEntity>> call(
      EditUserProfileReq params) async {
    return await sl<UserProfileRepository>().editUserProfile(params);
  }
}
