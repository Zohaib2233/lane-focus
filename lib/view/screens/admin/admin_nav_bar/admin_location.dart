import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/constants/app_styling.dart';
import 'package:lanefocus/controller/adminControllers/admin_location_controller.dart';
import 'package:lanefocus/main.dart';
import 'package:lanefocus/model/user/user_model.dart';
import 'package:lanefocus/view/widget/car_location_marker_widget.dart';
import 'package:lanefocus/view/widget/common_image_view_widget.dart';
import 'package:lanefocus/view/widget/custom_bottom_sheet_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';

import '../../../../model/user/geoPoint_model.dart';

class AdminLocation extends StatelessWidget {
  const AdminLocation({super.key});

  @override
  Widget build(BuildContext context) {
    AdminLocationController controller = Get.find();
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => controller.initialPosition.value != null ||
                  controller.isLoading.isTrue
              ? Stack(
                  children: [
                    GetBuilder<AdminLocationController>(
                      builder: (AdminLocationController controller) {
                        return GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  controller.initialPosition.value!.latitude,
                                  controller.initialPosition.value!.longitude),
                              zoom: 14,
                            ),
                            onMapCreated: (mapController) {
                              controller.mapController = mapController;
                            },
                            myLocationEnabled: true,
                            markers: controller.familyMembers.map((user) {
                              print("User Changes");
                              Geo geoModel = Geo();
                              if (user.drivingModel?.destinationLoc != null) {
                                geoModel = Geo.fromJson(
                                    user.drivingModel!.destinationLoc!);
                              }

                              return Marker(
                                icon: controller.userIcon.value,
                                markerId: MarkerId(user.userId!),
                                position: LatLng(
                                    geoModel.geopoint?.latitude ?? 0,
                                    geoModel.geopoint?.longitude ?? 0),
                                infoWindow: InfoWindow(title: user.fullName),
                              );
                            }).toSet(),
                            polylines: controller.polylines.toSet());
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 60,
                        ),
                        Container(
                          color: kGreenColor.withOpacity(0.2),
                          padding: AppSizes.HORIZONTAL,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyText(
                                    text: 'Location',
                                    size: 20,
                                    weight: FontWeight.w600,
                                    color: kSecondaryColor,
                                    paddingTop: 4,
                                    paddingBottom: 15,
                                  ),
                                  PopupMenuButton(
                                    padding: EdgeInsets.zero,
                                    child: Row(
                                      children: [
                                        Obx(()=>controller.circlesList.isNotEmpty?MyText(
                                            text:
                                                "${controller.circlesList[controller.familyIndex.value].name}",
                                            weight: FontWeight.w700,
                                          ):Container(),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(Icons.arrow_drop_down)
                                      ],
                                    ),
                                    itemBuilder: (context) => List.generate(
                                      controller.circlesList.length,
                                      (index) => PopupMenuItem(
                                          onTap: () {
                                            controller.familyIndex.value =
                                                index;
                                            controller.fetchFamilyMembers(
                                                index: index);
                                          },
                                          padding: EdgeInsets.zero,
                                          value: index,
                                          child: Row(
                                            children: [
                                              Icon(Icons
                                                  .family_restroom_outlined),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              MyText(
                                                  text:
                                                      "${controller.circlesList[index].name}")
                                            ],
                                          )),
                                    ),
                                  )
                                ],
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(
                                    controller.familyMembers.length,
                                    (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.bottomSheet(
                                            _locationBottomSheet(
                                                controller: controller,
                                                userModel: controller
                                                    .familyMembers[index]),
                                          );
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CommonImageView(
                                                url: controller.familyMembers[index].profileImg??dummyImg,
                                                height: 60,
                                                width: 60,
                                                radius: 100,
                                              ),
                                              MyText(
                                                text:
                                                    '${controller.familyMembers[index].fullName}',
                                                size: 11,
                                                weight: FontWeight.w500,
                                                paddingTop: 4,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Container(
                  height: Get.height,
                  width: Get.width,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _locationBottomSheet(
      {required UserModel userModel,
      required AdminLocationController controller}) {
    return CustomBottomSheet(
      height: Get.height * 0.25,
      child: Padding(
        padding: AppSizes.HORIZONTAL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 7,
            ),
            Row(
              children: [
                Expanded(
                  child: MyText(
                    text: '${userModel.fullName}',
                    size: 18,
                    weight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.close,
                    size: 20,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onLongPress: () {
                      print("Long Pressed");
                      if (userModel.drivingModel?.destinationLoc != null) {
                        Get.back();
                        Geo userCurrentLocation = Geo.fromJson(
                            userModel.drivingModel!.destinationLoc!);
                        controller.mapController?.animateCamera(
                            CameraUpdate.newLatLng(LatLng(
                                userCurrentLocation.geopoint?.latitude ?? 0,
                                userCurrentLocation.geopoint?.longitude ?? 0)));
                        controller.update();
                      }
                    },
                    child: Container(
                      height: 72,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: AppStyling.cardDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Assets.imagesCar2,
                            height: 20,
                          ),
                          MyText(
                            text: userModel.isDriving ?? false
                                ? 'Diving'
                                : "Not Driving",
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
                ),
                SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: Container(
                    height: 72,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: AppStyling.cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.end,
                          children: [
                            Obx(()=>MyText(
                                text:
                                    '${userModel.drivingModel?.overSpeedCount ?? 0}',
                                size: 16,
                                color: kSecondaryColor,
                                weight: FontWeight.w500,
                                lineHeight: 1.2,
                              ),
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
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: AppStyling.cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.end,
                          children: [
                            MyText(
                              text:
                                  '${double.parse(userModel.drivingModel?.totalSpeed ?? '0.0').toPrecision(0)}',
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
          ],
        ),
      ),
    );
  }
}
