import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Tracio/core/services/signalR/implement/chat_hub_service.dart';
import 'package:Tracio/data/auth/sources/auth_local_source/auth_local_source.dart';
import 'package:Tracio/domain/auth/entities/user.dart';
import 'package:Tracio/domain/chat/entities/conversation.dart';
import 'package:Tracio/domain/chat/entities/message.dart';
import 'package:Tracio/presentation/chat/bloc/bloc/conversation_bloc.dart';
import 'package:Tracio/presentation/chat/widgets/chat_appbar.dart';
import 'package:Tracio/presentation/chat/widgets/chat_bubble.dart';
import 'package:Tracio/presentation/chat/widgets/chat_text_box.dart';
import 'package:Tracio/service_locator.dart';

class ChatPage extends StatefulWidget {
  final String conversationId;
  final ConversationEntity conversation;

  const ChatPage(
      {super.key, required this.conversation, required this.conversationId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _chatService = sl<ChatHubService>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  late final StreamSubscription<MessageEntity> _messageSubscription;
  UserEntity? currentUser;

  Future<void> _onRefresh() async {
    context
        .read<ConversationBloc>()
        .add(RefreshMessages(conversationId: widget.conversationId));
  }

  void _sendMessage(ChatLoaded state, XFile? file, int? routeId) {
    String message = _textController.text.trim();
    if (message.isEmpty) return;

    if (currentUser != null) {
      context.read<ConversationBloc>().add(SendMessage(
          currentState: state,
          conversationId: state.conversation.conversationId,
          currentUser: currentUser!,
          content: message,
          files: file,
          routeId: routeId));

      _textController.clear();

      _scrollToBottom();
    }
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      currentUser = await sl<AuthLocalSource>().getUser();
      await _chatService.joinConversation(widget.conversationId);
      _messageSubscription = _chatService.onMessageUpdate.listen((message) {
        context
            .read<ConversationBloc>()
            .add(ReceiveNewMessage(message: message));
      });
      setState(() {});
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _messageSubscription.cancel();
    Future.microtask(() async =>
        await _chatService.leaveConversation(widget.conversationId));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: ChatAppbar(
        conversation: widget.conversation,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ConversationBloc, ConversationState>(
                buildWhen: (previous, current) {
                  if (previous is ChatLoaded && current is ChatLoaded) {
                    return previous.refreshKey != current.refreshKey;
                  }
                  return true;
                },
                builder: (context, state) {
                  // Default fallback
                  List<Widget> children = [];

                  if (state is ChatLoading) {
                    children = [
                      const Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    ];
                  } else if (state is ChatLoaded) {
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => _scrollToBottom());
                    if (state.messages.isEmpty) {
                      children = [
                        const Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: Center(child: Text("No messages yet.")),
                        )
                      ];
                    } else {
                      for (int i = 0; i < state.messages.length; i++) {
                        final current = state.messages[i];
                        final previous = i > 0 ? state.messages[i - 1] : null;
                        final next = i < state.messages.length - 1
                            ? state.messages[i + 1]
                            : null;

                        final bool isFirst = previous == null ||
                            previous.senderId != current.senderId;
                        final bool isLast =
                            next == null || next.senderId != current.senderId;
                        final bool isMiddle = !isFirst && !isLast;
                        final bool isLastMessage =
                            i == state.messages.length - 1;

                        children.add(ChatBubble(
                          message: current,
                          isSentByMe: current.isSentByMe,
                          isFirst: isFirst,
                          isMiddle: isMiddle,
                          isLast: isLast,
                          isLastMessage: isLastMessage,
                        ));
                      }
                    }
                  } else if (state is ChatFailure) {
                    children = [
                      Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Center(
                          child: Text("Error: ${state.errorMessage}"),
                        ),
                      )
                    ];
                  }

                  return ListView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    children: children,
                  );
                },
              ),
            ),
            ChatTextBox(
              textEditingController: _textController,
              onSent: _sendMessage,
            )
          ],
        ),
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
