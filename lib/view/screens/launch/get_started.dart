import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/controller/auth_controller/auth_controller.dart';
import 'package:lanefocus/view/screens/auth/login/login.dart';
import 'package:lanefocus/view/widget/my_button_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';

class GetStarted extends StatelessWidget {
  GetStarted({super.key});

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            Assets.imagesGetStarted,
            height: Get.height,
            width: Get.width,
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: Container(
              height: Get.height * 0.7,
              padding: AppSizes.DEFAULT,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    kBlackColor.withOpacity(0.0),
                    kBlackColor,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyButton(
                    buttonText: 'Log in as Driver',
                    onTap: () {
                      authController.role.value = 'driver';
                      Get.to(() => Login());
                    },
                  ),
                  MyText(
                    text: 'Log in as Administrator',
                    size: 16,
                    color: kPrimaryColor,
                    weight: FontWeight.w600,
                    textAlign: TextAlign.center,
                    paddingTop: 29,
                    onTap: () {
                      authController.role.value = 'admin';
                      Get.to(() => Login());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
