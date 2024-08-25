import 'package:flutter/material.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  MyButton({
    required this.buttonText,
    required this.onTap,
    this.height = 48,
    this.textSize = 16,
    this.radius = 50,
    this.bgColor = kSecondaryColor,
    this.textColor = kPrimaryColor,
    this.weight = FontWeight.w600,
    this.customChild,
    this.haveShadow = true,
  });

  final String buttonText;
  final VoidCallback onTap;
  final double? height, textSize, radius;
  final FontWeight? weight;
  final Widget? customChild;
  final Color? bgColor, textColor;
  final bool? haveShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius!),
        border: Border.all(
          width: 1.0,
          color: kPrimaryColor.withOpacity(0.2),
        ),
        boxShadow: haveShadow!
            ? [
                BoxShadow(
                  color: kSecondaryColor.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: kBlackColor.withOpacity(0.1),
          highlightColor: kBlackColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(radius!),
          child: customChild ??
              Center(
                child: MyText(
                  text: buttonText,
                  size: textSize,
                  weight: weight,
                  color: textColor,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyBorderButton extends StatelessWidget {
  MyBorderButton({
    required this.buttonText,
    required this.onTap,
    this.height = 48,
    this.textSize = 16,
    this.radius = 50,
    this.bgColor = Colors.transparent,
    this.textColor = kTertiaryColor,
    this.weight = FontWeight.w600,
    this.child,
    this.borderColor = kInputBorderColor,
    this.borderWidth = 1.0,
    this.splashColor,
  });

  final String buttonText;
  final VoidCallback onTap;
  double? height, textSize, radius, borderWidth;
  FontWeight? weight;
  Widget? child;
  Color? textColor, bgColor, borderColor, splashColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius!),
        color: bgColor ?? Colors.transparent,
        border: Border.all(
          color: borderColor!,
          width: borderWidth!,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: splashColor ?? kSecondaryColor.withOpacity(0.1),
          highlightColor: splashColor ?? kSecondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(radius!),
          child: child ??
              Center(
                child: MyText(
                  text: buttonText,
                  size: textSize,
                  weight: weight,
                  color: textColor,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyRippleEffect extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  Color? splashColor;
  double? radius;
  MyRippleEffect({
    super.key,
    required this.child,
    required this.onTap,
    this.splashColor,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: splashColor ?? kSecondaryColor.withOpacity(0.1),
        highlightColor: splashColor ?? kSecondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(radius ?? 0),
        child: child,
      ),
    );
  }
}
