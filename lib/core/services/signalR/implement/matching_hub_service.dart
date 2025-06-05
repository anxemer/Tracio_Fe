import 'dart:async';

import 'package:Tracio/core/constants/api_url.dart';
import 'package:Tracio/core/logger/signalr_logger.dart';
import 'package:Tracio/core/services/signalR/signalr_core_service.dart';
import 'package:Tracio/data/auth/sources/auth_local_source/auth_local_source.dart';
import 'package:Tracio/data/map/models/matched_user.dart';
import 'package:Tracio/domain/map/entities/matched_user.dart';
import 'package:Tracio/service_locator.dart';

class MatchingHubService {
  final SignalRCoreService _core;
  final _matchedUserStream = StreamController<MatchedUserEntity>.broadcast();
  final _matchingUserStream = StreamController<UserMatchingModel>.broadcast();

  final List<int> _matchedUser = [];
  final List<UserMatchingModel> _matchingUser = [];
  Stream<MatchedUserEntity> get onUpdatedMatchedUser =>
      _matchedUserStream.stream;
  Stream<UserMatchingModel> get onRequestUpdate => _matchingUserStream.stream;
  List<UserMatchingModel> get matchingUser => _matchingUser;
  List<int> get matchedUser => _matchedUser;
  MatchingHubService(this._core);

  Future<void> connect() async {
    String accessToken = await sl<AuthLocalSource>().getToken();
    signalrLogger.i(
        '[MatchingHubService] 🔌 Connecting to ${ApiUrl.groupRouteHubUrl}...');

    await _core.init("${ApiUrl.groupRouteHubUrl}?token=$accessToken");
    signalrLogger.i('[MatchingHubService] ✅ Connected');

    _core.on('NotifyMatchedUser', _onNotifyMatchedUser);
    _core.on('RequestMatch', _onNotifyRequestMatch);
    _core.on('NotifyLeaveMatch', _onNotifyLeaveMatch);
    _core.on('NotifyFinishMatch', _onNotifyFinishMatch);

    signalrLogger.d('[MatchingHubService] 📡 Handlers registered');
  }

  Future<void> approveMatch(ApproveMatchModel approveRequest) async {
    String accessToken = await sl<AuthLocalSource>().getToken();
    signalrLogger.i(
        '[MatchingHubService] 📤 Sending approve user${approveRequest.userId} - ${approveRequest.otherUserId} route ${approveRequest.routeId} - ${approveRequest.otherRouteId}');
    try {
      await _core.invoke('ApproveMatch',
          args: [
            approveRequest.userId,
            approveRequest.routeId,
            approveRequest.otherUserId,
            approveRequest.otherRouteId,
            approveRequest.status
          ],
          hubUrl: "${ApiUrl.groupRouteHubUrl}?token=$accessToken");
      if (approveRequest.status == "Rejected") {
        _matchedUser.remove(approveRequest.otherUserId);
        _matchingUser.removeWhere(
            (element) => element.userId == approveRequest.otherUserId);
      }
      signalrLogger.d(
          '[MatchingHubService] ✅ Sent ${approveRequest.status} successfully to: User${approveRequest.otherUserId} - Route${approveRequest.otherRouteId}');
    } catch (e) {
      signalrLogger.e(
          '[MatchingHubService] ❌ Failed to send ${approveRequest.status}: $e');
    }
  }

  void _onNotifyLeaveMatch(List<Object?>? data) {
    if (data == null || data.isEmpty) return;
    signalrLogger.i('[MatchingHubService] 📥 Raw data for leave match: $data');

    try {
      final raw = data[0];
      if (raw is Map<String, dynamic>) {
        final model = MatchedUserModel.fromMap(raw);
        if (_matchedUser.contains(model.userId)) {
          _matchedUser.remove(model.userId);
          final tmpModel = MatchedUserModel(
            userId: model.userId,
            userName: model.userName,
            avatar: model.avatar,
            latitude: 0,
            longitude: 0,
            status: 'leave',
          );
          if (!_matchedUserStream.isClosed) {
            _matchedUserStream.add(tmpModel);
          }
          _matchingUser.removeWhere((user) => user.userId == model.userId);
        }
      } else {
        signalrLogger.w('[MatchingHubService] ⚠️ Unexpected data format: $raw');
      }
    } catch (e) {
      signalrLogger.e('[MatchingHubService] ❌ Failed to parse leave match: $e');
    }
  }

  void _onNotifyMatchedUser(List<Object?>? data) {
    if (data == null || data.isEmpty) return;
    signalrLogger
        .i('[MatchingHubService] 📥 Raw data for message update: $data');

    try {
      final raw = data[0];
      if (raw is Map<String, dynamic>) {
        final model = MatchedUserModel.fromMap(raw);
        if (!_matchedUserStream.isClosed) {
          _matchedUserStream.add(model);
          if (!_matchedUser.contains(model.userId)) {
            _matchedUser.add(model.userId);
          }
        }
      } else {
        signalrLogger.w('[MatchingHubService] ⚠️ Unexpected data format: $raw');
      }
    } catch (e) {
      signalrLogger
          .e('[MatchingHubService] ❌ Failed to parse message update: $e');
    }
  }

  void _onNotifyRequestMatch(List<Object?>? data) {
    if (data == null || data.isEmpty) return;
    signalrLogger.i(
        '[MatchingHubService] 📥 Raw data for requesting match update: $data');

    try {
      final raw = data[0];
      if (raw is Map<String, dynamic>) {
        final model = UserMatchingModel.fromMap(raw);
        if (!_matchingUserStream.isClosed) {
          _matchingUserStream.add(model);
          if (!_matchingUser.contains(model)) {
            _matchingUser.add(model);
          }
        }
      } else {
        signalrLogger.w('[MatchingHubService] ⚠️ Unexpected data format: $raw');
      }
    } catch (e) {
      signalrLogger
          .e('[MatchingHubService] ❌ Failed to parse message update: $e');
    }
  }

  void _onNotifyFinishMatch(List<Object?>? data) {
    if (data == null || data.isEmpty) return;
    signalrLogger.i('[MatchingHubService] 📥 Raw data for finish match: $data');

    try {
      final raw = data[0];
      if (raw is Map<String, dynamic>) {
        final model = MatchedUserModel.fromMap(raw);
        if (_matchedUser.contains(model.userId)) {
          // Remove from matched users list
          _matchedUser.remove(model.userId);

          // Create a model to notify the UI
          final tmpModel = MatchedUserModel(
            userId: model.userId,
            userName: model.userName,
            avatar: model.avatar,
            latitude: 0,
            longitude: 0,
            status: 'finish',
          );

          // Notify through stream
          if (!_matchedUserStream.isClosed) {
            _matchedUserStream.add(tmpModel);
          }

          // Also remove from matching users if present
          _matchingUser.removeWhere((user) => user.userId == model.userId);

          signalrLogger.i(
              '[MatchingHubService] ✅ Match finished for user ${model.userId}');
        }
      } else {
        signalrLogger.w('[MatchingHubService] ⚠️ Unexpected data format: $raw');
      }
    } catch (e) {
      signalrLogger
          .e('[MatchingHubService] ❌ Failed to parse finish match: $e');
    }
  }

  Future<void> dispose() async {
    await _matchedUserStream.close();
    await _matchingUserStream.close();
    _matchedUser.clear();
    await _core.dispose();
    signalrLogger.d('[MatchingHubService] ✅ StreamControllers disposed');
  }
}
