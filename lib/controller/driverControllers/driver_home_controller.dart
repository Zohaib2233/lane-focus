import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as geoLoc;
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lanefocus/controller/alert_controller/alert_controller.dart';
import 'package:lanefocus/core/constants/instance_collections.dart';
import 'package:lanefocus/core/constants/instance_constants.dart';
import 'package:lanefocus/core/utils/dialogs.dart';
import 'package:lanefocus/model/user/geoPoint_model.dart';
import 'package:lanefocus/model/user/user_model.dart';

import 'package:lanefocus/services/firebaseServices/firebase_storage_service.dart';
import 'package:lanefocus/services/googleMap/google_map.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/app_images.dart';
import '../../core/global/functions.dart';
import '../../core/utils/snackbar.dart';
import '../../services/firebaseServices/firebase_crud_services.dart';
import '../../services/notificationService/local_notification_service.dart';

class DriverHomeController extends GetxController {
  Position? currentLocation;
  Position? endLocation;
  Position? startLocation;
  List<String> circlesAdminTokens = [];
  bool isDriving = false;
  bool isOverSpeeding = false;

  double markerRotation = 0.0;

  DateTime startDrivingTime = DateTime.now();

  Rx<Position?> currentPosition = Rx<Position?>(null);

  // final Completer<GoogleMapController> mapController = Completer();
  GoogleMapController? mapController;

  BitmapDescriptor userIcon = BitmapDescriptor.defaultMarker;

  LatLng destination = LatLng(33.6629, 73.0840);

  List<LatLng> polylineCoordinates = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    getCurrentLocation();
    isDriving = userModelGlobal.value?.isDriving ?? false;
    getCirclesAdminDeviceTokens();

    // setCustomMarkerIcon();
  }

  getCirclesAdminDeviceTokens() async {
    if (userModelGlobal.value?.circlesAdmin != null) {
      for (String adminId in userModelGlobal.value?.circlesAdmin ?? []) {
        DocumentSnapshot doc = await usersCollection.doc(adminId).get();
        UserModel userModel =
            UserModel.fromJson(doc.data() as Map<String, dynamic>);
        circlesAdminTokens.add(userModel.token ?? '');
      }
    }
  }

/*  Future<bool> getPolyLinePoints() async {
    if (currentLocation?.latitude != null) {
      print("ISDriving = ${isDriving}");
      PolylinePoints polylinePoints = PolylinePoints();
      PointLatLng startPointLatLng;
      if (userModelGlobal.value?.isDriving == true) {
        Geo geoStartPoint =
            Geo.fromJson(userModelGlobal.value!.drivingModel!.startLoc!);
        startPointLatLng = PointLatLng(geoStartPoint.geopoint?.latitude ?? 0,
            geoStartPoint.geopoint?.longitude ?? 0);
      } else {
        startPointLatLng =
            PointLatLng(startLocation!.latitude, startLocation!.longitude);
      }
      try{

        print("startPointLatLng = ${startPointLatLng}");

        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
            googleApiKey: 'AIzaSyCbpaChFThaTUy45ft5TJnP9tapTEXsOQU',
            request: PolylineRequest(
                origin: startPointLatLng,
                destination: PointLatLng(currentLocation?.latitude ?? 0.0,
                    currentLocation?.longitude ?? 0.0),
                mode: TravelMode.driving));
        log('result of plyline ${result.toString()}');

        if (result.points.isNotEmpty) {
          print("Result polylines = ${result.points}");
          result.points.forEach((point) =>
              polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
          update();

          return true;
        }else{
          log('polyline points are not:)');
          return false;
        }
      
      }catch(e){
        return false;

      }
    }
    return false;
  }*/


  Future<bool> getPolyLinePoints() async {
    if (currentLocation?.latitude != null) {
      print("ISDriving = ${isDriving}");
      PolylinePoints polylinePoints = PolylinePoints();
      PointLatLng startPointLatLng;
      if (userModelGlobal.value?.isDriving == true) {
        Geo geoStartPoint =
        Geo.fromJson(userModelGlobal.value!.drivingModel!.startLoc!);
        startPointLatLng = PointLatLng(geoStartPoint.geopoint?.latitude ?? 0,
            geoStartPoint.geopoint?.longitude ?? 0);
      } else {
        startPointLatLng =
            PointLatLng(startLocation!.latitude, startLocation!.longitude);
      }

      try {
        print("startPointLatLng = ${startPointLatLng}");

        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
            googleApiKey: 'AIzaSyCzDroCZPt_UxGzLrIgoiqaZbQ30P_weo0',
            request: PolylineRequest(
                origin: startPointLatLng,
                destination: PointLatLng(currentLocation?.latitude ?? 0.0,
                    currentLocation?.longitude ?? 0.0),
                mode: TravelMode.driving));

        print("Result of Polyline API call: ${result.status}");
        log('result of polyline ${result.toString()}');

        if (result.points.isNotEmpty) {
          print("Result polylines = ${result.points}");
          result.points.forEach((point) =>
              polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
          update();

          return true;
        } else {
          log('Polyline points are empty');
          return false;
        }
      } catch (e) {
        log('Exception occurred: $e');
        return false;
      }
    }
    return false;
  }



  setStartLocation({required BuildContext context}) {
    DialogService.instance.showProgressDialog(context: context);
    Geolocator.getCurrentPosition().then((location) async {
      startLocation = location;

      GeoFirePoint startPoint =
          GeoFirePoint(GeoPoint(location.latitude, location.longitude));
      try {
        await usersCollection.doc(auth.currentUser!.uid).update({
          'overSpeedCount': 0,
          'drivingModel': DrivingModel(
                  drivingSince: startDrivingTime, startLoc: startPoint.data)
              .toMap()
        });
      } on FirebaseException catch (e) {
        final errorMessage = getFirestoreErrorMessage(e);
        CustomSnackBars.instance
            .showFailureSnackbar(title: 'Error', message: errorMessage);
      } catch (e) {
        log("This was the exception while updating document single key on Firestore: $e");
      }

     bool getpolylines  = await getPolyLinePoints();
      if(getpolylines){
        DialogService.instance.hideLoading();
        update();
      }
      else{
        DialogService.instance.hideLoading();
        update();
      }


    });
  }

  setEndLocation() {
    Geolocator.getCurrentPosition().then((location) async {
      endLocation = location;
    });
  }

  getCurrentLocation() async {
    await Permission.location.request();
    GoogleMapsService.instance.getUserLocation();

    if (await Permission.location.request().isGranted) {
      // GoogleMapController googleMapController = await mapController.future;

      Geolocator.getCurrentPosition().then((location) {
        print("currentLocation.latitude = ${currentLocation?.latitude}");
        print("currentLocation.latitude = ${currentLocation?.longitude}");
        setCustomMarkerIcon();
        update();
      });

      Geolocator.getPositionStream(
              locationSettings: LocationSettings(
                  distanceFilter: 15,
                  accuracy: geoLoc.LocationAccuracy.bestForNavigation))
          .listen((newLoc) async {
        print(
            "On Location Changed $isDriving ${newLoc.headingAccuracy} % ${newLoc.heading}");

        currentLocation = newLoc;

        if (isDriving) {
          GeoFirePoint geoFirePoint =
              GeoFirePoint(GeoPoint(newLoc.latitude, newLoc.longitude));
          GeoFirePoint geoStartPoint;

          if (userModelGlobal.value?.isDriving == true) {
            Geo startPoint =
                Geo.fromJson(userModelGlobal.value!.drivingModel!.startLoc!);
            geoStartPoint = GeoFirePoint(GeoPoint(
                startPoint.geopoint?.latitude ?? 0,
                startPoint.geopoint?.longitude ?? 0));
          } else {
            geoStartPoint = GeoFirePoint(
                GeoPoint(startLocation!.latitude, startLocation!.longitude));
          }

          double speedMps = newLoc.speed * 3.6;

          if (isOverSpeeding == false && speedMps > 100) {
            isOverSpeeding = true;
            FirebaseCRUDServices.instance.updateDocumentSingleKey(
                collection: usersCollection,
                docId: auth.currentUser!.uid,
                key: 'overSpeedCount',
                value: FieldValue.increment(1));

            if (circlesAdminTokens.isNotEmpty) {
              String accessToken =
                  await LocalNotificationService.instance.getAccessToken();
              for (int i = 0; i < circlesAdminTokens.length; i++) {
                log('inside loop');
                await LocalNotificationService.instance
                    .sendFCMNotificationWithToken(
                        deviceToken: circlesAdminTokens[i],
                        title: 'Alert',
                        body:
                            "${userModelGlobal.value?.fullName} is OverSpeeding",
                        type: 'alerts',
                        sentBy: userModelGlobal.value!.userId!,
                        sentTo: userModelGlobal.value!.circlesAdmin![i],
                        savedToFirestore: true,
                        accessToken: accessToken.toString());
              }
            }
            //Todo: Add Alert Sending Here
          } else {
            isOverSpeeding = false;
          }

          print("Location is On $isDriving");
          bool isDocAdded = await FirebaseCRUDServices.instance
              .updateDocumentSingleKey(
                  collection: usersCollection,
                  docId: auth.currentUser!.uid,
                  key: 'drivingModel',
                  value: DrivingModel(
                          totalSpeed: '${speedMps}',
                          drivingSince: startDrivingTime,
                          drivingTill: DateTime.now(),
                          destinationLoc: geoFirePoint.data,
                          startLoc: geoStartPoint.data)
                      .toMap());
          polylineCoordinates.clear();
          await getPolyLinePoints();

          print("Doc Added $isDocAdded");
        }
        markerRotation = newLoc.heading;
        update();
      });
      // location.onLocationChanged.listen((newLoc){
      //
      // });
    } else {
      Get.dialog(
        AlertDialog(
          title: Text('Enable Location'),
          content: Text('Please enable location services to continue.'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Dismiss the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Get.back(); // Dismiss the dialog
                openAppSettings();
              },
              child: Text('Open Settings'),
            ),
          ],
        ),
      );
    }
  }

  setCustomMarkerIcon() {
    BitmapDescriptor.asset(
            ImageConfiguration(
              size: Size(32, 32),
            ),
            Assets.imagesCar)
        .then((icon) {
      userIcon = icon;
      update();
    });
  }
}
