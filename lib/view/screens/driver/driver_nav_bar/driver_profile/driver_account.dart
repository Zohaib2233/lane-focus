import 'package:flutter/material.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/main.dart';
import 'package:lanefocus/view/widget/common_image_view_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:lanefocus/view/widget/simple_app_bar_widget.dart';

class DriverAccount extends StatelessWidget {
  const DriverAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'My Profile',
      ),
      body: ListView(
        padding: AppSizes.DEFAULT,
        children: [
          Center(
            child: CommonImageView(
              url: dummyImg,
              height: 80,
              width: 80,
              radius: 100,
            ),
          ),
          SizedBox(
            height: 32,
          ),
          AccountTile(
            title: 'First Name',
            trailingText: 'Andrew',
          ),
          AccountTile(
            title: 'Last Name',
            trailingText: 'John',
          ),
          AccountTile(
            title: 'Age',
            trailingText: '23years',
          ),
          AccountTile(
            title: 'Email',
            trailingText: 'andrew,john@gmail.com',
          ),
          AccountTile(
            title: 'Mobile',
            trailingText: '(123) 178-4453',
          ),
        ],
      ),
    );
  }
}

class AccountTile extends StatelessWidget {
  final String title, trailingText;
  const AccountTile({
    super.key,
    required this.title,
    required this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: MyText(
                text: title,
                weight: FontWeight.w500,
              ),
            ),
            MyText(
              text: trailingText,
              weight: FontWeight.w600,
            ),
          ],
        ),
        Container(
          height: 1,
          color: kInputBorderColor,
          margin: EdgeInsets.symmetric(vertical: 20),
        ),
      ],
    );
  }
}
