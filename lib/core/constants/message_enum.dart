enum MessageStatusEnum { sending, sent, seen }

extension MessageStatusEnumExtension on MessageStatusEnum {
  String get name => toString().split('.').last;

  static MessageStatusEnum fromMap(Map<String, dynamic> map) {
    switch (map['status'].toString().toLowerCase()) {
      case 'sent':
        return MessageStatusEnum.sent;
      case 'seen':
        return MessageStatusEnum.seen;
      default:
        throw ArgumentError('Unknown status: ${map['status']}');
    }
  }
}
