import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/services/local_storage/local_storage_service.dart';
import 'package:lanefocus/view/screens/auth/login/login.dart';
import 'package:lanefocus/view/screens/launch/get_started.dart';
import 'package:lanefocus/view/widget/my_button_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatefulWidget {
  OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  PageController _pageController = PageController();

  int _currentIndex = 0;

  final List<Map<String, dynamic>> onBoarding = [
    {
      'text':
          '“Improve your teen\'s road safety knowledge, curb distracted driving”',
      'image': Assets.imagesOnboarding1,
    },
    {
      'text':
          '“Join a community prioritizing safer roads. Don\'t wait, sign up for LaneFocus launch updates today!”',
      'image': Assets.imagesOnboarding2,
    }
  ];

  void _onNext() async {
    if (_currentIndex == onBoarding.length - 1) {
      await LocalStorageService.instance
          .write(key: 'notfirstTime', value: true);
      Get.offAll(() => Login());
    } else {
      _pageController.nextPage(
        duration: Duration(
          milliseconds: 280,
        ),
        curve: Curves.linear,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: Duration(
              milliseconds: 280,
            ),
            child: Image.asset(
              onBoarding[_currentIndex]['image'],
              key: ValueKey<int>(_currentIndex),
              height: Get.height,
              width: Get.width,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              height: Get.height * 0.7,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    kBlackColor.withOpacity(0.0),
                    kBlackColor,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: onBoarding.length,
                      onPageChanged: (v) {
                        setState(() {
                          _currentIndex = v;
                        });
                      },
                      itemBuilder: (ctx, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MyText(
                              text: onBoarding[index]['text'],
                              size: 20,
                              color: kPrimaryColor,
                              weight: FontWeight.w700,
                              textAlign: TextAlign.center,
                              paddingLeft: 20,
                              paddingRight: 20,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: AppSizes.DEFAULT,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SmoothPageIndicator(
                          axisDirection: Axis.horizontal,
                          controller: _pageController,
                          count: onBoarding.length,
                          effect: WormEffect(
                            dotWidth: 8,
                            dotHeight: 8,
                            strokeWidth: 0.7,
                            spacing: 6,
                            activeDotColor: kSecondaryColor,
                            paintStyle: PaintingStyle.stroke,
                            dotColor: kPrimaryColor,
                          ),
                          onDotClicked: (index) {},
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        MyButton(
                          buttonText:
                              _currentIndex == 0 ? 'Continue' : 'Get Started',
                          onTap: _onNext,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
