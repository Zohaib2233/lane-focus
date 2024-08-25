import 'package:flutter/material.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_images.dart';

// ignore: must_be_immutable
class CustomCheckBox extends StatelessWidget {
  CustomCheckBox({
    Key? key,
    required this.isActive,
    required this.onTap,
    this.radius = 6,
    this.size = 20,
    this.iconSize = 7.6,
    this.activeColor = kSecondaryColor,
    this.iconColor = kPrimaryColor,
  }) : super(key: key);

  final bool isActive;
  final VoidCallback onTap;
  final double? radius, size, iconSize;
  final Color? activeColor, iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(
          milliseconds: 280,
        ),
        curve: Curves.easeInOut,
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: isActive ? activeColor : kInputColor,
          borderRadius: BorderRadius.circular(radius!),
          border: isActive
              ? null
              : Border.all(
                  color: kSecondaryColor,
                  width: 1.0,
                ),
        ),
        child: Center(
          child: Image.asset(
            Assets.imagesCheckIcon,
            height: iconSize,
          ),
        ),
      ),
    );
  }
}
