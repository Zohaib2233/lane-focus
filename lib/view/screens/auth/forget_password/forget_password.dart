import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/controller/auth_controller/auth_controller.dart';
import 'package:lanefocus/core/utils/validators.dart';
import 'package:lanefocus/view/screens/auth/forget_password/otp_verification.dart';
import 'package:lanefocus/view/widget/heading_widget.dart';
import 'package:lanefocus/view/widget/my_button_widget.dart';
import 'package:lanefocus/view/widget/my_textfield_widget.dart';
import 'package:lanefocus/view/widget/simple_app_bar_widget.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Scaffold(
      appBar: simpleAppBar(title: ''),
      body: Form(
        key: authController.forgetPasswordKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: AppSizes.DEFAULT,
                children: [
                  AuthHeading(
                    heading: 'Forgot Password',
                    subTitle:
                        'Enter your email address. We will send you a secure code for verification to your email address.',
                    paddingTop: 0,
                  ),
                  MyTextField(
                    heading: 'Email',
                    hint: 'Andrew.john@yourdomain.com',
                    controller: authController.forgotEmailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v)=> ValidationService.instance.emptyValidator(v),
                  )
                ],
              ),
            ),
            Padding(
              padding: AppSizes.DEFAULT,
              child: MyButton(
                buttonText: 'Continue',
                onTap: (){

                  if(!authController.forgetPasswordKey.currentState!.validate())
                  {
                   return;
                  }
                  authController.forgotPassword(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
