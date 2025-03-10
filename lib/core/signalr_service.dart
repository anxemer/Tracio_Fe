import 'dart:async';

import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:tracio_fe/core/constants/api_url.dart';

class SignalRService {
  late HubConnection _hubConnection;
  bool _isConnected = false;

  final _joinedBlogUpdateController = StreamController<String>.broadcast();
  Stream<String> get joinedBlogUpdate => _joinedBlogUpdateController.stream;

  Future<void> connect() async {
    if (_isConnected) return;
    _hubConnection = HubConnectionBuilder()
        .withUrl(ApiUrl.hubUrl)
        .withAutomaticReconnect()
        .build();

    _registerEventHandlers();
  }

  void _registerEventHandlers() {
    _hubConnection.on('JoinedBlogUpdate', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        String blogId = arguments[0].toString();
        print('✅ Joined BlogUpdates with ID: $blogId');
        _joinedBlogUpdateController.add(blogId);
      }
    });
  }

  Future<void> joinBlogUpdates() async {
    if (!_isConnected) await connect();

    try {
      await _hubConnection.invoke('JoinBlogUpdates');
      print('🔵 Requested to join BlogUpdates');
    } catch (e) {
      print('❌ Error joining BlogUpdates: $e');
      rethrow;
    }
  }

  void dispose() {
    _joinedBlogUpdateController.close();
  }
}
