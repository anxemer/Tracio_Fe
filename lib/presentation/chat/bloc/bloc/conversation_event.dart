part of 'conversation_bloc.dart';

sealed class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object?> get props => [];
}

final class GetConversations extends ConversationEvent {
  final int pageNumber;
  final int pageSize;
  const GetConversations({
    this.pageNumber = 1,
    this.pageSize = 10,
  });

  @override
  List<Object> get props => [pageNumber, pageSize];
}

final class GetMessages extends ConversationEvent {
  final String conversationId;
  final String? messageId;
  final int pageNumber;
  final int pageSize;

  const GetMessages({
    this.messageId,
    required this.conversationId,
    this.pageNumber = 1,
    this.pageSize = 20,
  });

  @override
  List<Object> get props => [conversationId, pageNumber, pageSize];
}

final class SendMessage extends ConversationEvent {
  final ChatLoaded? currentState;
  final String conversationId;
  final UserEntity currentUser;
  final String? content;
  final int? blogId;
  final int? routeId;
  final int? receiverId;
  final XFile? files;
  final SharedContentEntity? sharedContent;

  const SendMessage({
    required this.currentState,
    required this.conversationId,
    required this.currentUser,
    this.content,
    this.blogId,
    this.files,
    this.receiverId,
    this.routeId,
    this.sharedContent,
  });

  @override
  List<Object?> get props => [
        conversationId,
        content,
        blogId,
        routeId,
        receiverId,
        files?.path,
      ];
}

final class RefreshMessages extends ConversationEvent {
  final String conversationId;

  const RefreshMessages({required this.conversationId});

  @override
  List<Object> get props => [conversationId];
}

final class CreateConversation extends ConversationEvent {
  final int userId;

  const CreateConversation({
    required this.userId,
  });

  @override
  List<Object> get props => [userId];
}

final class GetConversationByGroup extends ConversationEvent {
  final int groupId;

  const GetConversationByGroup({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

final class ReceiveUpdatedConversation extends ConversationEvent {
  final ConversationEntity conversation;

  const ReceiveUpdatedConversation({required this.conversation});

  @override
  List<Object> get props => [conversation];
}

final class ReceiveNewMessage extends ConversationEvent {
  final MessageEntity message;

  const ReceiveNewMessage({required this.message});

  @override
  List<Object> get props => [message];
}
