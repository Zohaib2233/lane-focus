import 'package:flutter/material.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/view/widget/common_image_view_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';

class ChatHeadTile extends StatelessWidget {
  const ChatHeadTile({
    super.key,
    required this.image,
    required this.name,
    required this.lastMessage,
    required this.onTap,
  });
  final String image;
  final String name;
  final String lastMessage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryColor,
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: kGreyColor,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: kTertiaryColor.withOpacity(0.1),
          highlightColor: kTertiaryColor.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            child: Row(
              children: [
                CommonImageView(
                  height: 52,
                  width: 52,
                  radius: 100,
                  url: image,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        text: name,
                        size: 16,
                        paddingBottom: 2,
                      ),
                      MyText(
                        text: lastMessage,
                        size: 12,
                        weight: FontWeight.w300,
                        color: kQuaternaryColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
