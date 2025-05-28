import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/user/entities/user_profile_entity.dart';
import 'package:Tracio/domain/user/repositories/user_profile_repository.dart';

import '../../../service_locator.dart';

class UpdateAvatarUseCase extends Usecase<UserProfileEntity, File> {
  @override
  Future<Either<Failure, UserProfileEntity>> call(File params) async {
    return await sl<UserProfileRepository>().updateAvatar(params);
  }
}
