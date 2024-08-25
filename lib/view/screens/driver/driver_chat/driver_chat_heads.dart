import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/main.dart';
import 'package:lanefocus/view/screens/driver/driver_chat/driver_chat_screen.dart';
import 'package:lanefocus/view/widget/chat_head_tile_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';

import '../../../widget/simple_app_bar_widget.dart';

class DriverChatHeads extends StatelessWidget {
  const DriverChatHeads({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(title: ''),
      body: ListView(
        padding: AppSizes.VERTICAL,
        children: [
          Padding(
            padding: AppSizes.HORIZONTAL,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                MyText(
                  text: 'Messages',
                  size: 16,
                  weight: FontWeight.w600,
                  paddingRight: 4,
                ),
                CircleAvatar(
                  backgroundColor: kSecondaryColor,
                  radius: 9,
                  child: Center(
                    child: MyText(
                      text: '5',
                      size: 8,
                      color: kPrimaryColor,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: 4,
            itemBuilder: (context, index) {
              return ChatHeadTile(
                image: dummyImg,
                name: 'Hanna',
                lastMessage: 'Lorem ipsum dolor sit amet',
                onTap: () {
                  Get.to(() => DriverChatScreen());
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
