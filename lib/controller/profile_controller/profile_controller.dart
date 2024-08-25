import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:lanefocus/services/firebaseServices/firebase_auth_service.dart';
import 'package:lanefocus/view/widget/password_dialog.dart';

import '../../core/constants/instance_collections.dart';
import '../../core/constants/instance_constants.dart';
import '../../core/enums/network_status.dart';
import '../../core/global/functions.dart';
import '../../core/utils/dialogs.dart';
import '../../core/utils/snackbar.dart';
import '../../model/user/user_model.dart';
import '../../services/local_storage/local_storage_service.dart';
import '../../utils/network_connectivity.dart';

class ProfileController extends GetxController{

  @override
  void onInit() async{
  // await getProfileDataFromFirestore();
    super.onInit();
  }



  /// use these ctrl to change password

  TextEditingController currentPassword =TextEditingController();
  TextEditingController newPassword =TextEditingController();
  TextEditingController repeatNewPassword =TextEditingController();
  TextEditingController delPassword =TextEditingController();

  final changePassKey = GlobalKey<FormState>();


  /// get the data of user from firestore

  Future<void> getProfileDataFromFirestore() async{
    // DialogService.instance.showProgressDialog(context: context);

    /// Check internet connectivity
    final networkStatus = await NetworkConnectivity.instance.getNetworkStatus();
    if (networkStatus == NetworkStatus.offline) {
      Get.back();
      CustomSnackBars.instance.showFailureSnackbar(title: 'Warning', message: 'No internet connection');
      return;
    }

    DocumentSnapshot<Object?>? snapshot = await readSingleDocument(collectionReference: usersCollection,
        docId: FirebaseAuth.instance.currentUser!.uid);
    if(snapshot?.data() == null){
      Get.back();
      CustomSnackBars.instance.showFailureSnackbar(title: 'Oh Snap', message: 'Something went wrong');
      return;
    }
    userModelGlobal.value = UserModel.fromJson(snapshot!.data() as Map<String,dynamic>);

  }



  /// these bool used password and
  /// repeat password fields of [SignUp] screen

  RxBool isObSecurePass = true.obs;
  RxBool isObSecureRepeatPass = true.obs;

  /// used on obscure icon of password field
  togglePassword() {
    isObSecurePass.value = !isObSecurePass.value;
  }

  /// used on obscure icon of repeat password field
  toggleRepeatPassword() {
    isObSecureRepeatPass.value = !isObSecureRepeatPass.value;
  }


  RxBool isLoad = false.obs;

  /// this

  Future<bool> changesPassword(BuildContext context) async {
    try {
      /// Check internet connectivity
      final networkStatus = await NetworkConnectivity.instance.getNetworkStatus();
      if (networkStatus == NetworkStatus.offline) {
        CustomSnackBars.instance.showFailureSnackbar(
            title: 'Warning',
            message: 'No internet connection'
        );
        return false;
      }

      bool isChanged = await FirebaseAuthService.instance.changeFirebasePassword(
        email: userModelGlobal.value!.email.toString(),
        oldPassword: currentPassword.text.trim(),
        newPassword: newPassword.text.trim(),
      );


      return isChanged;
    } catch (e) {
      log('Error: ${e.toString()}');
      return false;
    }
  }
  
  Future<void>  deleteUserAccount(BuildContext context) async {
    Get.back();
    await FirebaseAuthService.instance.
    deleteUserAccount((userModelGlobal.value!.email as String), delPassword.text.trim(),context);
  }

  Future<void> removeUser() async {
    await LocalStorageService.instance.deleteKey(key: 'email');
  }
  clearPassControllers(){
    currentPassword.clear();
    newPassword.clear();
    repeatNewPassword.clear();
  }

  @override
  void onClose() {
    currentPassword.dispose();
    newPassword.dispose();
    repeatNewPassword.dispose();
    delPassword.dispose();
    super.onClose();
  }

}