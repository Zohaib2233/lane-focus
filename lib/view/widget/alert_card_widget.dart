import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/view/widget/common_image_view_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';

class AlertCard extends StatelessWidget {
  final String title, alertText, time, image;
  final VoidCallback onRemove;
  const AlertCard({
    required this.title,
    required this.alertText,
    required this.time,
    required this.onRemove,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 15,
      ),
      padding: EdgeInsets.symmetric(horizontal: 6.5, vertical: 8),
      decoration: BoxDecoration(
        color: kInputColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1.0,
          color: kInputBorderColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonImageView(
         //   url: image,
            imagePath: image,
            height: 42,
            width: 42,
            radius: 6,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: MyText(
                        text: title,
                        size: 12,
                        weight: FontWeight.w500,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                    MyText(
                      text: time,
                      size: 10,
                      color: kQuaternaryColor,
                    ),
                  ],
                ),
                MyText(
                  text: alertText,
                  size: 10,
                  color: kQuaternaryColor,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                  paddingTop: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
