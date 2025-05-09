import 'dart:convert';

class NotificationModel {
  final String notificationId;
  final String senderName;
  final String? senderAvatar;
  final int entityId;
  final int entityType;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final String? messageId;

  NotificationModel({
    required this.notificationId,
    required this.senderName,
    this.senderAvatar,
    required this.entityId,
    required this.entityType,
    required this.message,
    required this.isRead,
    required this.createdAt,
    this.messageId,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      notificationId: map['notificationId']?.toString() ?? '',
      senderName: map['senderName']?.toString() ?? 'System',
      senderAvatar: map['senderAvatar']?.toString(),
      entityId: int.tryParse(map['entityId'].toString()) ?? 0,
      entityType: int.tryParse(map['entityType'].toString()) ?? 0,
      message: map['message']?.toString() ?? '',
      isRead: map['isRead'] == true,
      createdAt:
          DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now(),
      messageId: map['messageId']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notificationId': notificationId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'entityId': entityId,
      'entityType': entityType,
      'message': message,
      'isRead': isRead,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'messageId': messageId,
    };
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
