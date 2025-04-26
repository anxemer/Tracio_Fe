class ConversationEntity {
  final String conversationId;
  final bool isGroup;
  final String? userName;
  final String? userAvatar;
  final String? groupName;
  final String? groupPicture;
  final String? latestMessage;
  final DateTime lastUpdated;
  final bool isRead;

  ConversationEntity({
    required this.conversationId,
    required this.isGroup,
    required this.userName,
    required this.userAvatar,
    required this.groupName,
    required this.groupPicture,
    required this.latestMessage,
    required this.lastUpdated,
    this.isRead = true,
  });

  String get formattedLastUpdated {
    int hour = lastUpdated.hour;
    int minute = lastUpdated.minute;
    String amPm = (hour >= 12) ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    String formattedTime = '$hour:${minute < 10 ? '0$minute' : minute} $amPm';

    String formattedDate =
        '${lastUpdated.year}-${lastUpdated.month.toString().padLeft(2, '0')}-${lastUpdated.day.toString().padLeft(2, '0')}';

    return '$formattedDate $formattedTime';
  }

  ConversationEntity copyWith({
    String? latestMessage,
    DateTime? lastUpdated,
    bool? isRead,
  }) =>
      ConversationEntity(
        conversationId: conversationId,
        isGroup: isGroup,
        userName: userName,
        userAvatar: userAvatar,
        groupName: groupName,
        groupPicture: groupPicture,
        latestMessage: latestMessage ?? this.latestMessage,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        isRead: isRead ?? this.isRead,
      );
}

class ConversationPaginationEntity {
  final List<ConversationEntity> conversations;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPage;
  final bool hasPreviousPage;
  final bool hasNextPage;
  ConversationPaginationEntity({
    required this.conversations,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPage,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });
}
