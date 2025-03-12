import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerService {
  Future<bool> requestPermission(
      Permission permission, String permissionName, BuildContext? context) async {
    final status = await permission.request();

    switch (status) {
      case PermissionStatus.granted:
        debugPrint("$permissionName permission granted");
        return true;

      case PermissionStatus.denied:
        debugPrint("$permissionName permission denied");
        _handleDeniedPermission(context, permissionName);
        return false;

      case PermissionStatus.permanentlyDenied:
        debugPrint("$permissionName permission permanently denied");
        _handlePermanentlyDeniedPermission(context, permissionName);
        return false;

      case PermissionStatus.restricted:
        debugPrint("$permissionName permission restricted");
        return false;

      case PermissionStatus.limited:
        debugPrint("$permissionName permission limited");
        return true;

      case PermissionStatus.provisional:
        debugPrint("$permissionName permission is provisional");
        return true;
    }
  }

  Future<bool> isPermissionGranted(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  void _handleDeniedPermission(BuildContext? context, String permissionName) {
    // Handle denied permission
  }

  void _handlePermanentlyDeniedPermission(BuildContext? context, String permissionName) {
    // Handle permanently denied permission
  }

  // Extend for other permissions as needed
}
