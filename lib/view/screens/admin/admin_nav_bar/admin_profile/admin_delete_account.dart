import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';

import 'package:lanefocus/constants/app_sizes.dart';

import 'package:lanefocus/controller/profile_controller/profile_controller.dart';

import 'package:lanefocus/view/widget/my_button_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:lanefocus/view/widget/my_textfield_widget.dart';
import 'package:lanefocus/view/widget/password_dialog.dart';
import 'package:lanefocus/view/widget/simple_app_bar_widget.dart';

class AdminDeleteAccount extends StatelessWidget {
   AdminDeleteAccount({super.key});
ProfileController profileController = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Account',
      ),
      body: ListView(
        padding: AppSizes.DEFAULT,
        children: [
          MyText(
            text:
                'Please state your reason for leaving us. Your Feedback help us to improve ourselves.',
            weight: FontWeight.w500,
            paddingBottom: 10,
          ),
          CustomTextField(
            hintText: 'Write your message',
            maxLength: 150,
            maxLines: 8,
            marginBottom: 30,
          ),
          MyText(
            text: 'Are you sure you want to Delete you account?',
            size: 16,
            weight: FontWeight.w500,
            textAlign: TextAlign.center,
            paddingBottom: 15,
          ),
          MyText(
            text:
                'If you delete your account you will not be able to retrieve your data again.',
            size: 12,
            color: kQuaternaryColor,
            textAlign: TextAlign.center,
            paddingBottom: 40,
          ),
          Row(
            children: [
              Expanded(
                child: MyButton(
                  height: 50,
                  radius: 50,
                  haveShadow: false,
                  bgColor: kInputColor,
                  textColor: kQuaternaryColor,
                  weight: FontWeight.w500,
                  buttonText: 'Cancel',
                  onTap: () {
                    Get.back();
                  },
                ),
              ),
              SizedBox(
                width: 40,
              ),
              Expanded(
                child: MyButton(
                  height: 50,
                  radius: 50,
                  haveShadow: false,
                  textColor: kPrimaryColor,
                  bgColor: kRedColor,
                  weight: FontWeight.w500,
                  buttonText: 'Delete',
                  onTap: () async{
                   Get.dialog(PasswordDialog(onConfirm: (p){

                   }));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
