import 'package:Tracio/domain/chat/entities/conversation.dart';

class ConversationModel extends ConversationEntity {
  ConversationModel(
      {required super.conversationId,
      required super.isGroup,
      required super.lastUpdated,
      required super.userName,
      required super.userAvatar,
      required super.groupName,
      required super.groupPicture,
      required super.latestMessage,
      required super.isRead});

  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    return ConversationModel(
        conversationId: map['conversationId'] as String,
        isGroup: map['isGroup'] as bool,
        userName: map['userName'] != null ? map['userName'] as String : null,
        userAvatar:
            map['userAvatar'] != null ? map['userAvatar'] as String : null,
        groupName: map['groupName'] != null ? map['groupName'] as String : null,
        groupPicture:
            map['groupPicture'] != null ? map['groupPicture'] as String : null,
        latestMessage: map['latestMessage'] != null
            ? map['latestMessage'] as String
            : null,
        lastUpdated: DateTime.parse(map['lastUpdated']),
        isRead: map['isRead'] ?? true);
  }
}

class ConversationPaginationModel extends ConversationPaginationEntity {
  ConversationPaginationModel(
      {required super.conversations,
      required super.totalCount,
      required super.pageNumber,
      required super.pageSize,
      required super.totalPage,
      required super.hasPreviousPage,
      required super.hasNextPage});

  factory ConversationPaginationModel.fromMap(Map<String, dynamic> map) {
    return ConversationPaginationModel(
      conversations: List<ConversationEntity>.from(
        (map['conversations']).map<ConversationEntity>(
          (x) => ConversationModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalCount: map['totalCount'] as int,
      pageNumber: map['pageNumber'] as int,
      pageSize: map['pageSize'] as int,
      totalPage: map['totalPage'] as int,
      hasPreviousPage: map['hasPreviousPage'] as bool,
      hasNextPage: map['hasNextPage'] as bool,
    );
  }
}
