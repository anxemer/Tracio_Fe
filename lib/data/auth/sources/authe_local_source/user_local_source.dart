import 'package:tracio_fe/data/auth/models/user_model.dart';
import 'package:tracio_fe/domain/auth/entities/user.dart';

abstract class AuthLocalSource {
  Future<String> getToke();
  Future<UserEntity> getUser();
  Future<void> saveToken(String token);
  Future<void> saveUser(UserModel user);
}
