import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/constants/app_styling.dart';

import 'package:lanefocus/controller/chat_controller/chat_controller.dart';
import 'package:lanefocus/controller/driverControllers/driver_home_controller.dart';
import 'package:lanefocus/controller/home_controller/circle_controller.dart';
import 'package:lanefocus/main.dart';
import 'package:lanefocus/view/screens/admin/admin_chat/admin_chat_heads.dart';

import 'package:lanefocus/controller/phone_usage_controller/phone_usage_driver_controller.dart';
import 'package:lanefocus/main.dart';
import 'package:lanefocus/utils/global_instances.dart';

import 'package:lanefocus/view/screens/driver/driver_alert/driver_alert.dart';
import 'package:lanefocus/view/widget/common_image_view_widget.dart';
import 'package:lanefocus/view/widget/my_button_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';

import '../../../../core/constants/instance_collections.dart';
import '../../../../core/constants/instance_constants.dart';
import '../../../../model/user/user_model.dart';
import '../../../../services/firebaseServices/firebase_crud_services.dart';

// ignore: must_be_immutable
class DriverHome extends StatelessWidget {
  DriverHome({super.key});

  final chatController = Get.find<ChatController>();
  final DriverHomeController driverHomeController =
  Get.find<DriverHomeController>();

  PhoneUsageDriverController _phoneUsageDriverController =
  Get.find<PhoneUsageDriverController>();

  @override
  Widget build(BuildContext context) {
    driverHomeController.setCustomMarkerIcon();
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 20,
          title: Row(
            children: [
              Spacer(),
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    AppStyling.customShadow,
                  ],
                ),
                child: MyRippleEffect(
                  onTap: () async {
                    // Get.find<CircleController>().addMember("b42c8360-d4a3-106d-8974-a5442d5a7365", auth.currentUser!.uid);
                    await chatController.getAllChatHeads();
                    Get.to(() => ChatHeads());
                  },
                  radius: 100,
                  splashColor: kBlackColor.withOpacity(0.1),
                  child: Center(
                    child: Stack(
                      children: [
                        Image.asset(
                          Assets.imagesMessage,
                          height: 24,
                        ),
                        Obx(
                              () =>
                              Visibility(
                                visible: chatController.unreadCount.value > 0,
                                child: Positioned(
                                  right: 0,
                                  child: Image.asset(
                                    Assets.imagesIndicator,
                                    height: 8,
                                  ),
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),

             /// this is alert button

              // Container(
              //   height: 48,
              //   width: 48,
              //   decoration: BoxDecoration(
              //     color: kPrimaryColor,
              //     shape: BoxShape.circle,
              //     boxShadow: [
              //       AppStyling.customShadow,
              //     ],
              //   ),
              //   child: MyRippleEffect(
              //     onTap: () {
              //       Get.to(() => DriverAlert());
              //     },
              //     radius: 100,
              //     splashColor: kBlackColor.withOpacity(0.1),
              //     child: Center(
              //       child: Image.asset(
              //         Assets.imagesBell,
              //         height: 24,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        body: GetBuilder<DriverHomeController>(
          builder: (DriverHomeController controller) {
            return controller.currentLocation != null
                ? Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          driverHomeController.currentLocation!.latitude!,
                          driverHomeController
                              .currentLocation!.longitude!),
                      zoom: 16),
                  // myLocationEnabled: true,
                  onMapCreated: (mapsController) {
                    controller.mapController = mapsController;
                    controller.update();
                  },

                  onCameraMove: (position) {
                    // controller.mapController?.animateCamera(
                    //     CameraUpdate.newCameraPosition(
                    //         CameraPosition(target: LatLng(controller
                    //             .currentLocation?.latitude ?? 0, controller
                    //             .currentLocation?.longitude ?? 0),zoom: 14)));
                    // controller.update();
                  },
                  myLocationButtonEnabled: true,
                  markers: {
                    Marker(
                        rotation: controller.markerRotation,


                        markerId: MarkerId("source"),
                        position: LatLng(
                            driverHomeController
                                .currentLocation!.latitude!,
                            driverHomeController
                                .currentLocation!.longitude!),
                        icon: controller.userIcon),

                  },
                  polylines: {
                    if (controller.isDriving)
                      Polyline(
                          polylineId: PolylineId("route"),
                          color: Colors.blueAccent,
                          width: 6,
                          points: controller.polylineCoordinates)
                  },
                ),

                Padding(
                  padding: AppSizes.DEFAULT,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              // await controller.getPolyLinePoints();
                              controller.update();
                              controller.isDriving =
                              !controller.isDriving;

                              if (controller.isDriving) {
                                controller.startDrivingTime = DateTime.now();

                                controller.setStartLocation(context: context);
                                _phoneUsageDriverController.startTimer();
                              }
                              else {
                                controller.startLocation = null;
                                controller.polylineCoordinates.clear();
                                _phoneUsageDriverController.cancelTimer();
                              }
                            },
                            child: Container(
                              height: 48,
                              padding:
                              EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: controller.isDriving
                                    ? Colors.green
                                    : kPrimaryColor,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  AppStyling.customShadow,
                                ],
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    Assets.imagesLocationIcon,
                                    height: 18,
                                  ),
                                  MyText(
                                    text: controller.isDriving
                                        ? 'Check Out'
                                        : "Check In",
                                    size: 14,
                                    color: kSecondaryColor,
                                    paddingLeft: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Container(
                          //   height: 48,
                          //   width: 48,
                          //   decoration: BoxDecoration(
                          //     color: kPrimaryColor,
                          //     shape: BoxShape.circle,
                          //     boxShadow: [
                          //       AppStyling.customShadow,
                          //     ],
                          //   ),
                          //   child: Center(
                          //     child: Image.asset(
                          //       Assets.imagesLayer,
                          //       height: 20,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
                : Container(
                height: Get.height,
                width: Get.width,
                child: Center(
                  child: CircularProgressIndicator(),
                ));
          },
        ));
  }
}
