import 'package:flutter/material.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/view/widget/my_button_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';

class ProfileTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const ProfileTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: kInputColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: MyRippleEffect(
        onTap: onTap,
        splashColor: kTertiaryColor.withOpacity(0.1),
        radius: 8,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: MyText(
                  text: title,
                  weight: FontWeight.w500,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
              Image.asset(
                Assets.imagesArrowIosRightBg,
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
