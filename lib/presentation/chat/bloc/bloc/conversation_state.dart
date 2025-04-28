part of 'conversation_bloc.dart';

sealed class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object?> get props => [];
}

final class ConversationInitial extends ConversationState {}

final class ConversationLoading extends ConversationState {
  @override
  List<Object> get props => [];
}

final class ConversationLoaded extends ConversationState {
  final List<ConversationEntity> conversations;
  final ConversationPaginationEntity pagination;
  final int pageSize;
  final int pageNumber;
  final int refreshKey;

  const ConversationLoaded(
      {required this.conversations,
      required this.pagination,
      this.pageSize = 10,
      this.pageNumber = 1,
      this.refreshKey = 0});

  ConversationLoaded copyWith({
    List<ConversationEntity>? conversations,
    int? pageSize,
    int? pageNumber,
    int? refreshKey,
  }) {
    return ConversationLoaded(
        pagination: pagination,
        conversations: conversations ?? this.conversations,
        pageSize: pageSize ?? this.pageSize,
        pageNumber: pageNumber ?? this.pageNumber,
        refreshKey: refreshKey ?? this.refreshKey);
  }

  @override
  List<Object?> get props => [
        conversations,
        pagination,
        pageSize,
        pageNumber,
        refreshKey,
      ];
}

final class ConversationFailure extends ConversationState {
  final String errorMessage;

  const ConversationFailure({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}

final class ChatLoading extends ConversationState {}

enum SendMessageStatus { init, sending, sent, error }

enum SendErrorType {
  none,
  networkFailure,
  serverError,
  fileTooLarge,
  unsupportedFile,
  unknown,
}

final class ChatLoaded extends ConversationState {
  final List<ConversationEntity> previousConversations;
  final ConversationEntity conversation;
  final MessagePaginationEntity pagination;
  final List<MessageEntity> messages;
  final int pageSize;
  final int pageNumber;
  final int refreshKey;
  final SendMessageStatus postStatus;
  final SendErrorType errorType;

  const ChatLoaded({
    required this.previousConversations,
    required this.conversation,
    required this.messages,
    required this.pagination,
    this.pageSize = 20,
    this.pageNumber = 1,
    this.refreshKey = 0,
    this.postStatus = SendMessageStatus.init,
    this.errorType = SendErrorType.none,
  });

  ChatLoaded copyWith({
    List<ConversationEntity>? previousConversations,
    ConversationEntity? conversation,
    List<MessageEntity>? messages,
    int? pageSize,
    int? pageNumber,
    int? refreshKey,
    SendMessageStatus? postStatus,
    SendErrorType? errorType,
  }) {
    return ChatLoaded(
      previousConversations:
          previousConversations ?? this.previousConversations,
      conversation: conversation ?? this.conversation,
      pagination: pagination,
      messages: messages ?? this.messages,
      pageSize: pageSize ?? this.pageSize,
      pageNumber: pageNumber ?? this.pageNumber,
      refreshKey: refreshKey ?? this.refreshKey,
      postStatus: postStatus ?? this.postStatus,
      errorType: errorType ?? this.errorType,
    );
  }

  @override
  List<Object?> get props => [
        previousConversations,
        conversation,
        messages,
        pageSize,
        pageNumber,
        refreshKey,
      ];
}

final class ChatFailure extends ConversationState {
  final String errorMessage;

  const ChatFailure({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}
