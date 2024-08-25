import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/controller/auth_controller/auth_controller.dart';
import 'package:lanefocus/core/utils/validators.dart';
import 'package:lanefocus/view/screens/auth/complete_profile/date_of_birth.dart';
import 'package:lanefocus/view/widget/heading_widget.dart';
import 'package:lanefocus/view/widget/my_button_widget.dart';
import 'package:lanefocus/view/widget/my_textfield_widget.dart';
import 'package:lanefocus/view/widget/simple_app_bar_widget.dart';

class Name extends StatelessWidget {
  Name({super.key, this.fromLink, this.cId});
  bool? fromLink;
  String? cId;

  final authController = Get.find<AuthController>();
  final _nameKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(title: ''),
      body: Form(
        key: _nameKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: AppSizes.DEFAULT,
                children: [
                  AuthHeading(
                    heading: 'Let’s get to know you!',
                    subTitle: 'Please start by telling us your name',
                    headingSize: 20,
                  ),
                  MyTextField(
                    heading: 'First Name',
                    hint: 'Andrew',
                    controller: authController.fName,
                    validator: (value) {
                      return ValidationService.instance.emptyValidator(value);
                    },
                  ),
                  MyTextField(
                    heading: 'Last Name',
                    hint: 'John',
                    controller: authController.lName,
                    validator: (value) {
                      return ValidationService.instance.emptyValidator(value);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: AppSizes.DEFAULT,
              child: MyButton(
                buttonText: 'Continue',
                onTap: () {
                  if (_nameKey.currentState!.validate()) {
                    Get.to(() => DateOfBirth(fromLink: fromLink,cId: cId,));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
