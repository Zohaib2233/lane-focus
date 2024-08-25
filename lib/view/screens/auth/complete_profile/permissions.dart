import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/controller/auth_controller/auth_controller.dart';
import 'package:lanefocus/core/bindings/bindings.dart';
import 'package:lanefocus/core/constants/firebase_constants.dart';
import 'package:lanefocus/core/constants/instance_constants.dart';
import 'package:lanefocus/core/global/functions.dart';
import 'package:lanefocus/core/utils/snackbar.dart';
import 'package:lanefocus/model/user/user_model.dart';
import 'package:lanefocus/services/firebaseServices/firebase_crud_services.dart';
import 'package:lanefocus/view/screens/driver/driver_nav_bar/driver_nav_bar.dart';
import 'package:lanefocus/view/widget/my_button_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:lanefocus/view/widget/simple_app_bar_widget.dart';

import '../../admin/admin_nav_bar/admin_nav_bar.dart';

class Permissions extends StatefulWidget {
  Permissions({super.key});

  @override
  State<Permissions> createState() => _PermissionsState();
}

class _PermissionsState extends State<Permissions> {
  final authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(title: ''),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: AppSizes.DEFAULT,
              children: [
                MyText(
                  text:
                      'LaneFocus requires these permissions to work properly!',
                  size: 20,
                  weight: FontWeight.w600,
                  paddingBottom: 16,
                ),
                Obx(
                  () => _PermissionTile(
                    title: 'Bluetooth',
                    subTitle:
                        'Connect to nearby devices and improve location updates for the LaneFocus community.',
                    value: userModelGlobal.value?.bluetoothOn ?? false,
                    onToggle: (bool value) async {
                      await authController.getBluetoothPermssion();
                    },
                  ),
                ),
                Obx(
                  () => _PermissionTile(
                    title: 'Location',
                    subTitle:
                        'Location set to "Always" is used to enable data use for the in-app map, Place Alerts, and location sharing with your Circle.',
                    value: userModelGlobal.value?.locOn ?? false,
                    onToggle: (bool value) async {
                      await authController.getLocationPermission();
                    },
                  ),
                ),
                Obx(
                  () => _PermissionTile(
                    title: 'Push Notifications',
                    subTitle:
                        'Stay up-to-date with check-ins, alerts, and messages from your Circle',
                    value: userModelGlobal.value?.notifOn ?? false,
                    onToggle: (bool value) async {
                      await authController.getNotificationPermission();
                    },
                  ),
                ),
                // _PermissionTile(
                //   title: 'Motion Sensors',
                //   subTitle:
                //       'Motion activity data provides more reliable location, enables Driving Safety features, analytics, and Crash Detection.',
                //   value: true,
                //   onToggle: (bool value) {},
                // ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyText(
                  text:
                      'In addition to the above, your location data will be used in accordance with our Privacy Policy and your preferences which may include sharing with third parties for purposes such as research, tailored advertising, and analytics.',
                  size: 10,
                  weight: FontWeight.w300,
                  textAlign: TextAlign.center,
                  paddingBottom: 14,
                ),
                MyButton(
                  buttonText: 'Continue',
                  onTap: () async {
                    getUserDataStream(userId: auth.currentUser!.uid);
                    DocumentSnapshot? snapshot = await FirebaseCRUDServices.instance.readSingleDoc(collectionReference: FirebaseConstants.userCollectionReference, docId: auth.currentUser!.uid);
                    if(snapshot!=null){
                      print("snapshot data = ${snapshot.data()}");
                      UserModel userModel = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
                      if (userModel.role == 'admin') {
                        Get.offAll(AdminNavBar(), binding: AdminHomeBindings());
                      } else {
                        Get.offAll(DriverNavBar(), binding: DriverHomeBinding());
                      }
                    }
                    else{
                      CustomSnackBars.instance.showFailureSnackbar(title: "Failed", message: "Internet Issue");
                    }


                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final String title, subTitle;
  final bool value;
  final ValueChanged<bool> onToggle;
  const _PermissionTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.value,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: MyText(
                  text: title,
                  size: 15,
                  weight: FontWeight.w600,
                ),
              ),
              FlutterSwitch(
                value: value,
                onToggle: onToggle,
                height: 20,
                width: 36,
                toggleSize: 16,
                padding: 2,
                activeColor: kSecondaryColor,
                inactiveColor: kInputBorderColor,
              ),
            ],
          ),
          MyText(
            text: subTitle,
            color: kQuaternaryColor,
            paddingTop: 10,
          ),
        ],
      ),
    );
  }
}
