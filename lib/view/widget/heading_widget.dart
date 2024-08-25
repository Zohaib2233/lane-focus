import 'package:flutter/material.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';

class AuthHeading extends StatelessWidget {
  final String heading, subTitle;
  final double? paddingTop, paddingBottom, headingSize;
  const AuthHeading({
    super.key,
    required this.heading,
    required this.subTitle,
    this.paddingTop = 0,
    this.paddingBottom = 30,
    this.headingSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MyText(
          text: heading,
          size: headingSize,
          weight: FontWeight.w600,
          paddingTop: paddingTop,
          paddingBottom: 8,
        ),
        MyText(
          text: subTitle,
          paddingBottom: paddingBottom,
        ),
      ],
    );
  }
}

class Heading extends StatelessWidget {
  final String heading;
  const Heading({
    super.key,
    required this.heading,
  });

  @override
  Widget build(BuildContext context) {
    return MyText(
      text: heading,
      size: 20,
      color: kBlackColor,
      weight: FontWeight.w600,
      paddingBottom: 15,
    );
  }
}
