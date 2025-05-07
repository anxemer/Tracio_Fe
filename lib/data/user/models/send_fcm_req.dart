// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SendFcmReq {
  final String deviceId;
  final String fcmToken;

  SendFcmReq({required this.deviceId, required this.fcmToken});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'deviceId': deviceId,
      'fcmToken': fcmToken,
    };
  }

  factory SendFcmReq.fromMap(Map<String, dynamic> map) {
    return SendFcmReq(
      deviceId: map['deviceId'] as String,
      fcmToken: map['fcmToken'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SendFcmReq.fromJson(String source) => SendFcmReq.fromMap(json.decode(source) as Map<String, dynamic>);
}
