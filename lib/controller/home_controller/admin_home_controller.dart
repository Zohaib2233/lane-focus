import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:lanefocus/core/constants/instance_collections.dart';
import 'package:lanefocus/core/constants/instance_constants.dart';
import 'package:lanefocus/model/user/circle_model.dart';
import 'package:lanefocus/services/googleMap/google_map.dart';

class AdminHomeController extends GetxController {
  RxList<CircleModel> circlesList = <CircleModel>[].obs;
  RxList<CircleModel> filteredCircleList = <CircleModel>[].obs;

  TextEditingController searchController = TextEditingController();

  RxBool isSearch = false.obs;

  RxInt familyIndex = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllCircles();
  }

  searchCircle({required String query}) {
    if (searchController.text.isEmpty) {
      isSearch(false);
      return;
    }
    isSearch(true);

    filteredCircleList.value =
        circlesList.where((model) => model.name!.contains(query)).toList();
  }

  getAllCircles() async {
    QuerySnapshot<Map<String, dynamic>> snapshots = await circlesCollection
        .where('ownerId', isEqualTo: userModelGlobal.value!.userId)
        .get();

    print("getAllCircles  = ${snapshots.docs.length}");

    for (DocumentSnapshot<Map<String, dynamic>> document in snapshots.docs) {
      circlesList
          .add(CircleModel.fromMap(document.data() as Map<String, dynamic>));
    }

    print("circlesList.length = ${circlesList.length}");

    // snapshots.docs.forEach(
    //     (document) => circlesList.add(CircleModel.fromMap(document.data())));
  }
}
