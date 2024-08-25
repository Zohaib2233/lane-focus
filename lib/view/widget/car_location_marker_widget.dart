import 'package:flutter/material.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/main.dart';
import 'package:lanefocus/view/widget/common_image_view_widget.dart';

class CarLocationMarker extends StatelessWidget {
  final String image;
  const CarLocationMarker({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Image.asset(
          Assets.imagesCar,
          height: 60,
        ),
        Positioned(
          top: -30,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                Assets.imagesEmptyLocationMarker,
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CommonImageView(
                  url: dummyImg,
                  height: 36,
                  width: 36,
                  radius: 100,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
