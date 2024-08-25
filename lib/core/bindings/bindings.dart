import 'package:get/get.dart';
import 'package:lanefocus/controller/adminControllers/admin_location_controller.dart';
import 'package:lanefocus/controller/alert_controller/alert_controller.dart';
import 'package:lanefocus/controller/auth_controller/auth_controller.dart';
import 'package:lanefocus/controller/chat_controller/chat_controller.dart';
import 'package:lanefocus/controller/driverControllers/driver_home_controller.dart';
import 'package:lanefocus/controller/general_controller.dart';
import 'package:lanefocus/controller/home_controller/admin_home_controller.dart';
import 'package:lanefocus/controller/home_controller/circle_controller.dart';

import 'package:lanefocus/controller/profile_controller/profile_controller.dart';

import 'package:lanefocus/controller/phone_usage_controller/phone_usage_driver_controller.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<CircleController>(CircleController());
    Get.put<AuthController>(AuthController());
    Get.put<GeneralController>(GeneralController());
    Get.put<ProfileController>(ProfileController());
    Get.put<AlertController>(AlertController());
  }
}

class AdminHomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<ChatController>(ChatController());
    Get.put(AdminHomeController());
    Get.put(AdminLocationController());
  }
}


class ProfileBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<ProfileController>(ProfileController());
  }
}

class AlertBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(AlertController());
  }



}

class DriverHomeBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies

    Get.put<ChatController>(ChatController());
    Get.put<DriverHomeController>(DriverHomeController());
    Get.put<PhoneUsageDriverController>(PhoneUsageDriverController());

  }



}

// class PhoneUsageBindings implements Bindings {
//   @override
//   void dependencies() {
//     Get.put<PhoneUsageDriverController>(PhoneUsageDriverController());
//   }
// }

