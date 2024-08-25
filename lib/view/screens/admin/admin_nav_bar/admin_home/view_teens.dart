import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:lanefocus/model/user/circle_model.dart';

import '../../../../../core/constants/instance_collections.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../main.dart';
import '../../../../../model/user/user_model.dart';
import '../../../../../services/googleMap/google_map.dart';
import '../../../../widget/my_text_widget.dart';
import '../../../../widget/user_profile_tile_widget.dart';
import '../../other_user_profile/other_user_profile.dart';

class ViewTeens extends StatelessWidget {
  final CircleModel circleModel;
  const ViewTeens({super.key, required this.circleModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(
          text: "${circleModel.name} Teens",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: circleModel
                .members
                ?.length ??
                0,
            itemBuilder: (context, index) {
              var address = <Placemark>[].obs;


              if (circleModel
                  .members!.isEmpty) {
                print("Member Empty");
                return Center(
                  child: MyText(
                    text: "No Member Added",
                  ),
                );
              } else {
                return StreamBuilder(
                  stream: usersCollection
                      .doc(circleModel.members![index])
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
                          time:
                          'Since ${Utils.formatDateTimetoTime(userModel.drivingModel?.drivingSince??DateTime.now())}',
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
            }),
      ),
    );
  }
}
