import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';

import 'my_text_widget.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  const ImagePickerBottomSheet({
    Key? key,
    required this.onCameraPick,
    required this.onGalleryPick,
  }) : super(key: key);

  final VoidCallback onCameraPick;
  final VoidCallback onGalleryPick;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 215,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Icon(
                    Icons.remove,
                    color: Colors.black,
                  ),
                ),
                MyText(
                  paddingLeft: 15,
                  paddingTop: 20,
                  paddingBottom: 10,
                  text: 'upload_from'.tr,
                  size: 16,
                  color: kSecondaryColor,
                  weight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: onCameraPick,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.camera,
                          color: kBlackColor,
                        ),
                        MyText(
                          paddingTop: 10,
                          text: 'Camera',
                          color: kBlackColor,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: kSecondaryColor,
                    width: 1.0,
                  ),
                  GestureDetector(
                    onTap: onGalleryPick,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.photo_fill_on_rectangle_fill,
                          color: kBlackColor,
                        ),
                        MyText(
                          paddingTop: 10,
                          text: 'Gallery',
                          color: kBlackColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}
