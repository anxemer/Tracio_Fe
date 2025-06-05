import 'dart:async';

import 'package:Tracio/core/constants/api_url.dart';
import 'package:Tracio/core/logger/signalr_logger.dart';
import 'package:Tracio/core/services/signalR/signalr_core_service.dart';
import 'package:Tracio/data/auth/sources/auth_local_source/auth_local_source.dart';
import 'package:Tracio/data/groups/models/response/group_route_location_update.dart';
import 'package:Tracio/domain/groups/entities/group_route_location_update.dart';
import 'package:Tracio/service_locator.dart';

class GroupRouteHubService {
  final SignalRCoreService _core;
  StreamController<GroupRouteLocationUpdateEntity> _locationUpdateStream =
      StreamController<GroupRouteLocationUpdateEntity>.broadcast();

  final List<String> _joinedGroupRouteIds = [];
  List<String> get joinedGroupRouteIds =>
      List.unmodifiable(_joinedGroupRouteIds);
  Stream<GroupRouteLocationUpdateEntity> get onLocationUpdate =>
      _locationUpdateStream.stream;

  GroupRouteHubService(this._core);

  Future<void> connect() async {
    String accessToken = await sl<AuthLocalSource>().getToken();
    assert(accessToken.isNotEmpty, '❌ accessToken is empty');
    signalrLogger.i(
        '[GroupRouteHub] 🔌 Connecting to ${ApiUrl.groupRouteHubUrl}/$accessToken...');
    await _core.init("${ApiUrl.groupRouteHubUrl}?token=$accessToken");
    signalrLogger.i('[GroupRouteHub] ✅ Connected');

    _core.on('ReceiveLocationUpdate', _handleReceiveLocationUpdate);
    _core.onReconnectSuccess(_handleReconnect);

    signalrLogger.d('[GroupRouteHub] 📡 Handlers registered');
  }

  Future<void> joinGroupRoute(String groupRouteId) async {
    signalrLogger.i('[GroupRouteHub] 📤 Sending JoinGroupRoute($groupRouteId)');
    try {
      String accessToken = await sl<AuthLocalSource>().getToken();
      assert(accessToken.isNotEmpty, '❌ accessToken is empty');
      await _core.invoke('JoinGroupRoute',
          args: [groupRouteId],
          hubUrl: ("${ApiUrl.groupRouteHubUrl}?token=$accessToken"));
      if (!_joinedGroupRouteIds.contains(groupRouteId)) {
        _joinedGroupRouteIds.add(groupRouteId);
      }
      signalrLogger.d('[GroupRouteHub] ✅ Joined group route: $groupRouteId');
    } catch (e) {
      signalrLogger.e('[GroupRouteHub] ❌ Failed to join group route: $e');
    }
  }

  Future<void> leaveGroupRoute(String groupRouteId) async {
    signalrLogger
        .i('[GroupRouteHub] 📤 Sending LeaveGroupRoute($groupRouteId)');
    try {
      _joinedGroupRouteIds.remove(groupRouteId);
      _core.off('ReceiveLocationUpdate');
      _core.off('ReconnectSuccess');
      await _core.dispose();
      signalrLogger.d('[GroupRouteHub] ✅ Left group route: $groupRouteId');
    } catch (e) {
      signalrLogger.e('[GroupRouteHub] ❌ Failed to leave group route: $e');
    }
  }

  void _handleReceiveLocationUpdate(List<Object?>? data) {
    if (data != null && data.isNotEmpty) {
      try {
        signalrLogger
            .i('[GroupRouteHub] 📥 Raw data for message update: $data');
        final user = sl<AuthLocalSource>().getUser();
        assert(user != null, '❌ user is null');

        final model = GroupRouteLocationUpdateModel.fromMap(
          Map<String, dynamic>.from(data[0] as Map),
        );
        if (model.userId != user!.userId && !_locationUpdateStream.isClosed) {
          _locationUpdateStream.add(model);
        }
      } catch (e) {
        signalrLogger
            .e('[GroupRouteHub] ❌ Failed to parse location update: $e');
      }
    }
  }

  void _handleReconnect({String? connectionId}) async {
    String accessToken = await sl<AuthLocalSource>().getToken();
    assert(accessToken.isNotEmpty, '❌ accessToken is empty');
    signalrLogger.i(
        '🔄 Rejoining ${_joinedGroupRouteIds.length} group routes after reconnect...');
    for (final id in _joinedGroupRouteIds) {
      _core
          .invoke('JoinGroupRoute',
              args: [id],
              hubUrl: ("${ApiUrl.groupRouteHubUrl}?token=$accessToken"))
          .then((_) => signalrLogger.d('✅ Rejoined group route: $id'))
          .catchError(
              (e) => signalrLogger.e('❌ Failed to rejoin group route $id: $e'));
    }
  }

  void dispose() {
    _locationUpdateStream.close();
    _core.off('ReceiveLocationUpdate');
    _core.off('ReconnectSuccess');
    _core.dispose();
    signalrLogger.d('[GroupRouteHub] ✅ StreamController disposed');
  }

  void endGroupRouteUpdateStream() {
    _locationUpdateStream.close();
    _joinedGroupRouteIds.clear();
    signalrLogger.d('[GroupRouteHub] ✅ Location update stream reset');
  }
}
