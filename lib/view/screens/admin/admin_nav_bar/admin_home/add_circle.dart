import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/controller/home_controller/circle_controller.dart';
import 'package:lanefocus/core/utils/app_strings.dart';
import 'package:lanefocus/core/utils/image_picker.dart';
import 'package:lanefocus/services/firebaseServices/firebase_storage_service.dart';
import 'package:lanefocus/view/widget/common_image_view_widget.dart';
import 'package:lanefocus/view/widget/my_button_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:lanefocus/view/widget/my_textfield_widget.dart';
import 'package:lanefocus/view/widget/simple_app_bar_widget.dart';

class AddCircle extends StatelessWidget {
  AddCircle({super.key});

  GlobalKey<FormState> circleNameForm = GlobalKey();

  @override
  Widget build(BuildContext context) {
    CircleController controller = Get.find();
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
                  text: 'What will call you your circle?',
                  size: 20,
                  paddingBottom: 10,
                ),
                MyText(
                  text:
                  'Note: You can create more circles for every group in your life.',
                  color: kQuaternaryColor,
                  paddingBottom: 30,
                ),
                Column(
                  children: [
                    Obx(() =>
                    controller.imagePath.isEmpty ? CommonImageView(
                      fit: BoxFit.cover,
                      radius: 100,
                      height: 100,
                      width: 105,
                      url: dummyProfile,
                    ) : CommonImageView(
                      file: File(controller.imagePath.value),
                      fit: BoxFit.cover,
                      radius: 100,
                      height: 100,
                      width: 105,

                    ),
                    ),
                    GestureDetector(
                        onTap: () {
                          ImagePickerService.instance
                              .openProfilePickerBottomSheet(
                              context: context, onCameraPick: () async {

                                await controller.pickImage();
                                Get.back();

                          }, onGalleryPick: () async {
                            await controller.pickImage(isThroughCamera: false);
                            Get.back();
                          });
                        },
                        child: MyText(
                          text: "Upload Image",
                          color: kBlueColor,
                          weight: FontWeight.w700,
                        ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                MyTextField(
                  controller: controller.circleNameController,
                  heading: 'Circle Name',
                  hint: 'Jessy Family',
                )
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              buttonText: 'Continue',
              onTap: () {
                controller.createCircle(context: context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
