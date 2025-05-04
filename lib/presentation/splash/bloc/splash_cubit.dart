import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/auth/sources/auth_local_source/auth_local_source.dart';
import 'package:tracio_fe/domain/auth/usecases/is_logged_in.dart';
import 'package:tracio_fe/presentation/splash/bloc/splash_state.dart';
import 'package:tracio_fe/service_locator.dart';

import '../../../domain/auth/usecases/get_cacher_user.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashLoading());

  void appStarted() async {
    await Future.delayed(Duration(seconds: 2));
    var isLoggedIn = await sl<IsLoggedInUseCase>().call(NoParams());
    isLoggedIn.fold((error) {
      sl<AuthLocalSource>().clearCache();
      emit(UnAuthenticated());
    }, (data) {
      emit(Authenticated(role: data));
    });
  }
  void checkUser() async {
    try {
      final result = await sl<GetCacherUserUseCase>().call(NoParams());
      result.fold((error) => emit(UnAuthenticated()),
          (data) => emit(Authenticated(role:  data.role!)));
    } catch (e) {
      emit((UnAuthenticated()));
    }
  }
}
