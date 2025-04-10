import 'dart:async';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:signalr_netcore/json_hub_protocol.dart';
import 'package:tracio_fe/core/logger/signalr_logger.dart';

class SignalRCoreService {
  late HubConnection _hub;
  bool _isConnected = false;

  Future<void> init(String hubUrl) async {
    _hub = HubConnectionBuilder()
        .withUrl(hubUrl, options: HttpConnectionOptions(requestTimeout: 30000))
        .withHubProtocol(JsonHubProtocol())
        .withAutomaticReconnect()
        .build();

    _hub.onclose(({error}) {
      signalrLogger.w('🔌 Disconnected: $error');
    });

    await _hub.start();
    _isConnected = true;
    signalrLogger.i('✅ Connected to $hubUrl');
  }

  void on(String event, Function(List<Object?>?) handler) {
    _hub.on(event, handler);
  }

  Future<void> invoke(String method, {List<Object>? args}) async {
    if (!_isConnected) {
      final msg =
          '[SignalR] ❌ Cannot invoke "$method" because connection is not established';
      signalrLogger.e(msg);
      throw Exception(msg);
    }

    signalrLogger
        .i('[SignalR] 🔸 Invoking "$method" with arguments: ${args ?? []}');

    try {
      await _hub.invoke(method, args: args);
      signalrLogger.i('[SignalR] ✅ Successfully invoked "$method"');
    } catch (e, stack) {
      signalrLogger.e('[SignalR] ❌ Error invoking "$method": $e',
          stackTrace: stack);
      rethrow;
    }
  }

  Future<void> dispose() async {
    await _hub.stop();
  }
}
