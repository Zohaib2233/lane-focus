import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/constants/app_sizes.dart';

import 'package:lanefocus/controller/home_controller/admin_home_controller.dart';
import 'package:lanefocus/core/constants/instance_collections.dart';

import 'package:lanefocus/core/constants/instance_constants.dart';
import 'package:lanefocus/main.dart';
import 'package:lanefocus/model/user/user_model.dart';
import 'package:lanefocus/services/googleMap/google_map.dart';
import 'package:lanefocus/view/screens/admin/admin_nav_bar/admin_home/add_circle.dart';
import 'package:lanefocus/view/screens/admin/admin_nav_bar/admin_home/share_invite_link.dart';
import 'package:lanefocus/view/screens/admin/admin_nav_bar/admin_home/view_teens.dart';
import 'package:lanefocus/view/screens/admin/other_user_profile/other_user_profile.dart';
import 'package:lanefocus/view/widget/common_image_view_widget.dart';
import 'package:lanefocus/view/widget/custom_search_bar_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:lanefocus/view/widget/user_profile_tile_widget.dart';

import '../../../../../core/utils/utils.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    AdminHomeController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Obx(
          () => Row(
            children: [
              CommonImageView(
                url: userModelGlobal.value?.profileImg.toString() ?? dummyImg,
                height: 38,
                width: 38,
                radius: 100,
                borderWidth: 2,
                borderColor: kSecondaryColor,
              ),
              Expanded(
                child: MyText(
                  text:
                      userModelGlobal.value?.fullName.toString() ?? 'Hi! Emma',
                  size: 16,
                  weight: FontWeight.w600,
                  paddingLeft: 8,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: AppSizes.DEFAULT,
            child: CustomSearchBar(
              onChanged: (query) {
                controller.searchCircle(query: query);
              },
              controller: controller.searchController,
              hint: 'Search for a Circle/Teen...',
            ),
          ),
          Obx(
            () => controller.isSearch.isTrue
                ? Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.filteredCircleList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: ListTile(
                            onTap: () {
                              Get.to(() => ViewTeens(
                                  circleModel:
                                      controller.filteredCircleList[index]));
                            },
                            leading: CommonImageView(
                              url: controller.filteredCircleList[index].imgUrl,
                              height: 60,
                              width: 60,
                              radius: 100,
                            ),
                            title: MyText(
                              text: controller.filteredCircleList[index].name ??
                                  '',
                            ),
                            trailing: Image.asset(
                              Assets.imagesArrowRight,
                              height: 24,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Expanded(
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      padding: AppSizes.VERTICAL,
                      children: [
                        MyText(
                          text: 'Your Circles',
                          size: 16,
                          paddingLeft: 20,
                          paddingBottom: 12,
                        ),
                        SizedBox(
                          height: 108,
                          child: Obx(
                            () => ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 13),
                              scrollDirection: Axis.horizontal,
                              itemCount: (controller.circlesList.length + 1),
                              itemExtent: 142,
                              itemBuilder: (ctx, index) {
                                return index == (controller.circlesList.length)
                                    ? GestureDetector(
                                        onTap: () {
                                          Get.to(() => AddCircle());
                                        },
                                        child: Container(
                                          height: Get.height,
                                          width: Get.width,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 7),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                              width: 1.0,
                                              color: kInputBorderColor,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 30,
                                                backgroundColor: kBlueColor,
                                                child: Center(
                                                  child: Image.asset(
                                                    Assets.imagesAdd,
                                                    height: 38,
                                                  ),
                                                ),
                                              ),
                                              MyText(
                                                text: 'Add Circle',
                                                color: kBlueColor,
                                                weight: FontWeight.w500,
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                paddingTop: 4,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : controller.circlesList.isNotEmpty
                                        ? GestureDetector(
                                            onTap: () {
                                              // print("Decoded = ${Utils.decodeInviteCode("4KEPX")}");
                                              controller.familyIndex.value =
                                                  index;
                                              // setState(() {
                                              //
                                              // });

                                              print(
                                                  "circles list members =  ${controller.circlesList[controller.familyIndex.value].members}");
                                            },
                                            onLongPress: () {
                                              Get.to(() => ShareInviteLink(
                                                  link: controller
                                                      .circlesList[index]
                                                      .inviteLink!,
                                                  code: controller
                                                      .circlesList[index]
                                                      .inviteCode!));
                                            },
                                            child: Obx(
                                              () => _CircleCard(
                                                isSelected: controller
                                                        .familyIndex.value ==
                                                    index,
                                                image:
                                                    '${controller.circlesList[index].imgUrl}',
                                                name:
                                                    '${controller.circlesList[index].name}',
                                              ),
                                            ),
                                          )
                                        : Container();
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.7,
                          child: Padding(
                            padding: AppSizes.HORIZONTAL,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                MyText(
                                  text: 'Teens',
                                  size: 16,
                                  paddingTop: 24,
                                  paddingBottom: 20,
                                ),

                                Expanded(
                                  child: Obx(
                                    () => controller.circlesList.isNotEmpty
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: controller
                                                    .circlesList[controller
                                                        .familyIndex.value]
                                                    .members
                                                    ?.length ??
                                                0,
                                            itemBuilder: (context, index) {
                                              var address = <Placemark>[].obs;

                                              print(
                                                  "circles list members on 2 =  ${controller.circlesList[controller.familyIndex.value].members}");
                                              if (controller
                                                  .circlesList[controller
                                                      .familyIndex.value]
                                                  .members!
                                                  .isEmpty) {
                                                print("Member Empty");
                                                return Center(
                                                  child: MyText(
                                                    text: "No Member Added",
                                                  ),
                                                );
                                              } else {
                                                return StreamBuilder(
                                                  stream: usersCollection
                                                      .doc(controller
                                                          .circlesList[
                                                              controller
                                                                  .familyIndex
                                                                  .value]
                                                          .members![index])
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return Center(
                                                        child: MyText(
                                                          text:
                                                              "No Member Added",
                                                        ),
                                                      );
                                                    } else {
                                                      UserModel userModel =
                                                          UserModel.fromJson(
                                                              snapshot.data!
                                                                      .data()
                                                                  as Map<String,
                                                                      dynamic>);
                                                      Future.delayed(
                                                              Duration.zero)
                                                          .then(
                                                        (_) async {
                                                          final point = userModel
                                                                  .drivingModel
                                                                  ?.startLoc?[
                                                              'geopoint'];
                                                          if (point != null) {
                                                            address.value = await GoogleMapsService
                                                                .instance
                                                                .getAddressThroughLatLong(
                                                                    lat: point
                                                                        .latitude,
                                                                    long: point
                                                                        .longitude);
                                                          }
                                                        },
                                                      );
                                                      return Obx(
                                                        () => UserProfileTile(
                                                          image: userModel
                                                                  .profileImg ??
                                                              dummyUserPlaceholder,
                                                          name:
                                                              '${userModel.fullName}',
                                                          location: address
                                                                  .isEmpty
                                                              ? ''
                                                              : address.first
                                                                      .name ??
                                                                  '',
                                                          time: userModel
                                                                      .drivingModel
                                                                      ?.drivingSince !=
                                                                  null
                                                              ? 'Since ${Utils.formatDateTimetoTime(userModel.drivingModel!.drivingSince!)}'
                                                              : '',
                                                          onTap: () {
                                                            Get.to(() =>
                                                                OtherUserProfile(
                                                                  otherUserId:
                                                                      userModel
                                                                          .userId!,
                                                                ));
                                                          },
                                                        ),
                                                      );
                                                    }
                                                  },
                                                );
                                              }
                                            })
                                        : Center(
                                            child: MyText(
                                              text: "No Circles Added",
                                            ),
                                          ),
                                  ),
                                ),

                                ///
                                // ...List.generate(
                                //   2,
                                //       (index) {
                                //     return UserProfileTile(
                                //       image: dummyImg,
                                //       name: 'John Walt',
                                //       location: 'Near Blue Area',
                                //       time: 'Since 11:15 am',
                                //       onTap: () {
                                //         Get.to(() => OtherUserProfile());
                                //       },
                                //     );
                                //   },
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          )
        ],
      ),
    );
  }
}

class _CircleCard extends StatelessWidget {
  final String image, name;
  final bool isSelected;

  const _CircleCard({
    super.key,
    this.isSelected = false,
    required this.image,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      margin: EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          width: isSelected ? 2.0 : 1.0,
          color: kSecondaryColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CommonImageView(
              url: image,
              height: 60,
              width: 60,
              radius: 100,
              borderWidth: 1.0,
              borderColor: kSecondaryColor,
            ),
          ),
          MyText(
            text: '$name',
            weight: FontWeight.w500,
            textAlign: TextAlign.center,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
            paddingTop: 4,
          ),
        ],
      ),
    );
  }
}
