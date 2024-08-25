import 'dart:developer';

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/controller/auth_controller/auth_controller.dart';

import 'package:lanefocus/core/bindings/bindings.dart';

import 'package:lanefocus/services/local_storage/local_storage_service.dart';
import 'package:lanefocus/view/screens/admin/admin_nav_bar/admin_nav_bar.dart';
import 'package:lanefocus/view/screens/auth/forget_password/forget_password.dart';
import 'package:lanefocus/view/screens/auth/sign_up/sign_up.dart';
import 'package:lanefocus/view/screens/driver/driver_nav_bar/driver_nav_bar.dart';
import 'package:lanefocus/view/widget/custom_check_box_widget.dart';
import 'package:lanefocus/view/widget/heading_widget.dart';
import 'package:lanefocus/view/widget/my_button_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:lanefocus/view/widget/my_textfield_widget.dart';
import 'package:lanefocus/view/widget/simple_app_bar_widget.dart';

import '../../../../core/utils/validators.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Scaffold(
      appBar: simpleAppBar(
        title: '',
        onBack: () {
          authController.clearSignInControllers();
          Get.back();
        },
      ),
      body: Form(
        key: authController.signInFormKey,
        child: Padding(
          padding: AppSizes.DEFAULT,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthHeading(
                  heading: 'Hello there',
                  subTitle:
                      'Please enter your phone number/email and password to sign in.',
                ),
                MyTextField(
                  heading: 'Email',
                  hint: 'Andrew.john@yourdomain.com',
                  controller: authController.loginEmailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      ValidationService.instance.emailValidator(value),
                ),
                Obx(
                  () => MyTextField(
                    heading: 'Password',
                    hint: '**********************',
                    controller: authController.loginPasswordController,
                    validator: (value) =>
                        ValidationService.instance.validatePassword(value),
                    isObSecure: authController.loginIsObSecurePass.value,
                    suffix: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Image.asset(
                            authController.loginIsObSecurePass.value
                                ? Assets.imagesEyeHide
                                : Assets.imagesEye,
                            height: 24,
                          ),
                          onTap: () {
                            authController.loginTogglePassword();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Obx(
                      () => CustomCheckBox(
                        isActive: authController.isRememberMe.value,
                        onTap: () async {
                          if (authController.isRememberMe.isTrue) {
                            await LocalStorageService.instance.write(
                                key: 'email',
                                value: authController.emailController.text
                                    .trim());
                          } else {
                            await LocalStorageService.instance.deleteKey(
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
                Container(
                  height: 0.88,
                  color: kInputBorderColor,
                  margin: EdgeInsets.symmetric(vertical: 20),
                ),
                MyText(
                  text: 'Forgot Password?',
                  color: kSecondaryColor,
                  weight: FontWeight.w700,
                  textAlign: TextAlign.end,
                  onTap: () {
                    Get.to(() => ForgetPassword());
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MyButton(
                        buttonText: 'Sign In',

                        onTap: () async {
                          if (!authController.signInFormKey.currentState!
                              .validate()) {
                            return;
                          }

                          //  await authController.signInLoad();
                          log('sdkkldfjkdf');

                          await authController.signIn(context);

                        },
                      ),
                      SizedBox(height: 16),
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          MyText(
                            text: 'Don\'t have an account? ',
                            size: 12,
                          ),
                          MyText(
                            text: 'Sign Up',
                            size: 12,
                            color: kSecondaryColor,
                            weight: FontWeight.w600,
                            onTap: () {
                              Get.to(() => SignUp());
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: kInputBorderColor,
                        height: 1,
                      ),
                    ),
                    MyText(
                      text: 'or continue with',
                      weight: FontWeight.w500,
                      color: kQuaternaryColor,
                      paddingLeft: 16,
                      paddingRight: 16,
                    ),
                    Expanded(
                      child: Container(
                        color: kInputBorderColor,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                _SocialLogin(
                  onGoogle: () async {
                    await authController.signinwithGoogle(context);
                  },
                  onFacebook: () {},
                  onApple: () {},
                ),

                // Padding(
                //   padding: AppSizes.DEFAULT,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.stretch,
                //     children: [
                //       MyButton(
                //         buttonText: 'Sign In',
                //         onTap: () {
                //           if (authController.currentRole.value == 0) {
                //             Get.offAll(() => DriverNavBar());
                //           } else {
                //             Get.offAll(() => AdminNavBar(),binding: AdminHomeBindings());
                //           }
                //         },
                //       ),
                //       SizedBox(
                //         height: 16,
                //       ),
                //
                //       Wrap(
                //         alignment: WrapAlignment.center,
                //         children: [
                //           MyText(
                //             text: 'Don\'t have an account? ',
                //             size: 12,
                //           ),
                //           MyText(
                //             text: 'Sign Up',
                //             size: 12,
                //             color: kSecondaryColor,
                //             weight: FontWeight.w600,
                //             onTap: () {
                //               Get.to(
                //                 () => SignUp(),
                //               );
                //             },
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialLogin extends StatelessWidget {
  final VoidCallback onGoogle, onApple, onFacebook;
  const _SocialLogin({
    super.key,
    required this.onGoogle,
    required this.onApple,
    required this.onFacebook,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MyBorderButton(
            buttonText: '',
            onTap: onGoogle,
            child: Center(
              child: Image.asset(
                Assets.imagesGoogle,
                height: 21,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
