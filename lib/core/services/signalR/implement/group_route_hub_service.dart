import 'dart:async';

import 'package:tracio_fe/core/constants/api_url.dart';
import 'package:tracio_fe/core/logger/signalr_logger.dart';
import 'package:tracio_fe/core/services/signalR/signalr_core_service.dart';
import 'package:tracio_fe/data/groups/models/response/group_route_location_update.dart';
import 'package:tracio_fe/domain/groups/entities/group_route_location_update.dart';

class GroupRouteHubService {
  final SignalRCoreService _core;
  final _locationUpdateStream =
      StreamController<GroupRouteLocationUpdateEntity>.broadcast();

  Stream<GroupRouteLocationUpdateEntity> get onLocationUpdate =>
      _locationUpdateStream.stream;

  GroupRouteHubService(this._core);

  Future<void> connect() async {
    signalrLogger
        .i('[GroupRouteHub] 🔌 Connecting to ${ApiUrl.groupRouteHubUrl}...');
    await _core.init(ApiUrl.groupRouteHubUrl);
    signalrLogger.i('[GroupRouteHub] ✅ Connected');

    _core.on('ReceiveLocationUpdate', _handleReceiveLocationUpdate);
    signalrLogger
        .d('[GroupRouteHub] 📡 Handler registered for ReceiveLocationUpdate');
  }

  void _handleReceiveLocationUpdate(List<Object?>? data) {
    signalrLogger.i('[GroupRouteHub] 📍 Location update received: $data');

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

  Future<void> joinGroupRoute(String groupRouteId) async {
    signalrLogger.i('[GroupRouteHub] 📤 Sending JoinGroupRoute($groupRouteId)');
    await _core.invoke('JoinGroupRoute', args: [groupRouteId]);
  }

  void dispose() {
    _locationUpdateStream.close();
  }
}
