import 'dart:async';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
void startLocationService() {
  FlutterForegroundTask.setTaskHandler(LocationServiceHandler());
}

class LocationServiceHandler extends TaskHandler {
  bool _isPaused = false;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    try {
      if (starter.name == "system") {
        return;
      }
    } catch (e) {
      debugPrint('LocationServiceHandler: Error starting location service: $e');
      rethrow;
    }
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    debugPrint('LocationServiceHandler: onRepeatEvent called at $timestamp');
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isDestroyed) async {}

  @override
  void onNotificationButtonPressed(String id) {
    debugPrint('LocationServiceHandler: Notification button pressed: $id');
    if (id == 'pause_button') {
      _isPaused = true;
      debugPrint('LocationServiceHandler: Service paused');
      FlutterForegroundTask.updateService(
        notificationText: 'Paused - Tap to resume',
        notificationButtons: [
          NotificationButton(
            id: 'resume_button',
            text: 'Resume',
          ),
        ],
      );
    } else if (id == 'resume_button') {
      _isPaused = false;
      debugPrint('LocationServiceHandler: Service resumed');
      FlutterForegroundTask.updateService(
        notificationText: 'Tracking...',
        notificationButtons: [
          NotificationButton(
            id: 'pause_button',
            text: 'Pause',
          ),
        ],
      );
    }
  }
}
