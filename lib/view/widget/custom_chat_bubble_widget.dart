import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/core/constants/instance_constants.dart';
import 'package:lanefocus/view/widget/common_image_view_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';

// ignore: must_be_immutable
class CustomChatBubbles extends StatelessWidget {
  CustomChatBubbles({
    Key? key,
    required this.msg,
    required this.time,
    required this.profileImage,
    required this.isMe,
  }) : super(key: key);

  final String msg;
  final bool isMe;
  final String time, profileImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 56),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            CommonImageView(
              height: 36,
              width: 36,
              url: profileImage,
              radius: 100,
              fit: BoxFit.cover,
            ),
          SizedBox(
            width: isMe ? 0 : 10,
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: Get.width * 0.7,
                ),
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isMe ? kSecondaryColor : kInputColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(!isMe ? 0 : 10),
                    bottomRight: Radius.circular(isMe ? 0 : 10),
                  ),
                ),
                child: MyText(
                  text: '$msg',
                  size: 12,
                  color: isMe ? kPrimaryColor : kQuaternaryColor,
                ),
              ),
              Positioned(
                bottom: -20,
                left: isMe ? 0 : null,
                right: !isMe ? 0 : null,
                child: MyText(
                  text: time,
                  size: 8,
                  color: kBlackColor.withOpacity(0.4),
                ),
              ),
            ],
          ),
          SizedBox(
            width: isMe ? 8 : 0,
          ),
          if (isMe)
            CommonImageView(
              height: 36,
              width: 36,
              url: userModelGlobal.value?.profileImg ?? '',
              radius: 100,
              fit: BoxFit.cover,
            ),
        ],
      ),
    );
  }
}
