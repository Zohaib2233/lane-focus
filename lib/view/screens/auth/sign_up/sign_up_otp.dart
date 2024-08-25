import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/constants/app_styling.dart';
import 'package:lanefocus/core/constants/instance_constants.dart';
import 'package:lanefocus/core/utils/snackbar.dart';
import 'package:lanefocus/utils/global_instances.dart';
import 'package:lanefocus/view/screens/auth/complete_profile/name.dart';
import 'package:lanefocus/view/widget/congrats_dialog_widget.dart';
import 'package:lanefocus/view/widget/heading_widget.dart';
import 'package:lanefocus/view/widget/my_button_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:lanefocus/view/widget/simple_app_bar_widget.dart';
import 'package:pinput/pinput.dart';

class SignUpOtp extends StatefulWidget {
  SignUpOtp({super.key, this.fromLink, this.cId, this.isCodeCorrect});
  bool? fromLink, isCodeCorrect;
  String? cId;

  @override
  State<SignUpOtp> createState() => _SignUpOtpState();
}

class _SignUpOtpState extends State<SignUpOtp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: '',
        onBack: () {
          generalController.isTimerCompleted.value = false;
        },
      ),
      body: WillPopScope(
        onWillPop: () {
          generalController.isTimerCompleted.value = false;
          return Future.value(true);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: AppSizes.DEFAULT,
                children: [
                  AuthHeading(

                    heading: 'Verification Otp',
                    subTitle:
                        'We have sent a secure code for verification to your phone number. Check your number and enter the code below.',
                  ),
                  Pinput(
                    defaultPinTheme: AppStyling.defaultPinTheme,
                    focusedPinTheme: AppStyling.focusPinTheme,
                    length: 6,
                    mainAxisAlignment: MainAxisAlignment.center,
                    autofocus: true,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onCompleted: (v) {},
                    controller: authController.otpController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        text: 'Didn\'t receive otp?',
                        size: 15,
                        weight: FontWeight.w500,
                        textAlign: TextAlign.center,
                        paddingBottom: 12,
                        paddingTop: 32,
                      ),
                      Obx(
                        () => TextButton(
                          onPressed: generalController.isTimerCompleted.value
                              ? () async {
                                  //Re send OTP
                                  await _onResendOtp();
                                }
                              : () {},
                          child: MyText(
                            text: 'Resend',
                            color: generalController.isTimerCompleted.value
                                ? kSecondaryColor
                                : kHintColor,
                            paddingBottom: 12,
                            paddingTop: 32,
                          ),
                        ),
                      )
                    ],
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      MyText(
                        text: 'You can resend code in ',
                        size: 15,
                        weight: FontWeight.w500,
                      ),
                      Obx(
                        () => MyText(
                          text:
                              '00:${generalController.secondsRemaining.value.toString()}',
                          size: 15,
                          color: kSecondaryColor,
                          weight: FontWeight.w500,
                        ),
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
                onTap: () async {
                  await _onContinue();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onContinue() async {
// <<<<<<< HEAD
//     await authController.signUp(
//         context, widget.cId ?? '', widget.isCodeCorrect ?? false);
//     await authController.verifyOtpAndSignin(
//         authController.verificationId.value, authController.otpController.text);
//     if (authController.isAuth.value) {
//       Get.dialog(
//         CongratsDialog(
//           heading: 'Verification Successful!',
//           congratsText: 'Your account has been successfully verified.',
//           btnText: 'Continue',
//           onTap: () {
//             Get.to(() => Name(fromLink: widget.fromLink));
//           },
//         ),
//       );
// =======
    if (authController.otpController.text.isNotEmpty &&
        authController.otpController.text.length == 6) {
      await authController.verifyOtpAndSignin(
          context,
          authController.verificationId.value,
          authController.otpController.text);
      if (authController.isAuth.value) {
        Get.dialog(
          CongratsDialog(
            heading: 'Verification Successful!',
            congratsText: 'Your account has been successfully verified.',
            btnText: 'Continue',
            onTap: () {
              Get.to(() => Name(fromLink: widget.fromLink,cId: widget.cId,));
            },
          ),
        );
      }
    } else {
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Enter OTP', message: 'OTP field is required');

    }
  }

  Future<void> _onResendOtp() async {
    await authController.sendCodeToPhoneNumber(
      onFailed: (){

      },
        onSuccess: () {
          CustomSnackBars.instance.showSuccessSnackbar(
              title: 'Sent', message: 'OTP Sent Successfull');
          generalController.startTimer();
        },
        phoneNumber: authController.phoneNumberController.text,
        dialCode: generalController.phoneNumberDialCode.value);
  }
}
