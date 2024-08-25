import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/controller/alert_controller/alert_controller.dart';
import 'package:lanefocus/core/utils/snackbar.dart';

import '../../core/constants/instance_constants.dart';

class AlertDialogWidget extends StatelessWidget {
  AlertController alertController = Get.find<AlertController>();
   AlertDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Alert'),
      content: TextField(
        controller: alertController.alertController,
        decoration: InputDecoration(
          labelText: 'Enter alert message',
        ),
      ),
      actions: [
        ElevatedButton(
          child: Text('Send Alert'),
          onPressed: () async {
            /// Add code here to send alert

            if(alertController.alertController.text.isEmpty){
              CustomSnackBars.instance.showToast(message: 'Please enter alert message');
              return;
            }
            Navigator.of(context).pop();
          //  log('tokens:${alertController.tokens.toJson().toString()}');
            await alertController.getTokensForEmergencyContacts(alertController.localEmergencyContactList,auth.currentUser!.uid);
          // await alertController.sendNotificationToMultipleUsers(alertController.tokens);


          },
        ),
      ],
    );
  }
}
