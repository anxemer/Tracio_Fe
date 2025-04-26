import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracio_fe/data/chat/models/request/post_message_req.dart';
import 'package:tracio_fe/domain/auth/entities/user.dart';
import 'package:tracio_fe/domain/chat/entities/attachment.dart';
import 'package:tracio_fe/domain/chat/entities/conversation.dart';
import 'package:tracio_fe/domain/chat/entities/message.dart';
import 'package:tracio_fe/domain/chat/entities/shared_content.dart';
import 'package:tracio_fe/domain/chat/usecases/get_conversations_usecase.dart';
import 'package:tracio_fe/domain/chat/usecases/get_messages_usecase.dart';
import 'package:tracio_fe/domain/chat/usecases/post_message_usecase.dart';
import 'package:tracio_fe/service_locator.dart';
import 'package:path/path.dart' as p;

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ConversationBloc() : super(ConversationInitial()) {
    on<GetConversations>(_onGetConversations);
    on<GetMessages>(_onGetMessages);
    on<SendMessage>(_onSendMessage);
    on<RefreshMessages>(_onRefreshMessages);
    on<CreateConversation>(_onCreateConversation);
    on<GetConversationByGroup>(_onGetConversationByGroup);
    on<ReceiveUpdatedConversation>(_onReceiveConversation);
    on<ReceiveNewMessage>(_onReceiveMessage);
  }

  Future<void> _onGetConversations(
    GetConversations event,
    Emitter<ConversationState> emit,
  ) async {
    emit(ConversationLoading());

    var response = await sl<GetConversationsUsecase>().call({
      "pageSize": event.pageSize.toString(),
      "pageNumber": event.pageNumber.toString()
    });
    response.fold(
      (failure) => emit(ConversationFailure(errorMessage: failure.message)),
      (result) {
        final List<ConversationEntity> conversations = result;

        emit(ConversationLoaded(
          pagination: ConversationPaginationEntity(
              conversations: [],
              totalCount: 0,
              pageNumber: 0,
              pageSize: 0,
              totalPage: 0,
              hasPreviousPage: false,
              hasNextPage: false),
          conversations: conversations,
          pageNumber: event.pageNumber,
          pageSize: event.pageSize,
        ));
      },
    );
  }

  Future<void> _onGetMessages(
    GetMessages event,
    Emitter<ConversationState> emit,
  ) async {
    ConversationLoaded? currentState;
    if (state is ConversationLoaded) {
      currentState = state as ConversationLoaded;
    }
    emit(ChatLoading());

    var request = GetMessagesUsecaseParams(
        conversationId: event.conversationId,
        messageId: event.messageId,
        pageNumber: event.pageNumber,
        pageSize: event.pageSize);
    var response = await sl<GetMessagesUsecase>().call(request);
    response.fold(
      (failure) => emit(ChatFailure(errorMessage: failure.message)),
      (result) {
        final MessagePaginationEntity messagePaginationEntity = result;

        emit(ChatLoaded(
          conversation: messagePaginationEntity.conversation,
          messages: messagePaginationEntity.messages,
          previousConversations: currentState?.conversations ?? [],
          pagination: messagePaginationEntity,
          pageNumber: event.pageNumber,
          pageSize: event.pageSize,
        ));
      },
    );
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ConversationState> emit,
  ) async {
    String? path = event.files?.path;
    if (path != null) {
      final validationError = validateImageFile(File(path));
      if (validationError != SendErrorType.none) {
        emit(event.currentState!.copyWith(
          postStatus: SendMessageStatus.error,
          errorType: validationError,
          refreshKey: event.currentState!.refreshKey + 1,
        ));
        return;
      }
    }
    PostMessageReq request = PostMessageReq(
        conversationId: event.conversationId,
        content: event.content,
        blogId: event.blogId,
        receiverId: event.receiverId,
        routeId: event.routeId,
        files: path != null ? File(path) : null);
    if (event.currentState != null) {
      final tempMessage = MessageEntity(
        conversationId: event.conversationId,
        content: event.content ?? "",
        isSentByMe: true,
        createdAt: DateTime.now(),
        sharedContent: event.sharedContent,
        attachments: path != null
            ? [
                AttachmentEntity(
                  fileUrl: "",
                  updatedAt: DateTime.now(),
                  file: File(path),
                )
              ]
            : [],
        statuses: [],
      );
      emit(event.currentState!.copyWith(
          messages: [...event.currentState!.messages, tempMessage],
          refreshKey: event.currentState!.refreshKey + 1,
          postStatus: SendMessageStatus.sending));
    }
    var response = await sl<PostMessageUsecase>().call(request);
    response.fold((failure) {
      emit(event.currentState!.copyWith(
          messages: event.currentState!.messages,
          refreshKey: event.currentState!.refreshKey + 2,
          postStatus: SendMessageStatus.error,
          errorType: SendErrorType.serverError));
    }, (data) async {
      final updatedMessages =
          List<MessageEntity>.from(event.currentState!.messages);

      if (updatedMessages.isNotEmpty) {
        updatedMessages.removeLast();
      }

      updatedMessages.add(data);

      emit(event.currentState!.copyWith(
          messages: updatedMessages,
          refreshKey: event.currentState!.refreshKey + 2,
          postStatus: SendMessageStatus.sent,
          errorType: SendErrorType.none));
    });
  }

  final allowedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'bmp',
    'tiff'
  ];

  SendErrorType validateImageFile(File? file) {
    if (file == null) return SendErrorType.none;

    final extension =
        p.extension(file.path).toLowerCase().replaceFirst('.', '');

    if (!allowedImageExtensions.contains(extension)) {
      return SendErrorType.unsupportedFile;
    }

    final fileSizeInMB = file.lengthSync() / (1024 * 1024);
    if (fileSizeInMB > 10) {
      return SendErrorType.fileTooLarge;
    }

    return SendErrorType.none;
  }

  String getErrorMessage(SendErrorType type) {
    switch (type) {
      case SendErrorType.fileTooLarge:
        return "File is too large. Max allowed is 10MB.";
      case SendErrorType.unsupportedFile:
        return "Unsupported file format. Only images (jpg, png...) are allowed.";
      case SendErrorType.networkFailure:
        return "Network error. Please check your connection.";
      case SendErrorType.serverError:
        return "Server error. Please try again later.";
      default:
        return "Something went wrong while sending message.";
    }
  }

  Future<void> _onRefreshMessages(
    RefreshMessages event,
    Emitter<ConversationState> emit,
  ) async {
    ConversationLoaded? currentState;
    if (state is ConversationLoaded) {
      currentState = state as ConversationLoaded;
    }
    emit(ChatLoading());

    var request = GetMessagesUsecaseParams(
        conversationId: event.conversationId,
        messageId: null,
        pageNumber: 1,
        pageSize: 20);
    var response = await sl<GetMessagesUsecase>().call(request);
    response.fold(
      (failure) => emit(ConversationFailure(errorMessage: failure.message)),
      (result) {
        final MessagePaginationEntity messagePaginationEntity = result;

        emit(ChatLoaded(
          conversation: messagePaginationEntity.conversation,
          messages: messagePaginationEntity.messages,
          previousConversations: currentState?.conversations ?? [],
          pagination: messagePaginationEntity,
          pageNumber: 1,
          pageSize: 20,
        ));
      },
    );
  }

  Future<void> _onCreateConversation(
    CreateConversation event,
    Emitter<ConversationState> emit,
  ) async {}

  Future<void> _onGetConversationByGroup(
    GetConversationByGroup event,
    Emitter<ConversationState> emit,
  ) async {
    emit(ChatLoading());
  }

  Future<void> _onReceiveConversation(
    ReceiveUpdatedConversation event,
    Emitter<ConversationState> emit,
  ) async {
    final state = this.state;
    if (state is ConversationLoaded) {
      final updatedConversations =
          List<ConversationEntity>.from(state.conversations);

      final index = updatedConversations.indexWhere(
        (c) => c.conversationId == event.conversation.conversationId,
      );

      if (index != -1) {
        updatedConversations.removeAt(index);
      }
      updatedConversations.insert(
          0, event.conversation.copyWith(isRead: false));

      emit(state.copyWith(
          conversations: updatedConversations,
          refreshKey: state.refreshKey + 1));
    }
  }

  Future<void> _onReceiveMessage(
    ReceiveNewMessage event,
    Emitter<ConversationState> emit,
  ) async {
    final state = this.state;
    if (state is ChatLoaded) {
      final updatedMessages = List<MessageEntity>.from(state.messages)
        ..add(event.message);

      emit(state.copyWith(
        messages: updatedMessages,
        refreshKey: state.refreshKey + 1,
      ));
    }
  }
}
