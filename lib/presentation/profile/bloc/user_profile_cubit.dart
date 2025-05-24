import 'dart:io';

import 'package:Tracio/data/user/models/edit_user_profile_req.dart';
import 'package:Tracio/domain/user/usecase/edit_profile.dart';
import 'package:Tracio/domain/user/usecase/update_avatar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/domain/user/usecase/get_user_profile.dart';
import 'package:Tracio/presentation/profile/bloc/user_profile_state.dart';

import '../../../domain/user/entities/user_profile_entity.dart';
import '../../../service_locator.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit() : super(UserProfileInitial());

  Future<void> getUserProfile(int userId) async {
    emit(UserProfileLoading());

    var resutl = await sl<GetUserProfileUseCase>().call(userId);
    resutl.fold((erorr) {
      emit(UserProileFailure());
    }, (data) {
      emit(UserProfileLoaded(userProfileEntity: data));
    });
  }

 Future<void> updateUserProfile({
    required EditUserProfileReq profileReq,
    File? newAvatarFile,
  }) async {
    emit(UserProfileLoading());

    // Gọi API update profile
    final profileResult = await sl<EditUserProfileUseCase>().call(profileReq);

    if (profileResult.isLeft()) {
      emit(UserProileFailure());
      return;
    }

    UserProfileEntity userProfile = profileResult.getOrElse(() => throw Exception("Empty"));

    // Nếu có ảnh mới → gọi API update avatar
    if (newAvatarFile != null) {
      final avatarResult = await sl<UpdateAvatarUseCase>().call(newAvatarFile);

      if (avatarResult.isLeft()) {
        emit(UserProileFailure());
        return;
      }

      userProfile = avatarResult.getOrElse(() => throw Exception("Empty"));
    }

    emit(UserProfileLoaded(userProfileEntity: userProfile));
  }

  Future<void> updateAvatar(File avatar) async {
    emit(UserProfileLoading());

    var resutl = await sl<UpdateAvatarUseCase>().call(avatar);
    resutl.fold((erorr) {
      emit(UserProileFailure());
    }, (data) {
      emit(UserProfileLoaded(userProfileEntity: data));
    });
  }
}
