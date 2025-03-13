import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfor {
  Future<bool> get isConnected;
}

class NetworkInforIml implements NetworkInfor {
  final Connectivity connectionChecker;

  NetworkInforIml(this.connectionChecker);
  @override
  Future<bool> get isConnected async {
    final connectionResult = await connectionChecker.checkConnectivity();
    return connectionResult != ConnectivityResult.none;
  }
}
