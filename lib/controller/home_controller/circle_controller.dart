import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lanefocus/controller/home_controller/admin_home_controller.dart';
import 'package:lanefocus/core/constants/instance_collections.dart';
import 'package:lanefocus/core/constants/instance_constants.dart';
import 'package:lanefocus/core/utils/app_strings.dart';
import 'package:lanefocus/core/utils/dialogs.dart';
import 'package:lanefocus/core/utils/snackbar.dart';
import 'package:lanefocus/model/user/circle_model.dart';
import 'package:lanefocus/model/user/invite_model.dart';
import 'package:lanefocus/services/firebaseServices/dynamic_links.dart';
import 'package:lanefocus/services/firebaseServices/firebase_crud_services.dart';
import 'package:lanefocus/services/firebaseServices/firebase_storage_service.dart';
import 'package:lanefocus/view/screens/admin/admin_nav_bar/admin_home/share_invite_link.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/utils.dart';

class CircleController extends GetxController {
  TextEditingController circleNameController = TextEditingController();
  var uuid = Uuid();
  RxString imagePath = ''.obs;
  String imageUrl = dummyProfile;

  createCircle({required BuildContext context}) async {
    String circleId = uuid.v1();

    DialogService.instance.showProgressDialog(context: context);

    if (imagePath.isNotEmpty) {
      imageUrl = await FirebaseStorageService.instance.uploadSingleImage(
          imgFilePath: imagePath.value,
          context: context,
          storageRef: 'circleImage');
    }

    String inviteCode = Utils.generateInviteCode(docId: circleId);
    Uri linkUrl = await DynamicLinkService.createDynamicLink(cID: circleId);

    CircleModel circleModel = CircleModel(
        inviteCode: inviteCode,
        inviteLink: '$linkUrl',
        ownerId: userModelGlobal.value!.userId,
        circleId: circleId,
        imgUrl: imageUrl,
        members: [],
        name: circleNameController.text);

    bool docCreated = await FirebaseCRUDServices.instance.createDocument(
        collectionReference: circlesCollection,
        docId: circleId,
        data: circleModel.toMap(),
        context: context);

    if (docCreated) {
      InviteModel inviteModel = InviteModel(
          circleId: circleId,
          inviteId: circleId,
          inviteCode: inviteCode,
          inviteLink: '$linkUrl',
          ownerId: userModelGlobal.value?.userId ?? '');
      DialogService.instance.hideLoading();

      bool inviteCreated = await FirebaseCRUDServices.instance.createDocument(
          collectionReference: invitesCollection,
          data: inviteModel.toMap(),
          docId: circleId,
          context: context);

      if (inviteCreated) {
        CustomSnackBars.instance.showSuccessSnackbar(
            title: "Success", message: "Family Circle Created");
        Get.find<AdminHomeController>().circlesList.add(circleModel);
        circleNameController.clear();

        Get.off(() => ShareInviteLink(
              link: '$linkUrl',
              code: inviteCode,
            ));
      } else {
        CustomSnackBars.instance.showFailureSnackbar(
            title: "Failed", message: "Circle Not Created");
      }
    }
  }

  addMember(String circleId, String userId) async {
    print("add member method called");

    if (circleId.isNotEmpty) {
      print("add member method called circleId.isNotEmpty");
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await invitesCollection.doc(circleId).get();
      InviteModel inviteModel =
          InviteModel.fromMap(snapshot.data() as Map<String, dynamic>);

      print("invite Model = ${inviteModel.toMap()}");

      await usersCollection.doc(auth.currentUser!.uid).update({
        'circlesJoined':FieldValue.arrayUnion([circleId]),
        'circlesAdmin':FieldValue.arrayUnion([inviteModel.ownerId]),
      });
      await usersCollection
          .doc(inviteModel.ownerId)
          .collection("circles")
          .doc(circleId)
          .update({
        "members": FieldValue.arrayUnion([userId])
      });
    }
  }

  pickImage({bool isThroughCamera = true}) async {
    if (isThroughCamera) {
      imagePath.value =
          await FirebaseStorageService.instance.pickImageFromCamera();
    } else {
      imagePath.value =
          await FirebaseStorageService.instance.pickImageFromGallery();
    }
  }
}
