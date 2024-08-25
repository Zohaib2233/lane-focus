import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lanefocus/controller/home_controller/admin_home_controller.dart';
import 'package:lanefocus/core/constants/instance_collections.dart';
import 'package:lanefocus/model/user/geoPoint_model.dart';
import 'package:lanefocus/model/user/user_model.dart';
import 'package:lanefocus/services/googleMap/google_map.dart';

import '../../constants/app_images.dart';
import '../../model/user/circle_model.dart';


class AdminLocationController extends GetxController{

  Rx<Position?> initialPosition = Rx<Position?>(null);

  RxList<CircleModel> circlesList = <CircleModel>[].obs;
  
  RxList<UserModel> familyMembers = <UserModel>[].obs;


  RxList<Polyline> polylines = <Polyline>[].obs;

  List<StreamSubscription> _subscriptions = [];

  Rx<BitmapDescriptor> userIcon = BitmapDescriptor.defaultMarker.obs;
  RxInt familyIndex = 0.obs;
  RxBool isLoading = false.obs;

  GoogleMapController? mapController;
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await getInitialPosition();
    setCustomMarkerIcon();
    circlesList = Get.find<AdminHomeController>().circlesList;
    fetchFamilyMembers();
  }


  getInitialPosition() async {

    initialPosition.value = await GoogleMapsService.instance.getUserLocation();
  }

  getFamilyMembers(){

  }
  
  fetchFamilyMembers({int index = 0}){

    isLoading(true);
    familyMembers.clear();

    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    // Clear the list of subscriptions
    _subscriptions.clear();

    // polylines.clear();
    for(String userId in circlesList[index].members??[]){
      
      var subscription = usersCollection.doc(userId).snapshots().listen((snapshot){
        if(snapshot.exists){
          UserModel userModel = UserModel.fromJson(snapshot.data() as Map<String,dynamic>);
          familyMembers.removeWhere((member)=>member.userId==userId);
          familyMembers.add(userModel);
          if(userModel.isDriving??false){
            updatePolylines();
          }


        }

      });
      _subscriptions.add(subscription);
      
    }
    isLoading(false);
  }

  Future<List<LatLng>> getDrivingRoute(UserModel user) async {

    log("Get Driving Route Called");
    if (user.isDriving == true) {

      Geo startPoints = Geo();
      Geo endPoints = Geo();
      startPoints = Geo.fromJson(user.drivingModel!.startLoc!);
      endPoints = Geo.fromJson(user.drivingModel!.destinationLoc!);
      PolylinePoints polylinePoints = PolylinePoints();
      List<LatLng> polylineCoordinates = [];
      try{
        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
            googleApiKey: 'AIzaSyCzDroCZPt_UxGzLrIgoiqaZbQ30P_weo0',
            request: PolylineRequest(
                origin: PointLatLng(startPoints.geopoint?.latitude??0.0,endPoints.geopoint?.longitude??0.0),
                destination: PointLatLng(endPoints.geopoint?.latitude ?? 0.0,
                    endPoints.geopoint?.longitude ?? 0.0),
                mode: TravelMode.driving));

        log("Get Driving Route $result");

        if (result.points.isNotEmpty) {
          result.points.forEach((point) =>
              polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
          return polylineCoordinates;
        }
        else{
          return [];
        }

      }
      catch(e){
        throw Exception(e);

      }


    }
    else{
      return [];
    }

  }


  Future<void> updatePolylines() async {
    List<Polyline> newPolylines = [];

    for (UserModel user in familyMembers.where((user) => user.isDriving ?? false)) {
      List<LatLng> points = await getDrivingRoute(user);
      if (points.isNotEmpty) {
        newPolylines.add(
          Polyline(
            polylineId: PolylineId(user.userId ?? ''),
            points: points,
            color: Colors.blue,
            width: 5,
          ),
        );
      }
    }

    polylines.value = newPolylines;
  }



  setCustomMarkerIcon() {
    BitmapDescriptor.asset(
        ImageConfiguration(
          size: Size(32, 32),
        ),
        Assets.imagesCar)
        .then((icon) {
      userIcon.value = icon;

    });
  }

}