import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/view/widget/my_button_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:lanefocus/view/widget/my_textfield_widget.dart';
import 'package:lanefocus/view/widget/simple_app_bar_widget.dart';
import 'package:share_plus/share_plus.dart';

class ShareInviteLink extends StatefulWidget {
  final String link, code;

  const ShareInviteLink({super.key, required this.link, required this.code});

  @override
  State<ShareInviteLink> createState() => _ShareInviteLinkState();
}

class _ShareInviteLinkState extends State<ShareInviteLink> {
  TextEditingController linkController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    linkController.text = widget.link;
    codeController.text = widget.code;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(title: ''),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: AppSizes.DEFAULT,
              children: [
                MyText(
                  text: 'Share invite link with your family members!',
                  size: 20,
                  paddingBottom: 10,
                ),
                MyText(
                  text:
                      'Note: You can share this code any way you like: text it, email it, write it down, or say it.',
                  color: kQuaternaryColor,
                  paddingBottom: 30,
                ),
                MyTextField(
                  controller: linkController,
                  readOnly: true,
                  heading: 'Invite link',
                  hint: 'Link ',
                  suffix: GestureDetector(
                    onTap: (){

                      Clipboard.setData(ClipboardData(text: linkController.text));
                      // Get.snackbar('Copied!', 'Text copied to clipboard.',
                      //     snackPosition: SnackPosition.BOTTOM);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.imagesCopy,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                MyText(
                  text:
                  'Note: If above link does\'nt work please use this code.',
                  color: kQuaternaryColor,
                  paddingBottom: 30,
                ),
                MyTextField(
                  controller: codeController,
                  readOnly: true,
                  heading: 'Invite Code',
                  hint: 'Code ',
                  suffix: GestureDetector(
                    onTap: (){
                      Clipboard.setData(ClipboardData(text: codeController.text));
                      // Get.snackbar('Copied!', 'Text copied to clipboard.',
                      //     snackPosition: SnackPosition.BOTTOM);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.imagesCopy,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              buttonText: 'Share Link',
              onTap: () {
                String message = "Use this link for adding into my Family Circle\n\n${linkController.text}\n\nIf Link is not working than use this code \n\n${codeController.text}";
                Share.share(message);
                // Get.offAll(() => AdminNavBar(),binding: );
              },
            ),
          ),
        ],
      ),
    );
  }
}
