import 'package:tracio_fe/domain/user/entities/user_profile_entity.dart';

class UserprofileModel extends UserProfileEntity {
  UserprofileModel({
    super.userId,
    super.userName,
    super.email,
    super.firebaseId,
    super.phoneNumber,
    super.profilePicture,
    super.bio,
    super.roleName,
    super.weight,
    super.height,
    super.gender,
    super.city,
    super.district,
  });
Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'userName': userName,
      'email': email,
      'firebaseId': firebaseId,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'bio': bio,
      'roleName': roleName,
      'weight': weight,
      'height': height,
      'gender': gender,
      'city': city,
      'district': district,
    };
  }

  factory UserprofileModel.fromMap(Map<String, dynamic> map) {
    return UserprofileModel(
      userId: map['userId'] != null ? map['userId'] as int : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      firebaseId: map['firebaseId'] != null ? map['firebaseId'] as String : null,
      phoneNumber: map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      profilePicture: map['profilePicture'] != null ? map['profilePicture'] as String : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
      roleName: map['roleName'] != null ? map['roleName'] as String : null,
      weight: map['weight'] != null ? map['weight'] as double : null,
      height: map['height'] != null ? map['height'] as int : null,
      gender: map['gender'] != null ? map['gender'] as int : null,
      city: map['city'] != null ? map['city'] as String : null,
      district: map['district'] != null ? map['district'] as String : null,
    );
  }

 
}
