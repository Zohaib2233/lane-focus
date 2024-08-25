import 'package:flutter/material.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/view/widget/custom_search_bar_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:lanefocus/view/widget/simple_app_bar_widget.dart';

class CustomizeSpecificApps extends StatelessWidget {
  const CustomizeSpecificApps({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(title: 'Customize Specific Apps'),
      body: ListView(
        padding: AppSizes.DEFAULT,
        children: [
          MyText(
            text: 'What is Customize Specific Apps?',
            size: 16,
            weight: FontWeight.w500,
            paddingBottom: 8,
          ),
          MyText(
            text:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam id condimentum nisi. In leo risus, dignissim ut dignissim eget, venenatis quis orci. Quisque id feugiat dolor, vel varius lacus. Nulla bibendum ex velit, et molestie velit rhoncus a. ',
            size: 12,
            weight: FontWeight.w300,
          ),
          Container(
            height: 1,
            color: kInputBorderColor,
            margin: EdgeInsets.symmetric(vertical: 15),
          ),
          MyText(
            text: 'Customize  Apps ',
            size: 16,
            weight: FontWeight.w500,
            paddingBottom: 8,
          ),
          CustomSearchBar(
            hint: 'Search for a app...',
          ),
          SizedBox(
            height: 10,
          ),
          ...List.generate(10, (index) {
            return _AppCard(
              appIcon: Assets.imagesWhatsappIcon,
              name: 'WhatsApp',
              isActive: index == 0 || index == 1,
              onTap: () {},
            );
          })
        ],
      ),
    );
  }
}

class _AppCard extends StatelessWidget {
  final String appIcon, name;
  final VoidCallback onTap;
  final bool isActive;
  const _AppCard({
    super.key,
    required this.appIcon,
    required this.name,
    required this.onTap,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: kInputBorderColor,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              height: 16,
              width: 16,
              duration: Duration(
                milliseconds: 280,
              ),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: isActive ? kPrimaryColor : kInputColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isActive ? kSecondaryColor : kInputBorderColor,
                  width: 1.0,
                ),
              ),
              child: isActive
                  ? Center(
                      child: Icon(
                        Icons.check,
                        color: kSecondaryColor,
                        size: 12,
                      ),
                    )
                  : SizedBox(),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Image.asset(
            appIcon,
            height: 26,
          ),
          Expanded(
            child: MyText(
              text: name,
              color: kBlackColor,
              weight: FontWeight.w500,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
              paddingLeft: 7,
            ),
          ),
        ],
      ),
    );
  }
}
