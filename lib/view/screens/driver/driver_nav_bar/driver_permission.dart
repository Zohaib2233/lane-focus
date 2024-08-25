import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/controller/auth_controller/auth_controller.dart';
import 'package:lanefocus/core/constants/instance_constants.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';

class DriverPermission extends StatelessWidget {
  DriverPermission({super.key});
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: AppSizes.DEFAULT,
        children: [
          SizedBox(
            height: 40,
          ),

       /// this is the alert related text

       /*   Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                Assets.imagesAddBg,
                height: 40,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MyText(
                      text: 'Add emergency contacts',
                      size: 16,
                      weight: FontWeight.w500,
                      paddingBottom: 1,
                    ),
                    MyText(
                      text: '00 Contacts',
                      size: 11,
                      color: kQuaternaryColor,
                      paddingBottom: 10,
                    ),
                    Container(
                      height: 1,
                      color: kInputBorderColor,
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),*/


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
    required this.title,
    required this.subTitle,
    required this.value,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: MyText(
                  text: title,
                  size: 15,
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
            size: 12,
            weight: FontWeight.w300,
            color: kQuaternaryColor,
            paddingTop: 2,
          ),
        ],
      ),
    );
  }
}
