import 'package:flutter/material.dart';
import 'package:lanefocus/constants/app_fonts.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';

import '../../constants/app_colors.dart';

// ignore: must_be_immutable
class MyTextField extends StatelessWidget {
  MyTextField({
    Key? key,
    this.controller,
    this.keyboardType,
    this.marginBottom = 20,
    this.isObSecure = false,
    this.maxLength,
    this.maxLines = 1,
    this.isEnabled = true,
    this.suffix,
    this.validator,
    this.onTap,
    this.onChanged,
    this.prefix,
    this.readOnly = false,
    this.hint,
    this.textInputAction = TextInputAction.next,
    this.heading,
  }) : super(key: key);
  String? hint, heading;
  double? marginBottom;
  bool? isObSecure, isEnabled, readOnly;
  int? maxLength, maxLines;
  Widget? prefix, suffix;
  TextInputType? keyboardType;
  TextEditingController? controller;
  FormFieldValidator<String>? validator;
  ValueChanged<String>? onChanged;
  VoidCallback? onTap;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: marginBottom!,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          heading != null
              ? MyText(
                  text: heading!,
                  size: 12,
                  color: kBlackColor,
                  weight: FontWeight.w700,
                )
              : SizedBox(),
          TextFormField(
            cursorColor: kSecondaryColor,
            onTap: onTap,
            enabled: isEnabled,
            validator: validator,
            maxLines: maxLines,
            maxLength: maxLength,
            onChanged: onChanged,
            obscureText: isObSecure!,
            obscuringCharacter: '*',
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            readOnly: readOnly!,
            textInputAction: textInputAction,
            textAlignVertical: suffix != null ? TextAlignVertical.center : null,
            keyboardType: keyboardType,
            style: TextStyle(
              fontSize: 14,
              color: kTertiaryColor,
              fontWeight: FontWeight.w400,
              fontFamily: AppFonts.SPLINE_SANS,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: kPrimaryColor,
              hintText: hint,
              prefixIcon: prefix,
              suffixIcon: suffix,
              hintStyle: TextStyle(
                fontSize: 14,
                color: kHintColor,
                fontWeight: FontWeight.w400,
                fontFamily: AppFonts.SPLINE_SANS,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 0,
                vertical: maxLines! > 1 ? 16 : 0,
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
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  CustomTextField({
    Key? key,
    this.controller,
    this.validator,
    this.onTap,
    this.onChanged,
    this.filledColor = kInputColor,
    this.radius = 10,
    required this.hintText,
    this.marginBottom = 15,
    this.maxLines = 1,
    this.maxLength,
  }) : super(key: key);

  TextEditingController? controller;
  FormFieldValidator<String>? validator;
  ValueChanged<String>? onChanged;

  final int? maxLines, maxLength;

  final Color? filledColor;
  final double? radius, marginBottom;
  final String hintText;

  VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom!),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius!),
        child: TextFormField(
          cursorColor: kTertiaryColor,
          onTap: onTap,
          validator: validator,
          onChanged: onChanged,
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          onTapOutside: (_) {
            FocusScope.of(context).unfocus();
          },
          style: TextStyle(
            fontSize: 12,
            color: kTertiaryColor,
            fontWeight: FontWeight.w400,
            fontFamily: AppFonts.SPLINE_SANS,
          ),
          decoration: InputDecoration(
            fillColor: filledColor,
            filled: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: maxLines! > 1 ? 15 : 0,
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: kQuaternaryColor,
              fontFamily: AppFonts.SPLINE_SANS,
            ),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
