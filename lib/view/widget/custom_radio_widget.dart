import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';

class CustomRadio extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool value;
  const CustomRadio({
    super.key,
    required this.text,
    required this.onTap,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Wrap(
        spacing: 18,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: kInputBorderColor,
            child: value
                ? AnimatedContainer(
                    height: Get.height,
                    width: Get.width,
                    margin: EdgeInsets.all(2),
                    duration: Duration(
                      microseconds: 280,
                    ),
                    decoration: BoxDecoration(
                      color: kSecondaryColor,
                      shape: BoxShape.circle,
                    ),
                  )
                : SizedBox(),
          ),
          MyText(
            text: text,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
