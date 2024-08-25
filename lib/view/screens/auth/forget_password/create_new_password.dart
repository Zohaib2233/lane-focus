import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/view/screens/auth/login/login.dart';
import 'package:lanefocus/view/widget/congrats_dialog_widget.dart';
import 'package:lanefocus/view/widget/heading_widget.dart';
import 'package:lanefocus/view/widget/my_button_widget.dart';
import 'package:lanefocus/view/widget/my_textfield_widget.dart';
import 'package:lanefocus/view/widget/simple_app_bar_widget.dart';

class CreateNewPassword extends StatelessWidget {
  const CreateNewPassword({super.key});

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
                AuthHeading(
                  heading: 'Create New Password',
                  subTitle:
                      'Enter your new password. If you forget it, then you have to do forgot password.',
                  paddingTop: 0,
                ),
                MyTextField(
                  heading: 'Password',
                  hint: '**********************',
                  isObSecure: true,
                  suffix: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.imagesEyeHide,
                          height: 24,
                        ),
                      ]),
                ),
                MyTextField(
                  heading: 'Repeat Password',
                  hint: '**********************',
                  isObSecure: true,
                  suffix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Assets.imagesEyeHide,
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              buttonText: 'Continue',
              onTap: () {
                Get.dialog(
                  CongratsDialog(
                    heading: 'Reset Password Successful!',
                    congratsText:
                        'Your password has been successfully changed.',
                    btnText: 'Back To Login',
                    onTap: () {
                      Get.offAll(() => Login());
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
