import 'dart:io';

import 'package:Tracio/core/services/notifications/firebase_message_service.dart';
import 'package:Tracio/data/user/models/send_fcm_req.dart';
import 'package:Tracio/domain/auth/usecases/send_fcm.dart';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/auth/models/change_role_req.dart';
import 'package:Tracio/data/auth/models/login_req.dart';

import 'package:Tracio/domain/auth/usecases/change_role.dart';
import 'package:Tracio/domain/auth/usecases/get_cacher_user.dart';
import 'package:Tracio/domain/auth/usecases/login.dart';
import 'package:Tracio/domain/auth/usecases/login_google.dart';
import 'package:Tracio/domain/auth/usecases/logout.dart';
import 'package:Tracio/presentation/auth/bloc/authCubit/auth_state.dart';

import '../../../../data/auth/sources/auth_local_source/auth_local_source.dart';
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

  void refreshToken() async {
    try {
      emit(AuthLoading());

      final refreshToken = await sl<AuthLocalSource>().getRefreshToken();

      if (refreshToken.isEmpty) {
        emit(AuthLoggedOut()); // Không có token => về Login
        return;
      }

      final result = await sl<ChangeRoleUseCase>()
          .call(ChangeRoleReq(refreshToken: refreshToken, role: 'user'));

      await result.fold(
        (failure) async {
          emit(AuthFailure(failure));
        },
        (data) async {
          final userResult = await sl<GetCacherUserUseCase>().call(NoParams());
          userResult.fold(
            (err) => emit(AuthFailure(err)),
            (user) => emit(AuthLoaded(user: user)),
          );
        },
      );
    } catch (e) {
      emit(AuthFailure(ExceptionFailure(e.toString())));
    }
  }

  void checkUser() async {
    try {
      emit(AuthLoading());
      final result = await sl<GetCacherUserUseCase>().call(NoParams());
      result.fold((error) => emit(AuthFailure(error)),
          (data) => emit(AuthLoaded(user: data)));
    } catch (e) {
      emit(AuthFailure(AuthenticationFailure(e.toString())));
    }
  }

  void sendFcm() async {
    try {
      final deviceId = await _getId();
      final token = await FirebaseMessaging.instance.getToken();
      emit(AuthLoading());
      final result = await sl<SendFcmUseCase>()
          .call(SendFcmReq(deviceId: deviceId!, fcmToken: token!));
      result.fold(
          (error) => emit(AuthFailure(error)), (data) => emit(AuthLoaded()));
    } catch (e) {
      emit(AuthFailure(ExceptionFailure(e.toString())));
    }
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return AndroidId().getId(); // unique ID on Android
    }
  }
}
