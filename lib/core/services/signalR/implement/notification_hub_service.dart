import 'dart:async';
import 'package:Tracio/data/auth/sources/auth_local_source/auth_local_source.dart';
import 'package:Tracio/presentation/notifications/page/notifications.dart';
import 'package:Tracio/service_locator.dart';
import '../../../../common/helper/notification/notification_model.dart';
import '../../../constants/api_url.dart';
import '../../../logger/signalr_logger.dart';
import '../signalr_core_service.dart';

class NotificationHubService {
  final SignalRCoreService _core;
  final _notificationStream = StreamController<NotificationModel>.broadcast();
  Stream<NotificationModel> get onMessageUpdate => _notificationStream.stream;
  bool _isConnected = false;

  NotificationHubService(this._core);

  Future<void> connect() async {
    if (_isConnected) {
      return;
    }

    var token = await sl<AuthLocalSource>().getToken();
    if (token.isEmpty) {
      signalrLogger
          .w('[NotificationService] ❌ No token found. Skipping connect.');
      return;
    }

    signalrLogger
        .i('[NotificationService] 🔌 Connecting to ${ApiUrl.notiHubUrl}...');
    await _core.init('${ApiUrl.notiHubUrl}?token=$token');
    _core.on('ReceiveNotification', _handleReceiveNotification);
    _isConnected = true;
    signalrLogger.i('[NotificationService] ✅ Connected and handler registered');
  }

  void _handleReceiveNotification(List<Object?>? data) {
    if (data == null || data.isEmpty) {
      signalrLogger.w('[NotificationService] ⚠️ No data received');
      return;
    }

    signalrLogger
        .i('[NotificationService] 📥 Raw data for message update: $data');

    try {
      if (data[0] is Map) {
        final map = Map<String, dynamic>.from(data[0] as Map);
        final model = NotificationModel.fromMap(map);
        _notificationStream.add(model);
        signalrLogger
            .i('[NotificationService] ✅ Parsed notification: ${model.message}');
      } else {
        signalrLogger
            .e('[NotificationService] ❌ Invalid data format: ${data[0]}');
      }
    } catch (e, stackTrace) {
      signalrLogger.e(
          '[NotificationService] ❌ Failed to parse message update: $e\n$stackTrace');
    }
  }

  void dispose() {
    _notificationStream.close();
    _core.dispose();
    signalrLogger.d('[NotificationHubService] ✅ StreamController disposed');
  }
}
