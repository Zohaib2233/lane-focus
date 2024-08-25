import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/controller/chat_controller/chat_controller.dart';
import 'package:lanefocus/core/constants/instance_constants.dart';
import 'package:lanefocus/main.dart';
import 'package:lanefocus/model/user/user_model.dart';
import 'package:lanefocus/view/widget/common_image_view_widget.dart';
import 'package:lanefocus/view/widget/custom_chat_bubble_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:lanefocus/view/widget/send_field_widget.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen(
      {super.key, required this.chatHeadId, required this.receiverUserModel});

  final String chatHeadId;
  final UserModel receiverUserModel;

  final chatController = Get.find<ChatController>();

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
              url: receiverUserModel.profileImg != null &&
                      receiverUserModel.profileImg!.isNotEmpty
                  ? receiverUserModel.profileImg
                  : ' ',
              height: 40,
              width: 40,
              radius: 100,
            ),
            Expanded(
              child: MyText(
                text: receiverUserModel.fullName != null &&
                        receiverUserModel.fullName != ' '
                    ? receiverUserModel.fullName!
                    : 'Anonymous',
                weight: FontWeight.w500,
                size: 16,
                paddingLeft: 8,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                shrinkWrap: true,
                reverse: true,
                padding: AppSizes.DEFAULT,
                itemCount: chatController.messages.length,
                itemBuilder: (c, index) {
                  return CustomChatBubbles(
                    profileImage: dummyImg,
                    msg: chatController.messages[index].message ?? '',
                    isMe: chatController.messages[index].sentBy ==
                        auth.currentUser!.uid,
                    time: DateFormat('yy/MM/dd HH:mm')
                        .format(chatController.messages[index].sentAt!),
                  );
                },
              ),
            ),
          ),
          SendField(
            controller: chatController.msgController,
            chatId: chatHeadId,
            onSend: () async {
              if (chatController.msgController.text.isNotEmpty) {
                await Get.find<ChatController>().sendMessageInThread(
                    chatRoomId: chatHeadId,
                    message: chatController.msgController.text.trim(),
                    token: receiverUserModel.token ?? '',
                    targetId: receiverUserModel.userId ?? '',
                    name: receiverUserModel.fullName ?? '',
                    img: receiverUserModel.profileImg ?? '',
                    userId: receiverUserModel.userId ?? '',
                    type: 'text');
              }
            },
            onChanged: (v) {},
          ),
        ],
      ),
    );
  }
}
