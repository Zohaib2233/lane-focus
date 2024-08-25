// Dynamic link service:
// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/controller/home_controller/circle_controller.dart';
import 'package:lanefocus/core/bindings/bindings.dart';
import 'package:lanefocus/core/constants/instance_collections.dart';
import 'package:lanefocus/core/constants/instance_constants.dart';
import 'package:lanefocus/core/utils/snackbar.dart';
import 'package:lanefocus/model/user/invite_model.dart';
import 'package:lanefocus/model/user/user_model.dart';
import 'package:lanefocus/services/firebaseServices/firebase_crud_services.dart';
import 'package:lanefocus/view/screens/admin/admin_nav_bar/admin_nav_bar.dart';
import 'package:lanefocus/view/screens/auth/sign_up/sign_up.dart';

class DynamicLinkService {
  static Future<Uri> createDynamicLink({required String cID}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://lanefocuss.page.link',
      link: Uri.parse('https://lanefocuss.page.link/listPreview?cId=$cID'),
      androidParameters: const AndroidParameters(
        packageName: 'com.example.lanefocus',
        minimumVersion: 1,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.example.lanefocus',
        minimumVersion: '0',
      ),
    );
    final link = await FirebaseDynamicLinks.instance.buildLink(parameters);


    return link;
  }

  ///THIS WILL INITIALIZE DYNAMIC LINKS AND ALSO HANDLE THE TWO CASES FOR DYNMAIC LINKS
  ///1) WHEN APP IS IN TERMINATED STATE.
  ///2) WHEN APP IS IN BACKGROUND OR FOREGROUND
  static Future<void> initDynamicLink() async {
    log("init links:nk}");

    ///2) wHEN APP IS IN BACKGROUND OR FOREGROUND
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) async {
      final circleController = Get.find<CircleController>();
      if (dynamicLink.link != Uri.parse("uri")) {
        Map queryMap = dynamicLink.link.queryParameters;
        String cId = queryMap['cId'];

        if (auth.currentUser != null) {
          var snapshot = await FirebaseCRUDServices.instance.readSingleDoc(
              collectionReference: usersCollection,
              docId: auth.currentUser!.uid);
          if (snapshot != null) {
            UserModel user =
                UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
            if (user.role == 'admin') {
              DocumentSnapshot? invitesSnapshot = await FirebaseCRUDServices.instance.readSingleDoc(collectionReference: invitesCollection, docId: cId);
              if(invitesSnapshot!=null){

                InviteModel inviteModel = InviteModel.fromMap(invitesSnapshot.data() as Map<String,dynamic>);

                if(inviteModel.ownerId == auth.currentUser!.uid){

                  CustomSnackBars.instance.showFailureSnackbar(title: "Failed", message: "You already admin of The Family");

                  Get.offAll(()=>AdminNavBar(),binding: AdminHomeBindings());

      }
                else{
                  await auth.signOut();

                  Get.offAll(SignUp(
                    fromLink: true,
                    cId: cId,
                  )); //send dynamic link optional param
                  CustomSnackBars.instance.showFailureSnackbar(
                      title: 'Attention!',
                      message:
                      'Please use another email to continue as a member of any circle');
                }

              }



            } else {
              await circleController.addMember(cId, auth.currentUser!.uid);
              //go to circle
            }
          } else {
            await auth.currentUser?.delete();

            Get.offAll(SignUp(
              fromLink: true,
              cId: cId,
            )); //send dynamic link optional param
          }
        } else {
          Get.offAll(SignUp(
            fromLink: true,
            cId: cId,
          )); //send dynamic link optional param
        }
      }
    }).onError((error) {
      debugPrint("error from dynamic link Stream : : :: ${error.toString()}");
    });
  }
}
