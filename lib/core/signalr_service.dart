import 'dart:async';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/json_hub_protocol.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:tracio_fe/core/constants/api_url.dart';
import 'package:tracio_fe/data/auth/sources/auth_local_source/auth_local_source.dart';
import '../service_locator.dart';

class SignalRService {
  late HubConnection _hubConnection;
  bool _isConnected = false;

  final _blogUpdatedController = StreamController<dynamic>.broadcast();
  final _joinedGroupController = StreamController<String>.broadcast();
  final _joinedBlogUpdateController = StreamController<String>.broadcast();
  final _receiveNewCommentReactionController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _receiveNewBlogReactionController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<dynamic> get onBlogUpdated => _blogUpdatedController.stream;
  Stream<String> get onJoinedGroup => _joinedGroupController.stream;
  Stream<String> get onJoinedBlogUpdate => _joinedBlogUpdateController.stream;
  Stream<Map<String, dynamic>> get onReceiveNewCommentReaction =>
      _receiveNewCommentReactionController.stream;
  Stream<Map<String, dynamic>> get onReceiveNewBlogReaction =>
      _receiveNewBlogReactionController.stream;

  bool get isConnected => _isConnected;

  Future<void> initConnection() async {
    final token = await sl<AuthLocalSource>().getToken();
    _hubConnection = HubConnectionBuilder()
        .withUrl(ApiUrl.hubUrl,
            options: HttpConnectionOptions(
              accessTokenFactory: () => Future.value(token),
              // // requestTimeout: 30000,
              // skipNegotiation: true,
              // transport: HttpTransportType.WebSockets,
            ))
        .withAutomaticReconnect()
        .withHubProtocol(JsonHubProtocol())
        .build();

    // Đăng ký các sự kiện lắng nghe từ server
    _registerHandlers();

    try {
      await _hubConnection.start();
      _isConnected = true;
      print('SignalR connection started');
    } catch (e) {
      print('Error starting SignalR connection: $e');
      _isConnected = false;
      rethrow;
    }
  }

  void _registerHandlers() {
    _hubConnection.on('BlogUpdated', _handleBlogUpdated);
    _hubConnection.on('JoinedGroup', _handleJoinedGroup);
    _hubConnection.on('JoinedBlogUpdate', _handleJoinedBlogUpdate);
    _hubConnection.on(
        'ReceiveNewCommentReaction', _handleReceiveNewCommentReaction);
    _hubConnection.on(
        'ReceiveNewBlogReaction', _handleReceiveNewCommentReaction);

    // Đăng ký thêm các sự kiện khác nếu cần
  }

  // Đóng kết nối
  Future<void> closeConnection() async {
    if (_isConnected) {
      await _hubConnection.stop();
      _isConnected = false;
      print('SignalR connection closed');
    }
  }

  // Tham gia nhóm BlogUpdates
  Future<void> joinBlogUpdates() async {
    if (!_isConnected) await initConnection();

    try {
      await _hubConnection.invoke('JoinBlogUpdates');
      print('Joined blog updates');
    } catch (e) {
      print('Error joining blog updates: $e');
      rethrow;
    }
  }

  // Rời khỏi nhóm BlogUpdates
  Future<void> leaveBlogUpdates() async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('LeaveBlogUpdates');
      print('Left blog updates');
    } catch (e) {
      print('Error leaving blog updates: $e');
      rethrow;
    }
  }

  // Tham gia một blog cụ thể
  Future<void> joinBlog(String blogId) async {
    if (!_isConnected) await initConnection();

    try {
      await _hubConnection.invoke('JoinBlog', args: [blogId]);
      print('Joined blog: $blogId');
    } catch (e) {
      print('Error joining blog: $e');
      rethrow;
    }
  }

  // Rời khỏi một blog cụ thể
  Future<void> leaveBlog(String blogId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('LeaveBlog', args: [blogId]);
      print('Left blog: $blogId');
    } catch (e) {
      print('Error leaving blog: $e');
      rethrow;
    }
  }

  // Các hàm xử lý sự kiện từ server
  void _handleBlogUpdated(List<Object?>? parameters) {
    if (parameters != null && parameters.isNotEmpty) {
      _blogUpdatedController.add(parameters[0]);
    }
  }

  void _handleJoinedGroup(List<Object?>? parameters) {
    if (parameters != null && parameters.isNotEmpty) {
      _joinedGroupController.add(parameters[0].toString());
    }
  }

  void _handleJoinedBlogUpdate(List<Object?>? parameters) {
    if (parameters != null && parameters.isNotEmpty) {
      _joinedBlogUpdateController.add(parameters[0].toString());
    }
  }

  void _handleReceiveNewCommentReaction(List<Object?>? parameters) {
    if (parameters != null && parameters.isNotEmpty) {
      final data = parameters[0];
      if (data is Map<String, dynamic>) {
        _receiveNewCommentReactionController.add(data);
      } else {
        try {
          final Map<String, dynamic> parsedData =
              Map<String, dynamic>.from(data as Map);
          _receiveNewCommentReactionController.add(parsedData);
        } catch (e) {
          print('Error parsing ReceiveNewCommentReaction data: $e');
        }
      }
    }
  }

  void _handleReceiveNewBlogReaction(List<Object?>? parameters) {
    if (parameters != null && parameters.isNotEmpty) {
      final data = parameters[0];
      if (data is Map<String, dynamic>) {
        _receiveNewBlogReactionController.add(data);
      } else {
        try {
          final Map<String, dynamic> parsedData =
              Map<String, dynamic>.from(data as Map);
          _receiveNewBlogReactionController.add(parsedData);
        } catch (e) {
          print('Error parsing ReceiveNewCommentReaction data: $e');
        }
      }
    }
  }

  // Giải phóng tài nguyên
  void dispose() {
    _blogUpdatedController.close();
    _joinedGroupController.close();
    _joinedBlogUpdateController.close();
    _receiveNewCommentReactionController.close();
    _receiveNewBlogReactionController.close();
    closeConnection();
  }
}
