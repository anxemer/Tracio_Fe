import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/auth/models/change_role_req.dart';
import 'package:tracio_fe/data/auth/models/login_req.dart';
import 'package:tracio_fe/domain/auth/usecases/change_role.dart';
import 'package:tracio_fe/domain/auth/usecases/get_cacher_user.dart';
import 'package:tracio_fe/domain/auth/usecases/login.dart';
import 'package:tracio_fe/domain/auth/usecases/login_google.dart';
import 'package:tracio_fe/domain/auth/usecases/logout.dart';
import 'package:tracio_fe/presentation/auth/bloc/authCubit/auth_state.dart';

import '../../../../service_locator.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void login(LoginReq login) async {
    try {
      emit(AuthLoading());
      var result = await sl<LoginUseCase>().call(login);
      result.fold((failure) => emit(AuthFailure(failure)), (data) async {
        final result = await sl<GetCacherUserUseCase>().call(NoParams());
        result.fold(
          (err) => emit(AuthFailure(err)),
          (user) => emit(AuthLoaded(user: user)),
        );
      });
    } catch (e) {
      emit(AuthFailure(ExceptionFailure(e.toString())));
    }
  }

  void loginWithGoogle() async {
    try {
      emit(AuthLoading());
      var result = await sl<LoginGoogleUseCase>().call(NoParams());
      result.fold((failure) => emit(AuthFailure(failure)), (data) async {
        final result = await sl<GetCacherUserUseCase>().call(NoParams());
        result.fold(
          (err) => emit(AuthFailure(err)),
          (user) => emit(AuthLoaded(user: user)),
        );
      });
    } catch (e) {
      emit(AuthFailure(ExceptionFailure(e.toString())));
    }
  }

  Future<void> changeRole(ChangeRoleReq changeRole) async {
    try {
      emit(AuthLoading());
      var result = await sl<ChangeRoleUseCase>().call(changeRole);
      result.fold((failure) => emit(AuthFailure(failure)), (data) async {
        final result = await sl<GetCacherUserUseCase>().call(NoParams());
        result.fold(
          (err) => emit(AuthFailure(err)),
          (user) => emit(AuthChangeRole(user: user)),
        );
      });
    } catch (e) {
      emit(AuthFailure(ExceptionFailure(e.toString())));
    }
  }

  void logout() async {
    await sl<LogoutUseCase>().call(NoParams());
    emit(AuthLoggedOut());
  }

  void checkUser() async {
    try {
      emit(AuthLoading());
      final result = await sl<GetCacherUserUseCase>().call(NoParams());
      result.fold((error) => emit(AuthFailure(error)),
          (data) => emit(AuthLoaded(user: data)));
    } catch (e) {
      emit(AuthFailure(ExceptionFailure(e.toString())));
    }
  }
}
