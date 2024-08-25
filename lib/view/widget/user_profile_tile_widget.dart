import 'package:flutter/material.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/main.dart';
import 'package:lanefocus/view/widget/common_image_view_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';

class UserProfileTile extends StatelessWidget {
  final String image, name, location, time;
  final VoidCallback onTap;
  final Widget? icon;
  const UserProfileTile({
    super.key,
    required this.image,
    required this.name,
    required this.location,
    required this.time,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonImageView(
              url: image,
              height: 60,
              width: 60,
              radius: 100,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MyText(
                              text: name,
                              weight: FontWeight.w500,
                            ),
                            MyText(
                              text: location,
                              size: 11,
                            ),
                            MyText(
                              text: time,
                              size: 11,
                            ),
                          ],
                        ),
                      ),
                      icon ??
                          Image.asset(
                            Assets.imagesArrowRight,
                            height: 24,
                          ),
                    ],
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  Container(
                    height: 1,
                    color: kInputBorderColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
