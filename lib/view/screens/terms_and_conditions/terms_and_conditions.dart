import 'package:flutter/material.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:lanefocus/view/widget/simple_app_bar_widget.dart';

class TermsAndConditions extends StatelessWidget {
  TermsAndConditions({super.key});

  final List<Map<String, dynamic>> terms = [
    {
      'title': '1. Acceptance of Terms:',
      'subTitle':
          'By using the LaneFocus app, you agree to abide by these terms and conditions.',
    },
    {
      'title': '2. User Responsibilities: ',
      'subTitle':
          'You are responsible for the content you post. Respect the community guidelines and ensure your contributions are lawful and respectful.',
    },
    {
      'title': '3. Privacy:',
      'subTitle':
          'We value your privacy. Check out our Privacy Policy to understand how we collect, use, and protect your personal information.',
    },
    {
      'title': '4. Intellectual Property:',
      'subTitle':
          'Respect intellectual property rights. Don\'t infringe on copyrights or trademarks when posting content.',
    },
    {
      'title': '5. Prohibited Activities:',
      'subTitle':
          'Engaging in harmful activities, spam, or any form of abuse is not allowed. Be a positive force in our community.',
    },
    {
      'title': '6. Termination:',
      'subTitle':
          'We reserve the right to terminate accounts violating our terms without notice.',
    },
    {
      'title': '7. Updates:',
      'subTitle':
          'Terms may be updated; it\'s your responsibility to stay informed.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Terms and Conditions',
      ),
      body: ListView(
        padding: AppSizes.DEFAULT,
        children: [
          MyText(
            text: 'LaneFocus Terms & Conditions',
            weight: FontWeight.w500,
            paddingBottom: 15,
          ),
          MyText(
            text:
                'Welcome to LaneFocus! Before you dive into the exciting world of social connections, courses, and events, please take a moment to review our brief terms and conditions.',
            size: 12,
            color: kQuaternaryColor,
            paddingBottom: 15,
          ),
          ...List.generate(
            terms.length,
            (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MyText(
                    text: terms[index]['title'],
                    size: 12,
                    weight: FontWeight.w700,
                    paddingBottom: 4,
                  ),
                  MyText(
                    text: terms[index]['subTitle'],
                    size: 12,
                    color: kQuaternaryColor,
                    paddingBottom: 15,
                  ),
                ],
              );
            },
          ),
          MyText(
            text:
                'Thanks for being part of Marchè – let\'s create an amazing social experience together!',
            size: 12,
            color: kQuaternaryColor,
          ),
        ],
      ),
    );
  }
}
