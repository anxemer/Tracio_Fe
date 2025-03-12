import 'package:tracio_fe/domain/user/entities/user_profile_entity.dart';

class UserprofileModel extends UserProfileEntity {
  UserprofileModel({
    required super.userId,
    required super.userName,
    required super.email,
    required super.firebaseId,
    required super.phoneNumber,
    required super.profilePicture,
    required super.bio,
    required super.roleName,
    required super.weight,
    required super.height,
    required super.gender,
    required super.city,
    required super.district,
  });

  factory UserprofileModel.fromJson(Map<String, dynamic> json) {
    return UserprofileModel(
      userId: json["userId"],
      userName: json["userName"],
      email: json["email"],
      firebaseId: json["firebaseId"],
      phoneNumber: json["phoneNumber"],
      profilePicture: json["profilePicture"],
      bio: json["bio"],
      roleName: json["roleName"],
      weight: json["weight"],
      height: json["height"],
      gender: json["gender"],
      city: json["city"],
      district: json["district"],
    );
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "userName": userName,
        "email": email,
        "firebaseId": firebaseId,
        "phoneNumber": phoneNumber,
        "profilePicture": profilePicture,
        "bio": bio,
        "roleName": roleName,
        "weight": weight,
        "height": height,
        "gender": gender,
        "city": city,
        "district": district,
      };
}
