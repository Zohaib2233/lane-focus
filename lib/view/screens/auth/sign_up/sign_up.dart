import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/controller/auth_controller/auth_controller.dart';

import 'package:lanefocus/core/utils/snackbar.dart';
import 'package:lanefocus/model/user/invite_model.dart';
import 'package:lanefocus/services/firebaseServices/firebase_crud_services.dart';
import 'package:lanefocus/services/local_storage/local_storage_service.dart';
import 'package:lanefocus/utils/global_instances.dart';
import 'package:lanefocus/view/screens/auth/sign_up/sign_up_otp.dart';
import 'package:lanefocus/view/widget/custom_check_box_widget.dart';
import 'package:lanefocus/view/widget/heading_widget.dart';
import 'package:lanefocus/view/widget/my_button_widget.dart';
import 'package:lanefocus/view/widget/my_intl_phone_field_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:lanefocus/view/widget/my_textfield_widget.dart';
import 'package:lanefocus/view/widget/simple_app_bar_widget.dart';

import '../../../../core/utils/validators.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key, this.fromLink, this.cId});

  bool? fromLink;
  String? cId;

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: simpleAppBar(
              title: '',
              onBack: () {
                authController.clearSignUpControllers();
                Get.back();
              }),
          body: Form(
            key: authController.signUpFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    padding: AppSizes.DEFAULT,
                    children: [
                      GestureDetector(
                        onTap: (){
                          print("From link signup $fromLink fromLink??false == false ${fromLink??false == false}");
                        },
                        child: AuthHeading(
                          heading: 'Hello there',
                          subTitle:
                          'Please enter your phone number/email and password to sign in.',
                        ),
                      ),
                      MyTextField(
                        controller: authController.emailController,
                        heading: 'Email',
                        hint: 'abc@',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            ValidationService.instance.emailValidator(value),
                      ),
                      MyIntlPhoneFieldWidget(
                        controller: authController.phoneNumberController,
                        formKey: authController.signUpFormKey,
                      ),
                      Obx(
                            () =>
                            MyTextField(
                              controller: authController.passwordController,
                              heading: 'Password',
                              hint: '**********************',
                              isObSecure: authController.isObSecurePass.value,
                              validator: (value) =>
                                  ValidationService.instance.validatePassword(
                                      value),
                              suffix: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    child: Image.asset(
                                      authController.isObSecurePass.value ==
                                          true
                                          ? Assets.imagesEyeHide
                                          : Assets.imagesEye,
                                      height: 24,
                                    ),
                                    onTap: () {
                                      authController.togglePassword();
                                    },
                                  ),
                                ],
                              ),
                            ),
                      ),
                      Obx(
                            () =>
                            MyTextField(
                              controller: authController
                                  .repeatPasswordController,
                              heading: 'Repeat Password',
                              hint: '**********************',
                              validator: (value) =>
                                  ValidationService.instance
                                      .validateMatchPassword(
                                      value!,
                                      authController.passwordController.text),
                              isObSecure: authController.isObSecureRepeatPass
                                  .value,
                              suffix: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    child: Image.asset(
                                      authController.isObSecureRepeatPass
                                          .value == true
                                          ? Assets.imagesEyeHide
                                          : Assets.imagesEye,
                                      height: 24,
                                    ),
                                    onTap: () {
                                      authController.toggleRepeatPassword();
                                    },
                                  ),
                                ],
                              ),
                            ),
                      ),
                      if(!(fromLink??false))
                        MyTextField(
                        controller: authController.codeController,
                        heading: 'Code',
                        hint: '123456',
                        keyboardType: TextInputType.text,
                      ),
                      Row(
                        children: [
                          Obx(
                                () =>
                                CustomCheckBox(
                                  isActive: authController.isRememberMe.value,
                                  onTap: () async {
                                    if (authController.isRememberMe.isTrue) {
                                      await LocalStorageService.instance.write(
                                          key: 'email',
                                          value: authController.emailController
                                              .text
                                              .trim());
                                    } else {
                                      await LocalStorageService.instance
                                          .deleteKey(
                                        key: 'email',
                                      );
                                    }

                                    authController.isRememberMe.value =
                                    !authController.isRememberMe.value;
                                  },
                                ),
                          ),
                          Expanded(
                            child: MyText(
                              text: 'Remember me',
                              weight: FontWeight.w600,
                              paddingLeft: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: kInputBorderColor,
                              height: 1,
                            ),
                          ),
                          // MyText(
                          //   text: 'or continue with',
                          //   weight: FontWeight.w500,
                          //   color: kQuaternaryColor,
                          //   paddingLeft: 16,
                          //   paddingRight: 16,
                          // ),
                          Expanded(
                            child: Container(
                              color: kInputBorderColor,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 22,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: AppSizes.DEFAULT,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Obx(
                            () =>
                        authController.isLoading.value
                            ? Center(
                          child: CircularProgressIndicator(
                            color: kSecondaryColor,
                          ),
                        )
                            : MyButton(
                          buttonText: 'Sign Up',
                          onTap: () async {
                            await authController.onSignup(
                                fromLink: fromLink ?? false || authController.codeController.text.isNotEmpty,
                                cId: cId ?? '',
                                context: context);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Wrap(alignment: WrapAlignment.center, children: [
                        MyText(
                          text: 'Already have an account? ',
                          size: 12,
                        ),
                        MyText(
                          text: 'Sign In',
                          size: 12,
                          color: kSecondaryColor,
                          weight: FontWeight.w600,
                          onTap: () {
                            Get.back();
                          },
                        ),
                      ]),
                    ],
                  ),

                  // SizedBox(
                  //   height: 24,
                  // ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Container(
                  //         color: kInputBorderColor,
                  //         height: 1,
                  //       ),
                  //     ),
                  //     MyText(
                  //       text: 'or continue with',
                  //       weight: FontWeight.w500,
                  //       color: kQuaternaryColor,
                  //       paddingLeft: 16,
                  //       paddingRight: 16,
                  //     ),
                  //     Expanded(
                  //       child: Container(
                  //         color: kInputBorderColor,
                  //         height: 1,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 22,
                  // ),
                  // _SocialLogin(
                  //   onGoogle: () async {
                  //     await authController.signinwithGoogle(context);
                  //   },
                  //   onFacebook: () {},
                  //   onApple: () {},
                  // ),
                ),
              ],
            ),
          ),
        ),

        ///Todo: Add this loader if needed
        // Obx(() =>
        // authController.signupLoading.isTrue ? Container(
        //   color: Colors.grey.withOpacity(0.8)
        //
        //   ,height: Get.height,
        //   width: Get.width,
        //   child: Center(child: CircularProgressIndicator(),),):Container())
      ],
    );
  }

  // Future<void> _onSignup(bool fromLink) async {
  //   if (authController.signUpFormKey.currentState!.validate() &&
  //       authController.phoneNumberController.text.isNotEmpty) {
  //     await authController.sendCodeToPhoneNumber(
  //         onSuccess: () {
  //           generalController.startTimer();
  //           Get.to(() => SignUpOtp(fromLink: fromLink));
  //         },
  //         phoneNumber: authController.phoneNumberController.text,
  //         dialCode: generalController.phoneNumberDialCode.value);
  //     Get.to(() => SignUpOtp(fromLink: fromLink));
  //   } else if (authController.phoneNumberController.text.isEmpty) {
  //     CustomSnackBars.instance.showFailureSnackbar(
  //         title: 'Phone Number', message: 'Enter a phone number');
  //   } else {
  //     CustomSnackBars.instance.showFailureSnackbar(
  //         title: 'Error', message: 'Please fill required fields first');
  //   }
  // }
}
