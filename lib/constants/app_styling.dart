import 'package:flutter/material.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_fonts.dart';
import 'package:pinput/pinput.dart';

class AppStyling {
  static final cardDecoration = BoxDecoration(
    color: kInputColor,
    borderRadius: BorderRadius.circular(4),
    border: Border.all(
      width: 1.0,
      color: kSecondaryColor,
    ),
  );

  static final customShadow = BoxShadow(
    color: kBlackColor.withOpacity(0.25),
    blurRadius: 10,
    offset: Offset(0, 2),
  );

  static final defaultPinTheme = PinTheme(
    height: 60,
    width: 72,
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    textStyle: TextStyle(
      fontSize: 20,
      color: kTertiaryColor,
      fontWeight: FontWeight.w400,
      fontFamily: AppFonts.SPLINE_SANS,
    ),
    decoration: BoxDecoration(
      color: kInputColor,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        width: 0.88,
        color: kInputBorderColor,
      ),
    ),
  );
  static final focusPinTheme = PinTheme(
    height: 60,
    width: 72,
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    textStyle: TextStyle(
      fontSize: 20,
      color: kSecondaryColor,
      fontWeight: FontWeight.w400,
      fontFamily: AppFonts.SPLINE_SANS,
    ),
    decoration: BoxDecoration(
      color: kSecondaryColor.withOpacity(0.05),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        width: 0.88,
        color: kSecondaryColor,
      ),
    ),
  );
}
