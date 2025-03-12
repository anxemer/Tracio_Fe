import 'package:tracio_fe/domain/user/entities/user_profile_entity.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserProfileEntity userProfileEntity;

  UserProfileLoaded({required this.userProfileEntity});
}

class UserProileFailure extends UserProfileState {}
