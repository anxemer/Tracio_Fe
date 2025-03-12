import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/domain/user/usecase/get_user_profile.dart';
import 'package:tracio_fe/presentation/profile/bloc/user_profile_state.dart';

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
}
