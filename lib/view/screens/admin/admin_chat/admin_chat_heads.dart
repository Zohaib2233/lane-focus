import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/controller/chat_controller/chat_controller.dart';
import 'package:lanefocus/view/screens/admin/admin_chat/admin_chat_screen.dart';
import 'package:lanefocus/view/widget/chat_head_tile_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';

import '../../../widget/simple_app_bar_widget.dart';

class ChatHeads extends StatelessWidget {
  ChatHeads({super.key});

  final chatController = Get.find<ChatController>();

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
                Obx(
                  () => Visibility(
                    visible: chatController.unreadCount.value > 0,
                    child: CircleAvatar(
                      backgroundColor: kSecondaryColor,
                      radius: 9,
                      child: Center(
                        child: Obx(
                          () => MyText(
                            text: chatController.unreadCount.value.toString(),
                            size: 8,
                            color: kPrimaryColor,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Obx(
            () => ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: chatController.chatHeads.length,
              itemBuilder: (context, index) {
                return ChatHeadTile(
                  image: chatController.chatHeadUsers[index].profileImg ?? ' ',
                  name: chatController.chatHeadUsers[index].fullName != null &&
                          chatController.chatHeadUsers[index].fullName != ' '
                      ? chatController.chatHeadUsers[index].fullName!
                      : 'Anonymous',
                  lastMessage:
                      chatController.chatHeads[index].lastMessage ?? '',
                  onTap: () async {
                    await chatController.getChatsInThread(
                        chatController.chatHeads[index].chatHeadId ?? '');
                    await chatController.markAsRead(
                        chatController.chatHeads[index].chatHeadId ?? '');
                    Get.to(() => ChatScreen(
                          receiverUserModel:
                              chatController.chatHeadUsers[index],
                          chatHeadId:
                              chatController.chatHeads[index].chatHeadId ?? '',
                        ));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
