import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lanefocus/controller/auth_controller/auth_controller.dart';
import 'package:lanefocus/controller/general_controller.dart';

import 'package:lanefocus/core/constants/instance_collections.dart';
import 'package:lanefocus/core/constants/instance_constants.dart';
import 'package:lanefocus/core/utils/dialogs.dart';
import 'package:lanefocus/model/user/user_model.dart';
import 'package:lanefocus/services/local_storage/local_storage_service.dart';
import 'package:lanefocus/view/screens/auth/login/login.dart';

import 'package:lanefocus/utils/global_instances.dart';


import '../../core/constants/firebase_constants.dart';
import '../../core/utils/snackbar.dart';
import 'firebase_crud_services.dart';

class FirebaseAuthService {
  FirebaseAuthService._privateConstructor();

  //singleton instance variable
  static FirebaseAuthService? _instance;
  final _auth = FirebaseConstants.auth;

  //This code ensures that the singleton instance is created only when it's accessed for the first time.
  //Subsequent calls to ValidationService.instance will return the same instance that was created before.

  //getter to access the singleton instance
  static FirebaseAuthService get instance {
    _instance ??= FirebaseAuthService._privateConstructor();
    return _instance!;
  }

  Future<(User?, GoogleSignInAccount?, bool)> authWithGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // TODO: Use the `credential` to sign in with Firebase.
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (FirebaseAuth.instance.currentUser == null) {
        return (null, null, false);
      }

      if (FirebaseAuth.instance.currentUser != null) {
        User user = FirebaseAuth.instance.currentUser!;

        //checking if the user's account already exists on firebase
        bool isExist = await FirebaseCRUDServices.instance.isDocExist(
            collectionReference: FirebaseConstants.userCollectionReference,
            docId: user.uid);

        return (user, googleUser, isExist);
      }
    } on FirebaseAuthException catch (e) {
      //showing failure snackbar
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Authentication Error', message: '${e.message}');

      return (null, null, false);
    } on FirebaseException catch (e) {
      //showing failure snackbar
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Authentication Error', message: '${e.message}');

      return (null, null, false);
    } catch (e) {
      log("This was the exception while signing up: $e");

      return (null, null, false);
    }

    return (null, null, false);
  }

  //signing up user with email and password
  Future<User?> signUpUsingEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await FirebaseConstants.auth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (FirebaseAuth.instance.currentUser != null) {
        User user = FirebaseAuth.instance.currentUser!;

        return user;
      }
      if (FirebaseAuth.instance.currentUser == null) {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      //showing failure snackbar
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Authentication Error', message: '${e.message}');

      return null;
    } on FirebaseException catch (e) {
      //showing failure snackbar
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Authentication Error', message: '${e.message}');

      return null;
    } catch (e) {
      log("This was the exception while signing up: $e");

      return null;
    }

    return null;
  }

  sendPasswordResetEmail({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      await Future.delayed(
          Duration(seconds: 2),
          () => CustomSnackBars.instance.showSuccessSnackbar(
              title: 'Email sent',
              message: 'An email has been sent to you to reset your password'));
      // timerButtonVisible.value = false;
      // timer = Timer.periodic(Duration(seconds: 1), (val) {
      //   if (timerCount.value == 0) {
      //     timer?.cancel();
      //     timerButtonVisible.value = true;
      //     timerCount.value = 30;
      //     // Get.back();
      //   } else {
      //     timerCount.value--;
      //   }
      // });
    } on FirebaseAuthException catch (e) {
      print(e.message);
      CustomSnackBars.instance
          .showFailureSnackbar(title: 'Error', message: e.message.toString());
    }
  }

 /* Future<void> deleteUserAccount() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
      CustomSnackBars.instance.showSuccessSnackbar(
        title: "Done",
        message: "Account Deleted Suucessfully",
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        await reAuthenticateAndDelete();
      } else {
        // Handle other Firebase exceptions
      }
    } catch (e) {
      throw Exception(e);

      // Handle general exception
    }
  }*/


  //method to change Firebase password
  Future<bool> changeFirebasePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(email: email, password: oldPassword);

    try {
      // Reauthenticate user
      await user!.reauthenticateWithCredential(cred);

      // Update password
      await user.updatePassword(newPassword);

      log('Password updated successfully');
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          CustomSnackBars.instance
              .showFailureSnackbar(title: 'Error', message: 'User not found');
          break;
        case 'wrong-password':
          CustomSnackBars.instance
              .showFailureSnackbar(title: 'Error', message: 'Wrong password');
          break;
        case 'invalid-email':
          CustomSnackBars.instance
              .showFailureSnackbar(title: 'Error', message: 'Invalid email');
          break;
        case 'email-already-in-use':
          CustomSnackBars.instance.showFailureSnackbar(
              title: 'Error', message: 'Email already in use');
          break;
        default:
          CustomSnackBars.instance.showFailureSnackbar(
              title: 'Retry', message: 'Something went wrong');
          break;
      }
      return false;
    } catch (e) {
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Error', message: 'An unknown error occurred: $e');
      return false;
    }
  }



  Future<void> reAuthenticateAndDelete({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    DialogService.instance.showProgressDialog(context: context);
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      final providerData = currentUser?.providerData.first;

      if (currentUser == null || providerData == null) {
        DialogService.instance.hideLoading();
        throw Exception("User not found");
      }

     if (GoogleAuthProvider().providerId == providerData.providerId) {
         await currentUser.reauthenticateWithProvider(GoogleAuthProvider());
         await usersCollection.doc(userModelGlobal.value!.userId).delete();
         DialogService.instance.hideLoading();
         await currentUser.delete();
         await LocalStorageService.instance.deleteKey(key: 'email');

         Get.offAll(()=>Login());
      } else if (EmailAuthProvider.PROVIDER_ID == providerData.providerId) {
        final credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        UserCredential result = await currentUser.reauthenticateWithCredential(credential);
        await usersCollection.doc(userModelGlobal.value!.userId).delete();
        DialogService.instance.hideLoading();
        await result.user!.delete();
        await LocalStorageService.instance.deleteKey(key: 'email');
        Get.offAll(()=>Login());
      } else {
        throw Exception("Unsupported authentication provider");
      }



      // await currentUser.delete();

      CustomSnackBars.instance.showSuccessSnackbar(
          title: "Done", message: "Account Deleted Successfully");

    } catch (e) {
      CustomSnackBars.instance.showFailureSnackbar(
          title: "Error", message: "Failed to delete account: $e");
    }
  }


  Future<UserCredential> signInUsingEmailAndPassword(
      String email, String password) async {
    try {
      return await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      log("error: ${e}");
      if (e.code == 'invalid-email') {
        throw FirebaseAuthException(
            code: 'invalid-email',
            message: 'The email address is badly formatted.');
      } else if (e.code == 'user-not-found') {
        throw FirebaseAuthException(
            code: 'user-not-found',
            message:
                'Sorry, we couldn\'t find an account with that email address. Please check your email or sign up for a new account');
      } else if (e.code == 'wrong-password') {
        throw FirebaseAuthException(
            code: 'invalid-credentials',
            message: 'The email or password is incorrect.');
      } else {
        rethrow; // Rethrow the original exception for cases not explicitly handled
      }
    }
  }

  Future<void> sendOtpToPhoneNumber({
    required String phoneNumber,
    required String dialCode,
    required Function onSuccess,
    required Function onFailed,
  }) async {
    try {
      AuthController authController = Get.find<AuthController>();
      await _auth
          .verifyPhoneNumber(

        timeout: Duration(seconds: 90),
        verificationCompleted:
            (PhoneAuthCredential phoneAuthCredential) async {},
        verificationFailed: (FirebaseAuthException error) async {
          CustomSnackBars.instance
              .showFailureSnackbar(title: 'Error', message: '${error.message}');
          authController.isLoading.value = false;
          onFailed();
        },
        codeSent:
            await (String verificationId, int? forceResendingToken) async {
          authController.verificationId.value = verificationId;
          log('Code Sent');
          authController.isLoading.value = false;
          onSuccess();
        },
        codeAutoRetrievalTimeout: (String verificationId) async {},
        phoneNumber: '$dialCode$phoneNumber',
      )
          .onError((error, stackTrace) {
        CustomSnackBars.instance
            .showFailureSnackbar(title: 'Error', message: 'OTP sending failed');
      });
    } on FirebaseException catch (_) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: 'Error', message: 'OTP sending failed');
    } catch (_) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: 'Error', message: 'OTP sending failed');
    }
  }

  Future<String?> linkPhoneNumberWithEmail(
      String verificationId, String otp, String email, String password) async {
    try {
      print("linkPhoneNumberWithEmail Called");
      await FirebaseAuth.instance.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: otp));
      final credential =
          EmailAuthProvider.credential(email: email, password: password);

      UserCredential? creds = await FirebaseAuth.instance.currentUser!
          .linkWithCredential(credential);
      User user = creds.user!;

      if (user.uid.isNotEmpty) {
        return user.uid;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      CustomSnackBars.instance
          .showFailureSnackbar(title: 'Error', message: '${e.message} ');
      return null;
    } on FirebaseException catch (e) {
      log(e.toString());
      CustomSnackBars.instance
          .showFailureSnackbar(title: 'Error', message: '${e.message} ');
      return null;
    } catch (e) {
      log(e.toString());
      CustomSnackBars.instance
          .showFailureSnackbar(title: 'Error', message: '${e} ');
      return null;
    }
  }

  /// Read Some Documents (Snapshot)
  Future<QuerySnapshot<Map<String, dynamic>>> getDocumentsByKey(
      {required CollectionReference<Map<String, dynamic>> collection,
      required searchKey,
      required value}) {
    return collection.where(searchKey, isEqualTo: value).get();
  }

//method to check if the user's account already exists on firebase
// Future<bool> isAlreadyExist({required String uid}) async {
//   bool isExist = await FirebaseCRUDService.instance
//       .isDocExist(collectionReference: usersCollection, docId: uid);
//
//   return isExist;
// }


  Future<void> deleteUserAccount(String email,password,BuildContext context) async {

    try {

      await FirebaseAuth.instance.currentUser!.delete();
      await usersCollection.doc(userModelGlobal.value!.userId).delete();
      await LocalStorageService.instance.deleteKey(key: 'email');
      CustomSnackBars.instance.showSuccessSnackbar(
        title: "Done",
        message: "Account Deleted Suucessfully",
      );

      Get.offAll(()=>Login());

      DialogService.instance.hideLoading();
    } on FirebaseAuthException catch (e) {

      if (e.code == "requires-recent-login") {
         await reAuthenticateAndDelete(email: email, password: password,context: context);
      } else {
        DialogService.instance.hideLoading();

        // Handle other Firebase exceptions
      }
    } catch (e) {
      DialogService.instance.hideLoading();
      print("Exception for deleet = $e");
      throw Exception(e);

      // Handle general exception
    }
  }








}
