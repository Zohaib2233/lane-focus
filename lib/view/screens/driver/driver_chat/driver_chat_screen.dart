import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/controller/chat_controller/chat_controller.dart';
import 'package:lanefocus/main.dart';
import 'package:lanefocus/view/widget/common_image_view_widget.dart';
import 'package:lanefocus/view/widget/custom_chat_bubble_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:lanefocus/view/widget/send_field_widget.dart';

class DriverChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 4,
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Row(
          children: [
            IconButton(
              splashColor: kSecondaryColor.withOpacity(0.1),
              highlightColor: kSecondaryColor.withOpacity(0.1),
              onPressed: () => Get.back(),
              icon: Image.asset(
                Assets.imagesBack,
                height: 24,
              ),
            ),
            CommonImageView(
              url: dummyImg,
              height: 40,
              width: 40,
              radius: 100,
            ),
            Expanded(
              child: MyText(
                text: 'Jessy',
                weight: FontWeight.w500,
                size: 16,
                paddingLeft: 8,
              ),
            ),
            PopupMenuButton(
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              iconColor: kQuaternaryColor,
              iconSize: 20,
              itemBuilder: (ctx) {
                return [
                  PopupMenuItem(
                    height: 36,
                    onTap: () {},
                    child: MyText(
                      text: 'Report',
                      size: 12,
                      color: kBlackColor,
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 1,
              padding: AppSizes.DEFAULT,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MyText(
                      text: 'Today',
                      size: 12,
                      color: kQuaternaryColor,
                      textAlign: TextAlign.center,
                      paddingTop: 16,
                      paddingBottom: 15,
                    ),
                    ...List.generate(
                      4,
                      (i) {
                        return CustomChatBubbles(
                          profileImage: dummyImg,
                          msg: index.isOdd
                              ? 'Reach school safely!'
                              : 'Have a nice day, Work hard!',
                          isMe: i.isOdd,
                          time: '12:02 AM',
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          SendField(
            onChanged: (v) {},
          ),
        ],
      ),
    );
  }
}
