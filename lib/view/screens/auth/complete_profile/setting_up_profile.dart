import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/controller/auth_controller/auth_controller.dart';
import 'package:lanefocus/core/bindings/bindings.dart';
import 'package:lanefocus/view/screens/admin/admin_nav_bar/admin_nav_bar.dart';
import 'package:lanefocus/view/screens/driver/driver_nav_bar/driver_nav_bar.dart';
import 'package:lanefocus/view/widget/common_image_view_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:ripple_wave/ripple_wave.dart';

class SettingUpProfile extends StatefulWidget {
  const SettingUpProfile({super.key});

  @override
  State<SettingUpProfile> createState() => _SettingUpProfileState();
}

class _SettingUpProfileState extends State<SettingUpProfile> {
  @override
  final authController = Get.find<AuthController>();
  void initState() {
    Timer(Duration(seconds: 3), () {
      if (authController.currentRole.value == 0) {
        Get.offAll(() => DriverNavBar(), binding: DriverHomeBinding());
      } else {
        Get.offAll(() => AdminNavBar(), binding: AdminHomeBindings());
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: RippleWave(
              repeat: true,
              color: kPrimaryColor,
              duration: Duration(
                milliseconds: 1200,
              ),
              child: Center(
                child: CommonImageView(
                  imagePath: Assets.imagesLogo,
                  // url: dummyImg2,
                  height: 80,
                  width: 80,
                  radius: 100,
                  borderColor: kPrimaryColor,
                  borderWidth: 2,
                ),
              ),
            ),
          ),
          MyText(
            text: 'Setting up Your Profile',
            size: 15,
            color: kPrimaryColor,
            textAlign: TextAlign.center,
            paddingLeft: 20,
            paddingRight: 20,
            paddingBottom: 16,
          ),
        ],
      ),
    );
  }
}
