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
  double _keyboardHeight = 0;
  bool _isLoadingMore = false;
  bool _isFirstLoad = true;

  Future<void> _onRefresh() async {
    context
        .read<ConversationBloc>()
        .add(RefreshMessages(conversationId: widget.conversationId));
  }

  void _handleScroll() {
    if (_scrollController.position.pixels <=
        _scrollController.position.minScrollExtent + 50) {
      _loadMoreMessages();
    }
  }

  void _loadMoreMessages() {
    if (_isLoadingMore) return;

    final state = context.read<ConversationBloc>().state;
    if (state is ChatLoaded && state.pagination.hasNextPage) {
      _isLoadingMore = true;
      context.read<ConversationBloc>().add(
            GetMessages(
              conversationId: widget.conversationId,
              pageNumber: state.pageNumber + 1,
              pageSize: state.pageSize,
            ),
          );
    }
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

    _scrollController.addListener(_handleScroll);

    Future.microtask(() async {
      currentUser = sl<AuthLocalSource>().getUser();
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
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _messageSubscription.cancel();
    Future.microtask(() async =>
        await _chatService.leaveConversation(widget.conversationId));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get keyboard height
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    if (_keyboardHeight != bottomInset) {
      _keyboardHeight = bottomInset;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (bottomInset > 0) {
          _scrollToBottom();
        }
      });
    }

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade100,
      appBar: ChatAppbar(
        conversation: widget.conversation,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<ConversationBloc, ConversationState>(
                listener: (context, state) {
                  if (state is ChatLoaded) {
                    _isLoadingMore = false;
                    // Only scroll to bottom on first load or new messages
                    if (_isFirstLoad) {
                      _isFirstLoad = false;
                      _scrollToBottom();
                    } else if (state.messages.isNotEmpty &&
                        state.messages.last.isSentByMe) {
                      _scrollToBottom();
                    }
                  }
                },
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
                    if (state.messages.isEmpty) {
                      children = [
                        const Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: Center(child: Text("No messages yet.")),
                        )
                      ];
                    } else {
                      // Add loading indicator at top if there are more messages
                      if (state.pagination.hasNextPage) {
                        children.add(
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

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

                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: ListView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      children: children,
                    ),
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
    ));
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
