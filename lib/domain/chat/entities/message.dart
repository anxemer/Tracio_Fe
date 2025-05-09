import 'package:Tracio/core/constants/message_enum.dart';
import 'package:Tracio/domain/chat/entities/attachment.dart';
import 'package:Tracio/domain/chat/entities/conversation.dart';
import 'package:Tracio/domain/chat/entities/shared_content.dart';

class MessageStatusEntity {
  final int userId;
  final String userName;
  final String avatar;
  final MessageStatusEnum status;
  MessageStatusEntity({
    required this.userId,
    required this.status,
    required this.userName,
    required this.avatar,
  });
}

class MessageEntity {
  final String? messageId;
  final String conversationId;
  final int? senderId;
  final String? senderName;
  final String? senderAvatar;
  final String? content;
  final bool? isDeleted;
  final bool isSentByMe;
  final DateTime createdAt;
  final SharedContentEntity? sharedContent;
  final List<AttachmentEntity> attachments;
  final List<MessageStatusEntity> statuses;
  MessageEntity({
    this.messageId,
    required this.conversationId,
    this.senderId,
    this.senderName,
    this.senderAvatar,
    this.content,
    this.isDeleted,
    required this.isSentByMe,
    required this.createdAt,
    required this.sharedContent,
    required this.attachments,
    required this.statuses,
  });
}

class MessagePaginationEntity {
  final ConversationEntity conversation;
  final List<MessageEntity> messages;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPage;
  final bool hasPreviousPage;
  final bool hasNextPage;
  MessagePaginationEntity({
    required this.conversation,
    required this.messages,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPage,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });
}
