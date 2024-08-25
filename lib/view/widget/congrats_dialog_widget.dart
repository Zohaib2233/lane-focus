import 'package:flutter/material.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/view/widget/my_button_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';

class CongratsDialog extends StatelessWidget {
  final String heading, congratsText, btnText;
  final VoidCallback onTap;
  const CongratsDialog({
    super.key,
    required this.heading,
    required this.congratsText,
    required this.btnText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 40,
          ),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset(
                  Assets.imagesCongrats,
                  height: 152,
                ),
              ),
              MyText(
                text: heading,
                size: 20,
                color: kSecondaryColor,
                weight: FontWeight.w700,
                textAlign: TextAlign.center,
                paddingTop: 20,
                paddingBottom: 12,
              ),
              MyText(
                text: congratsText,
                size: 13,
                color: kQuaternaryColor,
                textAlign: TextAlign.center,
                paddingBottom: 20,
              ),
              MyButton(
                buttonText: btnText,
                onTap: onTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
