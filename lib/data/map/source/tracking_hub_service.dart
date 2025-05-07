import 'package:flutter/foundation.dart';
import 'package:signalr_netcore/json_hub_protocol.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:Tracio/core/constants/api_url.dart';

abstract class ITrackingHubService {
  Future<bool> connect();
  Future<bool> disconnect();
  Future<bool> sendMessage(String method, List<dynamic> args);
  void onMessage(String method, Function(List<dynamic>?) callback);
}

class TrackingHubService extends ITrackingHubService {
  final hubConnection = HubConnectionBuilder()
      .withUrl(ApiUrl.locationHubUrl,
          options:
              HttpConnectionOptions(transport: HttpTransportType.WebSockets))
              .withHubProtocol(JsonHubProtocol())
      .withAutomaticReconnect(
          retryDelays: [2000, 5000, 10000, 20000, 30000]).build();

  @override
  Future<bool> connect() async {
    return _connectServer();
  }

  @override
  Future<bool> disconnect() async {
    try {
      await hubConnection.stop();
      if (kDebugMode) {
        print("Hub connection stopped.");
      }
      return true;
    } catch (ex) {
      if (kDebugMode) {
        print("Disconnection error =>>>>> $ex");
      }
      return false;
    }
  }

  @override
  void onMessage(String method, Function(List<dynamic>? args) callback) {
    hubConnection.on(method, callback);
  }

  @override
  Future<bool> sendMessage(String method, List<dynamic> args) async {
    try {
      if (hubConnection.state == HubConnectionState.Connected) {
        await hubConnection.invoke(method, args: args.cast<Object>());
        if (kDebugMode) {
          print("Message sent successfully: $method with args: $args");
        }
        return true;
      } else {
        if (kDebugMode) {
          print("Cannot send message, SignalR is not connected.");
        }
        return false;
      }
    } catch (ex) {
      if (kDebugMode) {
        print("Error sending message =>>>>> $ex");
      }
      return false;
    }
  }

  Future<bool> _connectServer() async {
    try {
      await hubConnection.start();
      if (kDebugMode) {
        print("hubConnection started...");
      }
      return true;
    } catch (ex) {
      if (kDebugMode) {
        print("Connection error =>>>>> $ex");
      }
      return false;
    }
  }
}
