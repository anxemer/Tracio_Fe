// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RegisterReq {
  final String firebaseId;
  final String fullName;
  final String email;
  final String password;
  RegisterReq({
    required this.firebaseId,
    required this.fullName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'FirebaseUid': firebaseId,
      'UserName': fullName,
      'Email': email,
      'password': password,
    };
  }

  factory RegisterReq.fromMap(Map<String, dynamic> map) {
    return RegisterReq(
      firebaseId: map['FirebaseUid'] as String,
      fullName: map['UserName'] as String,
      email: map['Email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterReq.fromJson(String source) =>
      RegisterReq.fromMap(json.decode(source) as Map<String, dynamic>);
}
