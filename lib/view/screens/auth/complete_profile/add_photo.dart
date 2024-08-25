import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/controller/auth_controller/auth_controller.dart';
import 'package:lanefocus/controller/home_controller/circle_controller.dart';
import 'package:lanefocus/core/constants/instance_constants.dart';
import 'package:lanefocus/core/utils/image_picker.dart';
import 'package:lanefocus/view/screens/auth/complete_profile/permissions.dart';
import 'package:lanefocus/view/widget/heading_widget.dart';
import 'package:lanefocus/view/widget/my_button_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:lanefocus/view/widget/simple_app_bar_widget.dart';

import '../../../../core/constants/constants.dart';

class AddPhoto extends StatelessWidget {
  AddPhoto({super.key, this.fromLink, this.cId});
  bool? fromLink;
  String? cId;
  final authController = Get.find<AuthController>();
  final circleController = Get.find<CircleController>();

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
                  heading: 'Add your photo',
                  subTitle:
                      'This makes  it easy for your family to find on the map.',
                  headingSize: 20,
                  paddingBottom: 48,
                ),
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      Assets.imagesMap,
                      height: 140,
                      width: Get.width,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Image.asset(
                        Assets.imagesProfileLocationMark,
                        height: 80,
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible: authController.imgPath.isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 56),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundImage: FileImage(
                              File(authController.imgPath.value),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                MyButton(
                  buttonText: 'Upload Your Photo',
                  onTap: () async {
                    ImagePickerService.instance.openProfilePickerBottomSheet(
                        context: context,
                        onCameraPick: () async {
                          var file = await ImagePickerService.instance
                              .pickImageFromCamera();
                          if (file != null) {
                            authController.imgPath.value = file.path;
                            log('file_path:${authController.imgPath.value.toString()}');

                          }
                        },
                        onGalleryPick: () async {
                          var file = await ImagePickerService.instance
                              .pickSingleImageFromGallery();
                          if (file != null) {
                            authController.imgPath.value = file.path;
                            log('file_path:${authController.imgPath.value.toString()}');
                          }
                        });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyButton(
                  buttonText: 'Continue',
                  onTap: () async {
                    if (fromLink == null || fromLink == false) {
                      authController.role.value = admin;
                    } else {
                      authController.role.value = driver;
                    }

                    await authController.saveUserData(
                        auth.currentUser!.email,
                        authController.dob,
                        authController.fName.text,
                        authController.lName.text,
                        authController.imgPath.value,
                        authController.role.value,
                        authController.signupMethod.value,
                        authController.phoneNumberController.text.trim(),
                        context);

                    if (fromLink == true) {
                      print("Method Called Add Memeber");
                      await circleController.addMember(
                          cId ?? '', auth.currentUser!.uid);
                      Get.to(() => Permissions());
                    } else {
                      Get.to(() => Permissions());
                    }
                  },
                ),
                MyText(
                  text: 'Skip',
                  color: kSecondaryColor,
                  weight: FontWeight.w600,
                  textAlign: TextAlign.center,
                  paddingTop: 16,
                  onTap: () async {
                    if (fromLink == null || fromLink == false) {

                      authController.role.value = admin;
                    } else {
                      authController.role.value = driver;
                    }
                    await authController.saveUserData(
                        auth.currentUser!.email,
                        authController.dob,
                        authController.fName.text,
                        authController.lName.text,
                        authController.imgPath.value,
                        authController.role.value,
                        authController.signupMethod.value,
                        authController.phoneNumberController.text.trim(),
                        context);

                    if (fromLink == true) {
                      await circleController.addMember(

                          cId??'', auth.currentUser!.uid);

                    }
                    Get.to(() => Permissions());
                  },
                ),
//                 MyText(
//                   text: 'Skip',
//                   color: kSecondaryColor,
//                   weight: FontWeight.w600,
//                   textAlign: TextAlign.center,
//                   paddingTop: 16,
//                   onTap: () async {
//                     if (fromLink == null || fromLink == false) {
//                       authController.role.value = admin;
//                     } else {
//                       authController.role.value = driver;
//                     }
//                     await authController.saveUserData(
//                         auth.currentUser!.email,
//                         authController.dob,
//                         authController.fName.text,
//                         authController.lName.text,
//                         authController.imgPath.value,
//                         authController.role.value,
//                         authController.signupMethod.value,
//                         authController.phoneNumberController.text.trim(),
//                         context);
//
//                     if (fromLink == true) {
//                       await circleController.addMember(
//                           cId!, auth.currentUser!.uid);
// >>>>>>> qudrat_profile_module(05_jul_2024)
//                     }
//                     Get.to(() => Permissions());
//                   },
//                 ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
