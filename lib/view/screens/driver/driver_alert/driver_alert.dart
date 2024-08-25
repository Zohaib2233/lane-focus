import 'package:flutter/material.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/main.dart';
import 'package:lanefocus/view/widget/alert_card_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:lanefocus/view/widget/simple_app_bar_widget.dart';

class DriverAlert extends StatelessWidget {
  const DriverAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Alert',
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Assets.imagesSetting,
                height: 24,
              ),
            ],
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: ListView.builder(
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        itemCount: 2,
        itemBuilder: (ctx, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyText(
                text: index == 0 ? 'Today' : 'Yesterday',
                size: 12,
                weight: FontWeight.w500,
                paddingBottom: 10,
              ),
              ...List.generate(
                index == 0 ? 3 : 2,
                (i) {
                  return AlertCard(
                    image: dummyImg,
                    title: 'Jessy is having a car problem',
                    alertText: 'Get into the store and see what’s new!',
                    time: '9.56 AM',
                    onRemove: () {},
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
