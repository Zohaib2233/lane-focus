import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_fonts.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/controller/alert_controller/alert_controller.dart';
import 'package:lanefocus/core/constants/instance_constants.dart';
import 'package:lanefocus/core/utils/snackbar.dart';
import 'package:lanefocus/main.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:lanefocus/view/widget/alert_card_widget.dart';
import 'package:lanefocus/view/widget/alert_dialog.dart';
import 'package:lanefocus/view/widget/contact_list.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';

import '../../../../../model/notifications/notification_model.dart';

class AdminAlert extends StatefulWidget {


   AdminAlert({super.key});

  @override
  State<AdminAlert> createState() => _AdminAlertState();
}

class _AdminAlertState extends State<AdminAlert> {
  AlertController alertController = Get.find<AlertController>();

  @override
  void initState() {
    alertController.getContacts();
    alertController.fetchNotifications();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Scaffold(
          floatingActionButton: FloatingActionButton(onPressed: (){
            if(alertController.localEmergencyContactList.isEmpty){
              CustomSnackBars.instance.showFailureSnackbar(title: 'Ohh No Contacts', message: 'Please add contacts');
              return;
            }
            Get.dialog(
              AlertDialogWidget()
            );
          },child: MyText(text: 'Alert',color: kPrimaryColor,),),
          appBar: AppBar(
            titleSpacing: 20,
            title: MyText(
              onTap: (){
                log('token:${alertController.tokens.length}');
              },
              text: 'Alerts',
              size: 18,
              weight: FontWeight.w600,
              fontFamily: AppFonts.SPLINE_SANS,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
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
          body: ListView(
            padding: AppSizes.DEFAULT,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                    Get.to(()=> ContactList());
                    },
                    child: Image.asset(
                      Assets.imagesAddBg,
                      height: 40,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MyText(
                          text: 'Add emergency contacts',
                          size: 16,
                          weight: FontWeight.w500,
                          paddingBottom: 1,
                        ),
                        Obx(
                          ()=> MyText(
                            text: alertController.isLoad.value == true? '00 Contacts': '${alertController.matchedContacts.length.toString()} Contacts ',
                            size: 11,
                            color: kQuaternaryColor,
                            paddingBottom: 10,
                          ),
                        ),
                        Container(
                          height: 1,
                          color: kInputBorderColor,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Obx(
                    () => alertController.notificationList.isNotEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: alertController.notificationList.length,
                  itemBuilder: (context, index) {
                    NotificationModel notification =
                    alertController.notificationList[index];
                    String relativeTime = timeago.format(notification.date!,locale: 'en_short');
                    log('relative time:${relativeTime}');
        
                    return AlertCard(
                      image: Assets.imagesBell,
                      title: notification.title,
                      alertText: notification.body,
                      time: relativeTime == 'now'? relativeTime: '${relativeTime} ago',
                      onRemove: () {
                        // Handle remove action
                      },
                    );
                  },
                )
                    : Center(child: Text('No Alerts')),
              ),

             /* ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
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
                        index == 0 ? 1 : 2,
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
              ),*/
            ],
          ),
        ),
      ],
    );
  }
}
