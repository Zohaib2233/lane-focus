import 'package:permission_handler/permission_handler.dart';

import '../../core/enums/location_permission.dart';

class PermissionService {
  // Private constructor
  PermissionService._privateConstructor();

  // Singleton instance variable
  static PermissionService? _instance;

  //This code ensures that the singleton instance is created only when it's accessed for the first time.
  //Subsequent calls to PermissionService.instance will return the same instance that was created before.

  // Getter to access the singleton instance
  static PermissionService get instance {
    _instance ??= PermissionService._privateConstructor();
    return _instance!;
  }

  //method to get permissions
  Future<LocationPermissionStatus> getLocationPermissionStatus() async {
    // await Permission.location.request();

    var status = await Permission.location.request();
    if (status.isGranted) {
      return LocationPermissionStatus.granted;
    } else if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before, but not permanently.
      return LocationPermissionStatus.denied;
    } else if (status.isPermanentlyDenied) {
      // We didn't ask for permission yet or the permission has been denied before, but not permanently.
      return LocationPermissionStatus.permanentlyDenied;
    }

    return LocationPermissionStatus.unknown;
  }

  Future<BluetoothPermissionStatus> getBluetoothPermissionStatus() async {
    // await Permission.location.request();

    var status = await Permission.bluetooth.request();
    if (status.isGranted) {
      return BluetoothPermissionStatus.granted;
    } else if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before, but not permanently.
      return BluetoothPermissionStatus.denied;
    } else if (status.isPermanentlyDenied) {
      // We didn't ask for permission yet or the permission has been denied before, but not permanently.
      return BluetoothPermissionStatus.permanentlyDenied;
    }

    return BluetoothPermissionStatus.unknown;
  }

  //method to get permissions
  Future<NotificationPermissionStatus> getNotifPermissionStatus() async {
    // await Permission.location.request();

    var status = await Permission.notification.request();
    if (status.isGranted) {
      return NotificationPermissionStatus.granted;
    } else if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before, but not permanently.
      return NotificationPermissionStatus.denied;
    } else if (status.isPermanentlyDenied) {
      // We didn't ask for permission yet or the permission has been denied before, but not permanently.
      return NotificationPermissionStatus.permanentlyDenied;
    }

    return NotificationPermissionStatus.unknown;
  }
}
