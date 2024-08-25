import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/core/constants/instance_constants.dart';
import 'package:lanefocus/main.dart';
import 'package:lanefocus/view/screens/admin/admin_nav_bar/admin_profile/admin_account.dart';
import 'package:lanefocus/view/screens/admin/admin_nav_bar/admin_profile/admin_delete_account.dart';
import 'package:lanefocus/view/screens/admin/admin_nav_bar/admin_profile/admin_password.dart';
import 'package:lanefocus/view/screens/auth/login/login.dart';
import 'package:lanefocus/view/screens/terms_and_conditions/terms_and_conditions.dart';
import 'package:lanefocus/view/widget/common_image_view_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:lanefocus/view/widget/profile_tile_widget.dart';

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppSizes.DEFAULT,
      children: [
        SizedBox(
          height: 50,
        ),
        Obx(
          ()=> Row(
            children: [
              CommonImageView(
                url: userModelGlobal.value?.profileImg.toString() ?? dummyImg,
                height: 56,
                width: 56,
                radius: 100,
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MyText(
                      text: userModelGlobal.value?.fullName.toString() ??'Emma Watson',
                      size: 16,
                      weight: FontWeight.w600,
                      paddingBottom: 4,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: MyText(
                            text: 'Show when you’re active',
                            size: 12,
                            color: kQuaternaryColor,
                          ),
                        ),
                        FlutterSwitch(
                          value: true,
                          onToggle: (v) {},
                          height: 20,
                          width: 36,
                          toggleSize: 16,
                          padding: 2,
                          activeColor: kSecondaryColor,
                          inactiveColor: kInputBorderColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        MyText(
          text: 'General',
          size: 16,
          weight: FontWeight.w600,
          paddingTop: 15,
          paddingBottom: 8,
        ),
        ProfileTile(
          title: 'My Account',
          onTap: () {
            Get.to(() => AdminAccount());
          },
        ),
        ProfileTile(
          title: 'Subscription',
          onTap: () {},
        ),
        MyText(
          text: 'Security',
          size: 16,
          weight: FontWeight.w600,
          paddingTop: 16,
          paddingBottom: 8,
        ),
        ProfileTile(
          title: 'Password',
          onTap: () {
            Get.to(() => AdminPassword());
          },
        ),
        MyText(
          text: 'Universal Settings',
          size: 16,
          weight: FontWeight.w600,
          paddingTop: 16,
          paddingBottom: 8,
        ),
        ProfileTile(
          title: 'Terms & conditions',
          onTap: () {
            Get.to(() => TermsAndConditions());
          },
        ),
        ProfileTile(
          title: 'Delete Account',
          onTap: () {
            Get.to(() => AdminDeleteAccount());
          },
        ),
        SizedBox(
          height: 18,
        ),
        GestureDetector(
          onTap: () {
            Get.offAll(() => Login());
            // Get.dialog(
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.stretch,
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Container(
            //         margin: AppSizes.HORIZONTAL,
            //         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            //         decoration: BoxDecoration(
            //           color: kPrimaryColor,
            //           borderRadius: BorderRadius.circular(20),
            //         ),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.stretch,
            //           children: [
            //             MyText(
            //               text:
            //                   'Are you sure you want to Logout from your account?',
            //               size: 16,
            //               textAlign: TextAlign.center,
            //               paddingBottom: 15,
            //             ),
            //             MyText(
            //               text: 'You can login any time',
            //               size: 14,
            //               color: kHintColor,
            //               textAlign: TextAlign.center,
            //               paddingBottom: 24,
            //             ),
            //             Row(
            //               children: [
            //                 Expanded(
            //                   child: MyButton(
            //                     height: 50,
            //                     radius: 50,
            //                     buttonText: 'Cancel',
            //                     bgColor: kQuaternaryColor,
            //                     textColor: kPrimaryColor,
            //                     onTap: () {
            //                       Get.back();
            //                     },
            //                   ),
            //                 ),
            //                 SizedBox(
            //                   width: 40,
            //                 ),
            //                 Expanded(
            //                   child: MyButton(
            //                     height: 50,
            //                     radius: 50,
            //                     buttonText: 'Log Out',
            //                     textColor: kPrimaryColor,
            //                     bgColor: kRedColor,
            //                     onTap: () {
            //                       Get.offAll(() => Login());
            //                     },
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ],
            //         ),
            //       )
            //     ],
            //   ),
            // );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                Assets.imagesLogout,
                height: 18,
              ),
              MyText(
                text: 'Logout',
                size: 12,
                weight: FontWeight.w500,
                color: kRedColor,
                paddingLeft: 8,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
