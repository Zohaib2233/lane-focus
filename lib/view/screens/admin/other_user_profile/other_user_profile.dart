import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/constants/app_styling.dart';
import 'package:lanefocus/controller/chat_controller/chat_controller.dart';
import 'package:lanefocus/controller/home_controller/admin_home_controller.dart';
import 'package:lanefocus/core/constants/instance_collections.dart';
import 'package:lanefocus/main.dart';
import 'package:lanefocus/services/googleMap/google_map.dart';
import 'package:lanefocus/view/screens/admin/other_user_profile/customize_specific_apps.dart';
import 'package:lanefocus/view/screens/admin/other_user_profile/manual_override.dart';
import 'package:lanefocus/view/screens/admin/other_user_profile/phone_usage.dart';
import 'package:lanefocus/view/screens/admin/other_user_profile/restricted_app_usage.dart';
import 'package:lanefocus/view/screens/admin/other_user_profile/speeding.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:lanefocus/view/widget/simple_app_bar_widget.dart';
import 'package:lanefocus/view/widget/user_profile_tile_widget.dart';

import '../../../../model/user/user_model.dart';

class OtherUserProfile extends StatefulWidget {
  final String otherUserId;

  OtherUserProfile({super.key, required this.otherUserId});

  @override
  State<OtherUserProfile> createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  final chatController = Get.find<ChatController>();

  var address = <Placemark>[].obs;

  Future<void> getAddress(GeoPoint? point) async {
    if (point != null) {
      try{
        address.value = await GoogleMapsService.instance
            .getAddressThroughLatLong(lat: point.latitude, long: point.longitude);
      }
      catch(e){
        throw Exception(e);
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: usersCollection.doc(widget.otherUserId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            final otherUser = UserModel.fromJson(
                snapshot.data?.data() as Map<String, dynamic>);
            Future.delayed(Duration.zero).then(
              (_) async {
                await getAddress(
                    otherUser.drivingModel?.destinationLoc?['geopoint']??GeoPoint(0, 0));
              },
            );
            return Scaffold(
              appBar: simpleAppBar(title: '${otherUser.fullName}'),
              body: snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(
                        color: kSecondaryColor,
                      ),
                    )
                  : otherUser.isDriving==false || otherUser.isDriving==null
                      ? Center(
                          child: MyText(text: 'Drive mode is off'),
                        )
                      : ListView(
                          padding: AppSizes.DEFAULT,
                          children: [
                            Obx(
                              () => UserProfileTile(
                                image: otherUser.profileImg ??
                                    dummyUserPlaceholder,
                                name: '${otherUser.fullName}',
                                location: address.isEmpty
                                    ? ''
                                    : address.first.name ?? '',
                                time: DateFormat.jm()
                                    .format(otherUser.driveStartTime!),
                                onTap: () async {},
                                icon: IconButton(
                                    onPressed: () async {
                                      await chatController
                                          .enterChatRoom(widget.otherUserId);
                                    },
                                    icon:
                                        Icon(CupertinoIcons.chat_bubble_text)),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 72,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: AppStyling.cardDecoration,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          Assets.imagesCar2,
                                          height: 20,
                                        ),
                                        MyText(
                                          text: 'Driving',
                                          size: 14,
                                          color: kSecondaryColor,
                                          weight: FontWeight.w400,
                                          maxLines: 1,
                                          textOverflow: TextOverflow.ellipsis,
                                          paddingTop: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 72,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: AppStyling.cardDecoration,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.end,
                                          children: [
                                            MyText(
                                              text: otherUser.overSpeedCount
                                                  .toString(),
                                              size: 16,
                                              color: kSecondaryColor,
                                              weight: FontWeight.w500,
                                              lineHeight: 1.2,
                                            ),
                                            MyText(
                                              text: ' times',
                                              size: 10,
                                              color: kSecondaryColor,
                                            ),
                                          ],
                                        ),
                                        MyText(
                                          text: 'Over speed',
                                          size: 14,
                                          color: kSecondaryColor,
                                          weight: FontWeight.w400,
                                          maxLines: 1,
                                          textOverflow: TextOverflow.ellipsis,
                                          paddingTop: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 72,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: AppStyling.cardDecoration,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.end,
                                          children: [
                                            MyText(
                                            //  text: '999',
                                              text: otherUser
                                                      .drivingModel?.totalSpeed
                                                      ?.substring(0, 3) ??
                                                  '0.0',
                                              size: 16,
                                              color: kSecondaryColor,
                                              weight: FontWeight.w500,
                                              lineHeight: 1.2,
                                            ),
                                            MyText(
                                              text: ' km/h',
                                              size: 10,
                                              color: kSecondaryColor,
                                            ),
                                          ],
                                        ),
                                        MyText(
                                          text: 'Total Speed',
                                          size: 14,
                                          color: kSecondaryColor,
                                          weight: FontWeight.w400,
                                          maxLines: 1,
                                          textOverflow: TextOverflow.ellipsis,
                                          paddingTop: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 1,
                              color: kInputBorderColor,
                              margin: EdgeInsets.symmetric(vertical: 20),
                            ),
                            _ProfileTile(
                              icon: Assets.imagesPhoneUsage,
                              title: 'Phone Usage',
                              onTap: () {
                                Get.to(() => PhoneUsage(
                                      otherUserId: otherUser.userId!,
                                      startTime: otherUser
                                              .drivingModel?.drivingSince ??
                                          DateTime.now(),
                                    ));
                              },
                            ),
                            // _ProfileTile(
                            //   icon: Assets.imagesAppUsage,
                            //   title: 'Restricted Apps Usage',
                            //   onTap: () {
                            //     Get.to(() => RestrictedAppUsage());
                            //   },
                            // ),
                            // _ProfileTile(
                            //   icon: Assets.imagesSpeeding,
                            //   title: 'Speeding',
                            //   onTap: () {
                            //     Get.to(() => Speeding());
                            //   },
                            // ),
                            // _ProfileTile(
                            //   icon: Assets.imagesManualOverride,
                            //   title: 'Manual overrides',
                            //   onTap: () {
                            //     Get.to(() => ManualOverrides());
                            //   },
                            // ),
                            // _ProfileTile(
                            //   icon: Assets.imagesSpecificApp,
                            //   title: 'Customize Specific Apps',
                            //   onTap: () {
                            //     Get.to(() => CustomizeSpecificApps());
                            //   },
                            // ),
                          ],
                        ),
            );
          }
        });
  }
}

class _ProfileTile extends StatelessWidget {
  final String title, icon;
  final VoidCallback onTap;
  const _ProfileTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                icon,
                height: 40,
              ),
              Expanded(
                child: MyText(
                  text: title,
                  size: 16,
                  paddingLeft: 10,
                ),
              ),
              Image.asset(
                Assets.imagesArrowRight2,
                height: 24,
              ),
            ],
          ),
          Container(
            height: 1,
            color: kInputBorderColor,
            margin: EdgeInsets.symmetric(vertical: 12),
          ),
        ],
      ),
    );
  }
}
