import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_fonts.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';

AppBar simpleAppBar({
  required String title,
  List<Widget>? actions,
  VoidCallback ?onBack,
}) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    leading: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          splashColor: kSecondaryColor.withOpacity(0.1),
          highlightColor: kSecondaryColor.withOpacity(0.1),
          onPressed: onBack ?? ()=> Get.back(),
          icon: Image.asset(
            Assets.imagesBack,
            height: 24,
          ),
        ),
      ],
    ),
    title: MyText(
      text: '$title',
      size: 18,
      weight: FontWeight.w600,
      fontFamily: AppFonts.SPLINE_SANS,
      maxLines: 1,
      textOverflow: TextOverflow.ellipsis,
    ),
    actions: actions,
  );
}
