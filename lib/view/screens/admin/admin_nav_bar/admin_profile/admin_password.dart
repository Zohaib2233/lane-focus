import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/controller/profile_controller/profile_controller.dart';
import 'package:lanefocus/core/constants/instance_constants.dart';
import 'package:lanefocus/core/utils/dialogs.dart';
import 'package:lanefocus/services/firebaseServices/firebase_auth_service.dart';
import 'package:lanefocus/view/widget/congrats_dialog_widget.dart';
import 'package:lanefocus/view/widget/my_button_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:lanefocus/view/widget/my_textfield_widget.dart';
import 'package:lanefocus/view/widget/simple_app_bar_widget.dart';

import '../../../../../core/utils/validators.dart';

class AdminPassword extends StatelessWidget {
  ProfileController profileController = Get.find<ProfileController>();
   AdminPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(title: 'Password'),
      body: Form(
        key: profileController.changePassKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: AppSizes.DEFAULT,
                children: [
                  MyTextField(
                    heading: 'Current Password',
                    hint: '+01xxxxxxxxxxxxxx',
                    controller: profileController.currentPassword,
                    validator: ValidationService.instance.validatePassword,
                  ),
                  Obx(
                        () => MyTextField(
                      controller: profileController.newPassword,
                      heading: 'Password',
                      hint: '**********************',
                      isObSecure: profileController.isObSecurePass.value,
                      validator: (value) =>
                          ValidationService.instance.validatePassword(value),
                      suffix: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Image.asset(
                              profileController.isObSecurePass.value == true
                                  ? Assets.imagesEyeHide
                                  : Assets.imagesEye,
                              height: 24,
                            ),
                            onTap: () {
                              profileController.togglePassword();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(
                        () => MyTextField(
                      controller: profileController.repeatNewPassword,
                      heading: 'Repeat Password',
                      hint: '**********************',
                      validator: (value) => ValidationService.instance
                          .validateMatchPassword(
                          value!, profileController.newPassword.text),
                      isObSecure: profileController.isObSecureRepeatPass.value,
                      suffix: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Image.asset(
                              profileController.isObSecureRepeatPass.value == true
                                  ? Assets.imagesEyeHide
                                  : Assets.imagesEye,
                              height: 24,
                            ),
                            onTap: () {
                              profileController.toggleRepeatPassword();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  ...List.generate(
                    5,
                        (index) {
                      final data = [
                        'Minimum 8 Characters',
                        '1 Uppercase',
                        '1 Lowercase',
                        '1 Number ',
                        '1 Special Character',
                      ];
                      return MyBulletText(
                        text: data[index],
                      );
                    },
                  ),
                ],
              ),
            ),
            Obx(
              ()=>  Padding(
                padding: AppSizes.DEFAULT,
                child: profileController.isLoad.value == true? Center(
                  child: CircularProgressIndicator(),
                ) :MyButton(
                  buttonText: 'Save',
                  onTap: () async {
                    if (!profileController.changePassKey.currentState!.validate()) {
                      return;
                    }

                    profileController.isLoad.value = true;

                    bool isChanges = await profileController.changesPassword(context);
                    if (isChanges) {
                      Get.dialog(
                        CongratsDialog(
                          heading: 'Reset Password Successful!',
                          congratsText: 'Your password has been successfully changed.',
                          btnText: 'Done',
                          onTap: () {
                            Get.back();
                            Get.back();
                            profileController.clearPassControllers();
                          },
                        ),
                      );
                      profileController.isLoad.value = false;
                    } else {
                      log('Password change failed');
                      profileController.isLoad.value = false;

                    }
                  },
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
