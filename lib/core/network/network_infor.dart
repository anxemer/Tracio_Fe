import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfor {
  Future<bool> get isConnected;
}

class NetworkInforIml implements NetworkInfor {
  final InternetConnectionChecker connectionChecker;

  NetworkInforIml({required this.connectionChecker});
  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
