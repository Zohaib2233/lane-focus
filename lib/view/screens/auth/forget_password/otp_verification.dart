import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/constants/app_styling.dart';
import 'package:lanefocus/view/screens/auth/forget_password/create_new_password.dart';
import 'package:lanefocus/view/widget/heading_widget.dart';
import 'package:lanefocus/view/widget/my_button_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:lanefocus/view/widget/simple_app_bar_widget.dart';
import 'package:pinput/pinput.dart';

class OtpVerification extends StatelessWidget {
  const OtpVerification({super.key});

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
                  heading: 'You’ve Got Mail',
                  subTitle:
                      'We have sent a secure code for verification to your email address. Check your email and enter the code below.',
                  paddingTop: 0,
                ),
                Pinput(
                  defaultPinTheme: AppStyling.defaultPinTheme,
                  focusedPinTheme: AppStyling.focusPinTheme,
                  length: 4,
                  mainAxisAlignment: MainAxisAlignment.center,
                  autofocus: true,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  onCompleted: (v) {},
                ),
                MyText(
                  text: 'Didn\'t receive email?',
                  size: 15,
                  weight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  paddingBottom: 12,
                  paddingTop: 32,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    MyText(
                      text: 'You can resend code in ',
                      size: 15,
                      weight: FontWeight.w500,
                    ),
                    MyText(
                      text: '55 s',
                      size: 15,
                      color: kSecondaryColor,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              buttonText: 'Confirm',
              onTap: () {
                Get.to(() => CreateNewPassword());
              },
            ),
          ),
        ],
      ),
    );
  }
}
