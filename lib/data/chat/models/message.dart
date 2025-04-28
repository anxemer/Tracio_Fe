import 'package:tracio_fe/data/chat/models/conversation.dart';
import 'package:tracio_fe/domain/chat/entities/attachment.dart';
import 'package:tracio_fe/domain/chat/entities/message.dart';
import 'package:tracio_fe/domain/chat/entities/shared_content.dart';
import 'package:tracio_fe/core/constants/message_enum.dart';

class MessageModel extends MessageEntity {
  MessageModel(
      {required super.messageId,
      required super.conversationId,
      required super.senderId,
      required super.senderName,
      required super.senderAvatar,
      required super.content,
      required super.isDeleted,
      required super.isSentByMe,
      required super.createdAt,
      required super.attachments,
      required super.statuses,
      required super.sharedContent});
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId: map['messageId'] as String,
      conversationId: map['conversationId'] as String,
      senderId: map['senderId'] as int,
      senderName: map['senderName'] as String,
      senderAvatar: map['senderAvatar'] as String,
      content: map['content'] ?? "",
      isDeleted: map['isDeleted'] as bool,
      isSentByMe: map['isSentByMe'] as bool,
      createdAt: DateTime.parse(map['createdAt']),
      sharedContent: map['sharedContent'] != null
          ? SharedContentModel.fromMap(
              map['sharedContent'] as Map<String, dynamic>)
          : null,
      attachments: List<AttachmentEntity>.from(
        (map['attachments']).map<AttachmentEntity>(
          (x) => AttachmentModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      statuses: List<MessageStatusModel>.from(
        (map['statuses']).map<MessageStatusModel>(
          (x) => MessageStatusModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}

class MessagePaginationModel extends MessagePaginationEntity {
  MessagePaginationModel(
      {required super.conversation,
      required super.messages,
      required super.totalCount,
      required super.pageNumber,
      required super.pageSize,
      required super.totalPage,
      required super.hasPreviousPage,
      required super.hasNextPage});

  factory MessagePaginationModel.fromMap(Map<String, dynamic> map) {
    return MessagePaginationModel(
      conversation: ConversationModel.fromMap(map['conversation']),
      messages: List<MessageEntity>.from(
        (map['messages']).map<MessageEntity>(
          (x) => MessageModel.fromMap(x as Map<String, dynamic>),
        ),
      ).reversed.toList(),
      totalCount: map['totalMessage'] as int,
      pageNumber: map['pageNumber'] as int,
      pageSize: map['pageSize'] as int,
      totalPage: map['totalPage'] as int,
      hasPreviousPage: map['hasPreviousPage'] as bool,
      hasNextPage: map['hasNextPage'] as bool,
    );
  }
}

class AttachmentModel extends AttachmentEntity {
  AttachmentModel({required super.fileUrl, required super.updatedAt});
  factory AttachmentModel.fromMap(Map<String, dynamic> map) {
    return AttachmentModel(
      fileUrl: map['fileUrl'] as String,
      updatedAt: DateTime.parse(map['uploadedAt']),
    );
  }
}

class SharedContentModel extends SharedContentEntity {
  SharedContentModel({
    required super.type,
    required super.entityId,
    required super.creatorId,
    required super.creatorName,
    required super.creatorAvatar,
    required super.summary,
    required super.thumbnail,
  });

  factory SharedContentModel.fromMap(Map<String, dynamic> map) {
    return SharedContentModel(
      type: map['type'] as String,
      entityId: map['entityId'] as int,
      creatorId: map['creatorId'],
      creatorName: map['creatorName'],
      creatorAvatar: map['creatorAvatar'],
      summary: map['summary'] as String,
      thumbnail: map['thumbnail'] as String,
    );
  }
}

class MessageStatusModel extends MessageStatusEntity {
  MessageStatusModel(
      {required super.userId,
      required super.status,
      required super.userName,
      required super.avatar});

  factory MessageStatusModel.fromMap(Map<String, dynamic> map) {
    return MessageStatusModel(
      userId: map['userId'] as int,
      userName: map['userName'],
      avatar: map['avatar'],
      status: MessageStatusEnumExtension.fromMap(map),
    );
  }
}
