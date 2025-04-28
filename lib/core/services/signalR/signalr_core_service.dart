import 'dart:async';
// ignore: unnecessary_import
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:signalr_netcore/json_hub_protocol.dart';
import 'package:tracio_fe/core/logger/signalr_logger.dart';
import 'package:signalr_netcore/ihub_protocol.dart';

class SignalRCoreService {
  late HubConnection _hub;
  bool _isConnected = false;
  bool _isConnecting = false;
  bool get isConnected => _isConnected;

  Future<void> init(String hubUrl) async {
   
    _hub = HubConnectionBuilder()
        .withUrl(
          hubUrl,
          options: HttpConnectionOptions(
            requestTimeout: 30000,
          ),
        )
        .withHubProtocol(JsonHubProtocol())
        .withAutomaticReconnect()
        .build();

    _hub.onclose(({error}) {
      signalrLogger.w('🔌 Disconnected: $error');
      _isConnected = false;
    });

    await _startHub(hubUrl);
  }

  Future<void> _startHub(String hubUrl) async {
    _isConnecting = true;
    try {
      await _hub.start();
      _isConnected = true;
      signalrLogger.i('✅ Connected to $hubUrl');
    } catch (e, stack) {
      signalrLogger.e('❌ Failed to connect: $e', stackTrace: stack);
      rethrow;
    } finally {
      _isConnecting = false;
    }
  }

  Future<void> ensureConnected(String hubUrl) async {
    if (_isConnected) return;
    if (_isConnecting) {
      while (_isConnecting) {
        await Future.delayed(Duration(milliseconds: 100));
      }
      if (_isConnected) return;
    }

    signalrLogger.w('🔄 Attempting reconnect...');
    await _startHub(hubUrl);
  }

  void onReconnectSuccess(ReconnectedCallback callback) {
    _hub.onreconnected(({connectionId}) {
      signalrLogger.i('🔄 Reconnected: $connectionId');
      callback(connectionId: connectionId);
    });
  }

  void on(String event, Function(List<Object?>?) handler) {
    _hub.on(event, handler);
  }

  void off(String event) {
    _hub.off(event);
  }

  Future<void> invoke(String method,
      {List<Object>? args, String? hubUrl}) async {
    signalrLogger
        .i('[SignalR] 🔸 Invoking "$method" with arguments: ${args ?? []}');

    try {
      if (!_isConnected || _hub.state != HubConnectionState.Connected) {
        final msg =
            '[SignalR] ❌ Cannot invoke "$method" because connection is not established (state: ${_hub.state})';
        signalrLogger.e(msg);
        throw Exception(msg);
      }
      await _hub.invoke(method, args: args);
      signalrLogger.i('[SignalR] ✅ Successfully invoked "$method"');
    } catch (e, stack) {
      signalrLogger.e('[SignalR] ❌ Error invoking "$method": $e',
          stackTrace: stack);
      rethrow;
    }
  }

  Future<void> dispose() async {
    if (_isConnected) {
      signalrLogger.i('[SignalR] 🔌 Disconnecting...');
      await _hub.stop();
      _isConnected = false;
    }
  }
}
