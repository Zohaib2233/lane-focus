import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    required this.child,
    this.height,
    this.radius = 8,
  });

  final Widget child;
  final double? height, radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? Get.height * 0.5,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(radius!),
        ),
      ),
      child: child,
    );
  }
}
