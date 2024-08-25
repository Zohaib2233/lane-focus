import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_fonts.dart';
import 'package:lanefocus/controller/auth_controller/auth_controller.dart';
import 'package:lanefocus/controller/general_controller.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';

class MyIntlPhoneFieldWidget extends StatelessWidget {
  TextEditingController? controller = TextEditingController();
  final void Function(String?)? onSubmitted;
  final GlobalKey<FormState> formKey;
  MyIntlPhoneFieldWidget({
    super.key,
    required this.formKey,
    this.controller,
    this.onSubmitted,
  });
  AuthController authController = Get.find<AuthController>();
  GeneralController _generalController = Get.find<GeneralController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: 'Phone Number',
          size: 12,
          color: kBlackColor,
          weight: FontWeight.w700,
        ),
        Container(
          height: 60,
          //color: Colors.amber,
          child: Center(
            child: IntlPhoneField(
              onSubmitted: onSubmitted,
              controller: controller,
              cursorColor: kSecondaryColor,
              enabled: true,
              keyboardType: TextInputType.phone,
              autovalidateMode: AutovalidateMode.disabled,
              style: TextStyle(
                fontSize: 14,
                color: kTertiaryColor,
                fontWeight: FontWeight.w400,
                fontFamily: AppFonts.SPLINE_SANS,
              ),
              showCountryFlag: false,
              flagsButtonPadding: EdgeInsets.symmetric(horizontal: 5),
              flagsButtonMargin:
                  EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 30),
              showDropdownIcon: true,
              dropdownIcon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: kPrimaryColor,
                size: 15,
              ),
              pickerDialogStyle: PickerDialogStyle(
                backgroundColor: kPrimaryColor,
              ),
              dropdownTextStyle: TextStyle(
                  fontSize: 12,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w500),
              dropdownIconPosition: IconPosition.trailing,
              dropdownDecoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(24),
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: kPrimaryColor,
                hintText: '+01xxxxxxxxxxxxxx',
                alignLabelWithHint: true,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: kHintColor,
                  fontWeight: FontWeight.w400,
                  fontFamily: AppFonts.SPLINE_SANS,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.0,
                    color: kSecondaryColor,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.0,
                    color: kSecondaryColor,
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.0,
                    color: Colors.red,
                  ),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.0,
                    color: Colors.red,
                  ),
                ),
              ),
              onCountryChanged: (country) {
                _generalController.phoneNumberDialCode.value =
                    '+${country.dialCode}';
              },
              
              validator: (phone) async {
                if (controller!.text.isEmpty) {
                  return 'Please enter a phone number';
                }
                if (!phone!.isValidNumber()) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
