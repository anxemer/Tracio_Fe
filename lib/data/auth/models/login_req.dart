import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class LoginReq {
  final String? idToken;
  final String email;
  final String password;
  LoginReq({
    this.idToken,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idToken': idToken,
      'email': email,
      'password': password,
    };
  }

  factory LoginReq.fromMap(Map<String, dynamic> map) {
    return LoginReq(
      idToken: map['idToken'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginReq.fromJson(String source) =>
      LoginReq.fromMap(json.decode(source) as Map<String, dynamic>);
}
