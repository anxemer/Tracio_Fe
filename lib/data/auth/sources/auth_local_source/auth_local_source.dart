import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracio_fe/data/auth/models/user_model.dart';

import '../../../../core/erorr/exception.dart';
import '../../../../service_locator.dart';

abstract class AuthLocalSource {
  Future<String> getToken();
  Future<UserModel> getUser();
  Future<void> saveToken(String token);
  Future<void> saveUser(UserModel user);
  Future<void> clearCache();
}

const cachedToken = 'TOKEN';
const cachedUser = 'USER';

class AuthLocalSourceImp extends AuthLocalSource {
  AuthLocalSourceImp();

  @override
  Future<String> getToken() async {
    String? token = await sl<FlutterSecureStorage>().read(key: cachedToken);
    // print(token);
    if (token != null) {
      return Future.value(token);
    } else {
      await sl<FlutterSecureStorage>().write(key: cachedToken, value: '');
      throw CacheException();
    }
  }

  @override
  Future<UserModel> getUser() {
    final jsonString = sl<SharedPreferences>().getString(cachedUser);
    if (jsonString != null) {
      return Future.value(UserModel.fromJson(jsonString));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> saveToken(String token) async {
   
  


    if (token != null) {
      await sl<FlutterSecureStorage>().write(key: cachedToken, value: token);
    }
  }

  @override
  Future<void> saveUser(UserModel user) {
         
    return sl<SharedPreferences>().setString(cachedUser, user.toJson());
  }

  @override
  Future<void> clearCache() async {
    await sl<FlutterSecureStorage>().deleteAll();
    await sl<SharedPreferences>().remove(cachedUser);
  }
}
