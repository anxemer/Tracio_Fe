import 'dart:async';

import 'package:Tracio/core/constants/api_url.dart';
import 'package:Tracio/core/logger/signalr_logger.dart';
import 'package:Tracio/core/services/signalR/signalr_core_service.dart';
import 'package:Tracio/data/groups/models/response/group_route_location_update.dart';
import 'package:Tracio/domain/groups/entities/group_route_location_update.dart';

class GroupRouteHubService {
  final SignalRCoreService _core;
  final _locationUpdateStream =
      StreamController<GroupRouteLocationUpdateEntity>.broadcast();

  final List<String> _joinedGroupRouteIds =
      []; // ✅ Tracking group routes đã join

  Stream<GroupRouteLocationUpdateEntity> get onLocationUpdate =>
      _locationUpdateStream.stream;

  GroupRouteHubService(this._core);

  Future<void> connect() async {  
    signalrLogger
        .i('[GroupRouteHub] 🔌 Connecting to ${ApiUrl.groupRouteHubUrl}...');
    await _core.init(ApiUrl.groupRouteHubUrl);
    signalrLogger.i('[GroupRouteHub] ✅ Connected');

    _core.on('ReceiveLocationUpdate', _handleReceiveLocationUpdate);
    _core
        .onReconnectSuccess(_handleReconnect); // ✅ Handle reconnect auto rejoin

    signalrLogger.d('[GroupRouteHub] 📡 Handlers registered');
  }

  Future<void> joinGroupRoute(String groupRouteId) async {
    signalrLogger.i('[GroupRouteHub] 📤 Sending JoinGroupRoute($groupRouteId)');
    try {
      await _core.invoke('JoinGroupRoute',
          args: [groupRouteId], hubUrl: ApiUrl.groupRouteHubUrl);
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
      await _core.invoke('LeaveGroupRoute',
          args: [groupRouteId], hubUrl: ApiUrl.groupRouteHubUrl);
      _joinedGroupRouteIds.remove(groupRouteId);
      signalrLogger.d('[GroupRouteHub] ✅ Left group route: $groupRouteId');
    } catch (e) {
      signalrLogger.e('[GroupRouteHub] ❌ Failed to leave group route: $e');
    }
  }

  void _handleReceiveLocationUpdate(List<Object?>? data) {
    if (data != null && data.isNotEmpty) {
      try {
        final model = GroupRouteLocationUpdateModel.fromMap(
          Map<String, dynamic>.from(data[0] as Map),
        );
        _locationUpdateStream.add(model);
      } catch (e) {
        signalrLogger
            .e('[GroupRouteHub] ❌ Failed to parse location update: $e');
      }
    }
  }

  void _handleReconnect({String? connectionId}) {
    signalrLogger.i(
        '🔄 Rejoining ${_joinedGroupRouteIds.length} group routes after reconnect...');
    for (final id in _joinedGroupRouteIds) {
      _core
          .invoke('JoinGroupRoute', args: [id], hubUrl: ApiUrl.groupRouteHubUrl)
          .then((_) => signalrLogger.d('✅ Rejoined group route: $id'))
          .catchError(
              (e) => signalrLogger.e('❌ Failed to rejoin group route $id: $e'));
    }
  }

  void dispose() {
    _locationUpdateStream.close();
    _core.dispose();
    signalrLogger.d('[GroupRouteHub] ✅ StreamController disposed');
  }
}
