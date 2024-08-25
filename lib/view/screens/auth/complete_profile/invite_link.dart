import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/view/screens/auth/complete_profile/setting_up_profile.dart';
import 'package:lanefocus/view/widget/my_button_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:lanefocus/view/widget/my_textfield_widget.dart';
import 'package:lanefocus/view/widget/simple_app_bar_widget.dart';

class InviteLink extends StatelessWidget {
  const InviteLink({super.key});

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
                  text: 'Please add your circle link over here below to join!',
                  size: 20,
                  weight: FontWeight.w600,
                  paddingBottom: 16,
                ),
                MyTextField(
                  heading: 'Invite link',
                  hint: 'Link',
                  suffix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Assets.imagesCopy,
                        height: 20,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              buttonText: 'Continue',
              onTap: () {
                Get.to(() => SettingUpProfile());
              },
            ),
          ),
        ],
      ),
    );
  }
}
