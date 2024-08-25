import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/core/bindings/bindings.dart';
import 'package:lanefocus/core/constants/instance_collections.dart';
import 'package:lanefocus/core/constants/instance_constants.dart';
import 'package:lanefocus/core/global/functions.dart';
import 'package:lanefocus/services/firebaseServices/firebase_crud_services.dart';
import 'package:lanefocus/services/local_storage/local_storage_service.dart';
import 'package:lanefocus/view/screens/admin/admin_nav_bar/admin_nav_bar.dart';
import 'package:lanefocus/view/screens/auth/complete_profile/name.dart';
import 'package:lanefocus/view/screens/auth/login/login.dart';
import 'package:lanefocus/view/screens/driver/driver_nav_bar/driver_nav_bar.dart';
import 'package:lanefocus/view/screens/launch/on_boarding.dart';

import '../../../services/notificationService/local_notification_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState()  {
    if (auth.currentUser != null) {
      getUserDataStream(userId: auth.currentUser!.uid);

      Future.delayed((const Duration(seconds: 2)), () {
        log("message: ${userModelGlobal.value?.toJson()}");

        if (userModelGlobal.value?.onBoardComp == true) {
          if (userModelGlobal.value?.role == "admin") {
            Get.offAll(const AdminNavBar(), binding: AdminHomeBindings());
          } else {
            Get.offAll(const DriverNavBar(), binding: DriverHomeBinding());
          }
        } else {
        }
      });
    } else {
      Future.delayed((const Duration(seconds: 2)), () async {
        bool? notfirstTime =
            await LocalStorageService.instance.read(key: 'notfirstTime');
        if (notfirstTime == true) {
          Get.offAll(Login());
        } else {
          Get.offAll(() => OnBoarding());
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          Assets.imagesAppLogo,
          height: 64,
        ),
      ),
    );
  }
}
