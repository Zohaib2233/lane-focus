import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/controller/alert_controller/alert_controller.dart';
import 'package:lanefocus/core/constants/instance_collections.dart';
import 'package:lanefocus/core/constants/instance_constants.dart';
import 'package:lanefocus/core/utils/snackbar.dart';
import 'package:lanefocus/services/firebaseServices/firebase_crud_services.dart';
import '../../constants/app_fonts.dart';
import 'my_text_widget.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  late AlertController alertController;

  @override
  void initState() {
     alertController = Get.find<AlertController>();
    // alertController.getContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: MyText(
          text: 'Contacts',
          size: 18,
          weight: FontWeight.w600,
          fontFamily: AppFonts.SPLINE_SANS,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
        ),
      ),
      body: Obx(
            () => alertController.isLoad.value == true
            ? Center(child: CircularProgressIndicator())
            : alertController.matchedContacts.length ==0? Center(child: MyText(text: 'No Contacts Found')): ListView.builder(
          itemCount: alertController.matchedContacts.length,
          itemBuilder: (context, index) {
            final contact = alertController.matchedContacts[index];
            log('matched:${alertController.matchedContacts}');
            final phone = contact.phones.isNotEmpty
                ? contact.phones[0].normalizedNumber
                : 'No phone number';

            return Obx(
                ()=> Card(
                child: ListTile(
                  title: MyText(
                    text: contact.displayName.toString(),
                  ),
                  subtitle: MyText(
                    text: phone,
                  ),
                  trailing: alertController.localEmergencyContactList.contains(phone) ? IconButton(onPressed: () async {
                    alertController.localEmergencyContactList.remove(phone);
                   bool isUpdated = await FirebaseCRUDServices.instance.updateDocumentSingleKey(
                        collection: usersCollection, docId: userModelGlobal.value!.userId.toString(),
                        key: 'emergencyContacts', value: alertController.localEmergencyContactList);
                   if(isUpdated){
                     CustomSnackBars.instance.showSuccessSnackbar(title: 'Emergency Contact', message: 'Emergency contact removed');
                     log('updated');
                   }else{
                     alertController.localEmergencyContactList.remove(phone);
                     CustomSnackBars.instance.showFailureSnackbar(title: 'ohh', message: 'Emergency contact is not removed');
                   }
                  }, icon:Icon(Icons.remove)):IconButton(onPressed: () async {
                    alertController.localEmergencyContactList.add(phone);
                 bool isUpdated =   await FirebaseCRUDServices.instance.updateDocumentSingleKey(
                        collection: usersCollection, docId: userModelGlobal.value!.userId.toString(),
                        key: 'emergencyContacts', value: alertController.localEmergencyContactList);
                 if(isUpdated){
                   CustomSnackBars.instance.showSuccessSnackbar(title: 'Emergency Contact', message: 'Emergency contact added');
                 }else{
                   CustomSnackBars.instance.showFailureSnackbar(title: 'ohh', message: 'Emergency contact is not added');
                 }

                  }, icon:Icon(Icons.add)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
