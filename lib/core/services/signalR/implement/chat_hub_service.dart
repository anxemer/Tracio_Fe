import 'dart:async';

import 'package:Tracio/core/constants/api_url.dart';
import 'package:Tracio/core/logger/signalr_logger.dart';
import 'package:Tracio/core/services/signalR/signalr_core_service.dart';
import 'package:Tracio/data/auth/sources/auth_local_source/auth_local_source.dart';
import 'package:Tracio/data/chat/models/conversation.dart';
import 'package:Tracio/data/chat/models/message.dart';
import 'package:Tracio/domain/chat/entities/conversation.dart';
import 'package:Tracio/domain/chat/entities/message.dart';
import 'package:Tracio/service_locator.dart';

class ChatHubService {
  final SignalRCoreService _core;
  final _messageUpdateStream = StreamController<MessageEntity>.broadcast();
  final _conversationUpdateStream =
      StreamController<ConversationEntity>.broadcast();
  final List<String> _joinedConversationIds = [];

  Stream<MessageEntity> get onMessageUpdate => _messageUpdateStream.stream;
  Stream<ConversationEntity> get onConversationUpdate =>
      _conversationUpdateStream.stream;

  ChatHubService(this._core);

  Future<void> connect() async {
    String accessToken = await sl<AuthLocalSource>().getToken();
    signalrLogger
        .i('[ChatHubService] 🔌 Connecting to ${ApiUrl.chatHubUrl}...');
    await _core.init("${ApiUrl.chatHubUrl}?token=$accessToken");
    signalrLogger.i('[ChatHubService] ✅ Connected');

    _core.on('UpdateConversation', _handleUpdateConversation);
    _core.on('ReceiveMessage', _handleReceiveMessageUpdate);
    _core.onReconnectSuccess(_handleReconnect);

    signalrLogger.d('[ChatHubService] 📡 Handlers registered');
  }

  Future<void> joinConversation(String conversationId) async {
    signalrLogger
        .i('[ChatHubService] 📤 Joining conversation: $conversationId');
    try {
      String accessToken = await sl<AuthLocalSource>().getToken();
      await _core.invoke('JoinConversation',
          args: [conversationId],
          hubUrl: "${ApiUrl.chatHubUrl}?token=$accessToken");

      if (!_joinedConversationIds.contains(conversationId)) {
        _joinedConversationIds.add(conversationId);
      }

      signalrLogger.d('✅ Successfully joined conversation: $conversationId');
    } catch (e) {
      signalrLogger.e('❌ Failed to join conversation $conversationId: $e');
    }
  }

  Future<void> leaveConversation(String conversationId) async {
    signalrLogger
        .i('[ChatHubService] 📤 Sending LeaveConversation($conversationId)');
    try {
      String accessToken = await sl<AuthLocalSource>().getToken();
      if (_core.isConnected) {
        await _core.invoke('LeaveConversation',
            args: [conversationId],
            hubUrl: "${ApiUrl.chatHubUrl}?token=$accessToken");
        signalrLogger
            .d('[ChatHubService] ✅ Left conversation: $conversationId');
      } else {
        signalrLogger.w(
            '[ChatHubService] ⚠️ Connection closed. Skipped leaving conversation: $conversationId');
      }
      _joinedConversationIds.remove(conversationId);
    } catch (e) {
      signalrLogger.e(
          '[ChatHubService] ❌ Failed to leave conversation $conversationId: $e');
    }
  }

  void _handleReceiveMessageUpdate(List<Object?>? data) {
    if (data == null || data.isEmpty) return;
    signalrLogger.i('[ChatHubService] 📥 Raw data for message update: $data');

    try {
      final model =
          MessageModel.fromMap(Map<String, dynamic>.from(data[0] as Map));
      _messageUpdateStream.add(model);
    } catch (e) {
      signalrLogger.e('[ChatHubService] ❌ Failed to parse message update: $e');
    }
  }

  void _handleUpdateConversation(List<Object?>? data) {
    if (data == null || data.isEmpty) return;
    signalrLogger
        .i('[ChatHubService] 📥 Raw data for conversation update: $data');
    try {
      final model =
          ConversationModel.fromMap(Map<String, dynamic>.from(data[0] as Map));
      _conversationUpdateStream.add(model);
    } catch (e) {
      signalrLogger
          .e('[ChatHubService] ❌ Failed to parse conversation update: $e');
    }
  }

  void _handleReconnect({String? connectionId}) async {
    signalrLogger.i('🔄 Rejoining conversations after reconnect...');

    String accessToken = await sl<AuthLocalSource>().getToken();
    for (final id in _joinedConversationIds) {
      _core
          .invoke('JoinConversation',
              args: [id], hubUrl: "${ApiUrl.chatHubUrl}?token=$accessToken")
          .then((_) => signalrLogger.d('✅ Rejoined conversation: $id'))
          .catchError((e) =>
              signalrLogger.e('❌ Failed to rejoin conversation $id: $e'));
    }
  }

  Future<void> dispose() async {
    await _messageUpdateStream.close();
    await _conversationUpdateStream.close();
    await _core.dispose();
    signalrLogger.d('[ChatHubService] ✅ StreamControllers disposed');
  }
}
