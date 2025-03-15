import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionHandler {
  /// Checks and requests notification permission.
  /// If the permission is permanently denied, it guides the user to the app settings.
  Future<void> handleNotificationPermission(BuildContext context) async {
    PermissionStatus status = await Permission.notification.status;

    if (status.isGranted) {
      // Permission is already granted
      debugPrint("Notification permission is already granted.");
    } else if (status.isDenied) {
      // Request permission
      PermissionStatus newStatus = await Permission.notification.request();
      if (newStatus.isGranted) {
        debugPrint("Notification permission granted after request.");
      } else {
        if (context.mounted) {
          _showPermissionDialog(context);
        }
      }
    } else if (status.isPermanentlyDenied) {
      // Guide the user to the app settings

      if (context.mounted) {
        _showPermissionDialog(context);
      }
    }
  }

  /// Shows a dialog to guide the user to the app settings.
  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Notification Permission Required"),
          content: Text(
              "To receive notifications, please enable the permission in the app settings."),
          actions: <Widget>[
            TextButton(
              child: Text("Open Settings"),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
