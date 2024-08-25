import 'package:flutter/material.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_fonts.dart';
import 'package:lanefocus/constants/app_images.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    this.hint,
    this.readOnly = false,
    this.onTap,
    this.controller,
    this.onChanged,
    this.validator,
    this.suffixIcon,
  });

  final String? hint;
  final bool? readOnly;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly!,
      onTap: onTap,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      cursorColor: kTertiaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(
        fontSize: 12,
        color: kTertiaryColor,
        fontWeight: FontWeight.w400,
        fontFamily: AppFonts.SPLINE_SANS,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: kInputColor,
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 12,
          color: kTertiaryColor,
          fontWeight: FontWeight.w400,
          fontFamily: AppFonts.SPLINE_SANS,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 0,
        ),
        prefixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.imagesSearch,
              height: 14,
            ),
          ],
        ),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: kInputBorderColor,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: kSecondaryColor,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
