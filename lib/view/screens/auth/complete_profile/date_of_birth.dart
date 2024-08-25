import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_fonts.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/controller/auth_controller/auth_controller.dart';
import 'package:lanefocus/core/bindings/bindings.dart';
import 'package:lanefocus/view/screens/auth/complete_profile/add_photo.dart';
import 'package:lanefocus/view/widget/heading_widget.dart';
import 'package:lanefocus/view/widget/my_button_widget.dart';
import 'package:lanefocus/view/widget/simple_app_bar_widget.dart';

class DateOfBirth extends StatelessWidget {
  DateOfBirth({super.key, this.fromLink, this.cId});
  bool? fromLink;
  String? cId;

  final authController = Get.find<AuthController>();

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
                  heading: 'Your Birthday Date',
                  subTitle: 'Tell us your birthday. ',
                  headingSize: 20,
                  paddingBottom: 42,
                ),
                DatePickerWidget(
                  looping: false, // default is not looping
                  firstDate: DateTime(1900, 01, 01),
                  lastDate: DateTime(2030, 1, 1),
                  initialDate: DateTime(1991, 10, 12),
                  dateFormat: "dd-MMM-yyyy",
                  locale: DatePicker.localeFromString('en'),
                  onChange: (DateTime newDate, _) {
                    authController.dob = newDate;
                  },

                  pickerTheme: DateTimePickerTheme(
                    pickerHeight: 160,
                    itemHeight: 48,
                    itemTextStyle: TextStyle(
                      fontSize: 16,
                      color: kSecondaryColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFonts.SPLINE_SANS,
                    ),
                    dividerColor: kSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              buttonText: 'Continue',
              onTap: () {
                Get.to(() => AddPhoto(fromLink: fromLink,cId: cId,));

              },
            ),
          ),
        ],
      ),
    );
  }
}
