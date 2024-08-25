import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/enums/location_permission.dart';
import '../permissionsService/permissions.dart';

class GoogleMapsService {
  //private constructor
  GoogleMapsService._privateConstructor();

  //singleton instance variable
  static GoogleMapsService? _instance;

  static GoogleMapsService get instance {
    _instance ??= GoogleMapsService._privateConstructor();
    return _instance!;
  }

  //method to get user's location
  Future<Position> _determinePosition() async {
    bool serviceEnabled;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // return Future.error('Location services are disabled.');

      openAppSettings();

      // Get.dialog(PermissionDialog(
      //     onAllowTap: () {
      //       openAppSettings();
      //     },
      //     description: "Please turn on the device location",
      //     permission: "",
      //     icon: Assets.imagesGoogle));
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  //method to check if the user has allowed location permission and get the user location
  Future<Position?> getUserLocation() async {
    //user location
    Position? userLocation;

    // //getting location permission status
    LocationPermissionStatus status =
        await PermissionService.instance.getLocationPermissionStatus();
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      userLocation = await _determinePosition();
    } else if (permission == LocationPermission.deniedForever) {
      // await Get.dialog(PermissionDialog(
      //   onAllowTap: () {
      //     //opening app settings to allow user to give permissions
      //     openAppSettings();
      //   },
      //   permission: "Location",
      //   icon: Assets.imagesEventIcon,
      // ));
      // openAppSettings();
      // Geolocator.openLocationSettings();

      //closing dialog
      // Get.back();

      //getting permission status again
      LocationPermissionStatus status =
          await PermissionService.instance.getLocationPermissionStatus();

      if (status == LocationPermissionStatus.granted) {
        userLocation = await _determinePosition();
      }
    } else if (permission == LocationPermission.denied) {
      LocationPermissionStatus status =
          await PermissionService.instance.getLocationPermissionStatus();
      if (status == LocationPermissionStatus.granted) {
        userLocation = await _determinePosition();
      }
    }

    return userLocation;
  }

  Future<String> getAddressThroughCurrentLoc() async {
    print("Called");
    Position? position = await getUserLocation();
    List<Placemark> placeMarks = await placemarkFromCoordinates(
        position?.latitude ?? 39, position?.longitude ?? 34);
    print("Address ${placeMarks[0]}");
    return '${placeMarks[0].street}, ${placeMarks[0].subLocality} ${placeMarks[0].administrativeArea}, ${placeMarks[0].country}';
  }

  Future<List<Placemark>> getAddressThroughLatLong(
      {required double lat, required double long}) async {
    print("Called");

    List<Placemark> placeMarks = await placemarkFromCoordinates(lat, long);
    // print("Address ${placeMarks[2]} length =  ${placeMarks.length}");

    // print(
    //     '${placeMarks[0].name}, ${placeMarks[0].subLocality} ${placeMarks[0].administrativeArea}, ${placeMarks[0].country}');

    return placeMarks;
  }

  Future<Location> getAltitudesThroughAddress({required String address}) async {
    List<Location> locations = await locationFromAddress(address);

    return locations.first;
  }
}
