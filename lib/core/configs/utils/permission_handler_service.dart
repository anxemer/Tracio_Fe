import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerService {
  /// Requests a single permission and handles the result.
  ///
  /// Parameters:
  ///   `permission`: The `Permission` to request (e.g., `Permission.location`).
  ///   `permissionName`: A human-readable name for the permission (e.g., "Location").
  ///   `context`: Flutter context for displaying dialogs (optional, only needed for permanently denied).
  ///
  /// Returns:
  ///   `true` if the permission is granted, `false` otherwise.
  Future<bool> requestPermission(Permission permission, String permissionName,
      BuildContext? context) async {
    final status = await permission.request();

    switch (status) {
      case PermissionStatus.granted:
        debugPrint("$permissionName permission granted");
        return true;

      case PermissionStatus.denied:
        debugPrint("$permissionName permission denied");
        if (context != null) {
          _showAppSettingsDialog(context, permissionName);
        } else {
          debugPrint(
              "Context is null. Cannot show app settings dialog. Please handle this case in your UI.");
        }
        return false;

      case PermissionStatus.permanentlyDenied:
        debugPrint("$permissionName permission permanently denied");
        if (context != null) {
          _showAppSettingsDialog(context, permissionName);
        } else {
          debugPrint(
              "Context is null. Cannot show app settings dialog. Please handle this case in your UI.");
        }
        return false;

      case PermissionStatus.restricted:
        debugPrint(
            "$permissionName permission restricted (iOS). This usually means parental controls are enabled.");
        return false;

      case PermissionStatus.limited:
        debugPrint(
            "$permissionName permission limited (iOS). The user granted limited access.");
        return true; // Or handle differently based on your needs.

      case PermissionStatus.provisional:
        debugPrint("$permissionName permission is provisional.");
        return true; // You can decide how to handle this case
    }
  }

  /// Checks if a single permission is granted.
  ///
  /// Parameters:
  ///   `permission`: The `Permission` to check (e.g., `Permission.location`).
  ///
  /// Returns:
  ///   `true` if the permission is granted, `false` otherwise.
  Future<bool> isPermissionGranted(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  /// Shows a dialog to the user explaining that the permission is permanently denied
  /// and prompting them to open app settings.
  void _showAppSettingsDialog(BuildContext context, String permissionName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Permission Required"),
          content: Text(
              "The $permissionName permission is required for this feature. Please enable it in app settings."),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Open Settings"),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
