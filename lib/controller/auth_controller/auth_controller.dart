// ignore_for_file: unused_catch_clause

import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lanefocus/core/bindings/bindings.dart';
import 'package:lanefocus/controller/general_controller.dart';
import 'package:lanefocus/controller/home_controller/circle_controller.dart';
import 'package:lanefocus/core/constants/constants.dart';
import 'package:lanefocus/core/constants/instance_collections.dart';
import 'package:lanefocus/core/constants/instance_constants.dart';
import 'package:lanefocus/core/global/functions.dart';
import 'package:lanefocus/core/utils/dialogs.dart';
import 'package:lanefocus/core/utils/snackbar.dart';
import 'package:lanefocus/model/user/invite_model.dart';
import 'package:lanefocus/model/user/user_model.dart';
import 'package:lanefocus/services/firebaseServices/firebase_crud_services.dart';
import 'package:lanefocus/services/firebaseServices/firebase_storage_service.dart';
import 'package:lanefocus/services/local_storage/local_storage_service.dart';
import 'package:lanefocus/services/shared_preferences_services.dart';
import 'package:lanefocus/view/screens/admin/admin_nav_bar/admin_nav_bar.dart';
import 'package:lanefocus/view/screens/auth/complete_profile/name.dart';
import 'package:lanefocus/view/screens/auth/login/login.dart';
import 'package:lanefocus/view/screens/auth/sign_up/sign_up.dart';
import 'package:lanefocus/view/screens/driver/driver_nav_bar/driver_nav_bar.dart';
import 'package:lanefocus/view/screens/auth/sign_up/sign_up_otp.dart';
import 'package:lanefocus/view/screens/driver/driver_nav_bar/driver_profile/driver_profile.dart';
import 'package:lanefocus/view/widget/alert_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/constants/firebase_constants.dart';
import '../../core/enums/location_permission.dart';
import '../../core/enums/network_status.dart';
import '../../services/firebaseServices/firebase_auth_service.dart';
import '../../services/notificationService/local_notification_service.dart';
import '../../services/permissionsService/permissions.dart';
import '../../utils/network_connectivity.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find<AuthController>();
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService.instance;
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  final fName = TextEditingController(),
      lName = TextEditingController(),
      codeController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool signupLoading = false.obs;





  RxBool isObSecurePass = true.obs;
  RxBool isObSecureRepeatPass = true.obs;

  SharedPreferenceService _sharedPreferenceService =
      SharedPreferenceService.instance;

  RxInt currentRole = 0.obs;

  DateTime dob = DateTime(2000);
  var imgPath = ''.obs, role = 'admin'.obs, signupMethod = 'email'.obs;
  RxString verificationId = ''.obs;

  RxBool isRememberMe = false.obs;
  RxBool isAuth = false.obs;

  /// use to validate sign_up form

  final signUpFormKey = GlobalKey<FormState>();

  togglePassword() {
    isObSecurePass.value = !isObSecurePass.value;
  }


  /// used on obscure icon of repeat password field
  toggleRepeatPassword() {
    isObSecureRepeatPass.value = !isObSecureRepeatPass.value;
  }

  Future<void> signUp(
      BuildContext context, String cId, bool isCodeCorrect) async {

    try {
      /// start loading

      /// check internet connectivity
      final networkStatus =
          await NetworkConnectivity.instance.getNetworkStatus();
      if (networkStatus == NetworkStatus.offline) {
        DialogService.instance.hideLoading();
        CustomSnackBars.instance.showFailureSnackbar(
            title: 'Warning', message: 'No internet connection');
        return;
      }

      await FirebaseAuthService.instance.signUpUsingEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());


      if (codeController.text.trim().isNotEmpty &&
          cId.isNotEmpty &&
          isCodeCorrect == true) {
        await Get.find<CircleController>()
            .addMember(cId, auth.currentUser!.uid);
      }
    } catch (e) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: 'Oh Snap!', message: e.toString());
      // UIHelper.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// use to clear ctrls when
  /// user go back to change the role
  /// this [clearSignUpControllers] used
  /// in back button of [SignUp] screen

  clearSignUpControllers() {
    emailController.clear();
    passwordController.clear();
    repeatPasswordController.clear();
  }

  /// these [TextEditingController] used in [Login] screen

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  /// used on obscure icon of password field
  /// of [Login] screen
  RxBool loginIsObSecurePass = true.obs;

  /// use to validate sign_in form

  final signInFormKey = GlobalKey<FormState>();

  ///  used on obscure button of
  /// password field of [Login] screen

  loginTogglePassword() {
    loginIsObSecurePass.value = !loginIsObSecurePass.value;
  }

  /// this [signIn] use in signIn button
  /// of [Login] screen

  Future<void> signIn(BuildContext context) async {
    try {
      DialogService.instance.showProgressDialog(context: context);

      /// Start loading

      /// Check internet connectivity
      final networkStatus =
          await NetworkConnectivity.instance.getNetworkStatus();
      if (networkStatus == NetworkStatus.offline) {
        DialogService.instance.hideLoading();
        CustomSnackBars.instance.showFailureSnackbar(
            title: 'Warning', message: 'No internet connection');
        DialogService.instance.hideLoading();
        return;
      }

      /// Login user
      final user =
          await FirebaseAuthService.instance.signInUsingEmailAndPassword(
        loginEmailController.text.trim(),
        loginPasswordController.text.trim(),
      );

      /// Stop loading
      DialogService.instance.hideLoading();

      /// Check the result and navigate accordingly
      if (user.user != null) {
        getUserDataStream(userId: user.user!.uid);
        String? deviceToken = await LocalNotificationService.instance.getDeviceToken();
        if(deviceToken != null){
        bool isUpdate =  await FirebaseCRUDServices.instance.updateDocumentSingleKey(collection: usersCollection, docId:auth.currentUser!.uid , key: 'token', value: deviceToken);
        log('isUpdate:${isUpdate}');
        }
        CustomSnackBars.instance.showSuccessSnackbar(
          title: 'Congratulations',
          message: 'Login successfully',
        );
        // Get.offAll(() => AdminNavBar(),binding: AdminHomeBindings());

        Future.delayed(Duration.zero).then((_) {
          /// navigate user
          getUserDataStream(userId: user.user!.uid);
          navigateUser(userModelGlobal.value!.role.toString());
          loginEmailController.clear();
          loginPasswordController.clear();

          log('data of user:${userModelGlobal.value?.userId}');
        });
      } else {
        Get.off(() => SignUp());
      }
    } on FirebaseAuthException catch (e) {
      log('error:${e.message.toString()}');
      DialogService.instance.hideLoading();
      CustomSnackBars.instance.showFailureSnackbar(
        title: 'Error',
        message: e.message.toString(),
      );
    } catch (e) {
      DialogService.instance.hideLoading();
      log('error:${e.toString()}');
      CustomSnackBars.instance.showFailureSnackbar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
    }
  }



  /// use to navigate user

  void navigateUser(String role) {
    if (role == driver) {
      Get.offAll(() => DriverNavBar(), binding: DriverHomeBinding());

    } else {
      Get.offAll(() => AdminNavBar(), binding: AdminHomeBindings());
    }
  }

  clearSignInControllers() {
    loginPasswordController.clear();
    loginEmailController.clear();
  }

  void updateRole(int index) {
    currentRole.value = index;
  }

  //signin with google
  signinwithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      UserCredential cred;
      cred = await FirebaseAuth.instance.signInWithCredential(credential);
      // store user in collection for 1st time
      DialogService.instance.showProgressDialog(context: context);
      DocumentSnapshot snapshot =
          await usersCollection.doc(cred.user!.uid).get();
      signupMethod.value = 'google';
      //if user data exists in firestore
      if (snapshot.exists) {
        getUserDataStream(userId: cred.user!.uid);
        DialogService.instance.hideLoading();
        //if profile is complete
        log("on baord comp : ${userModelGlobal.value?.toJson()}");
        if (userModelGlobal.value?.onBoardComp == true) {
          if (userModelGlobal.value?.role == "admin") {
            Get.offAll(const AdminNavBar(), binding: AdminHomeBindings());
          } else {
            Get.offAll(const DriverNavBar(), binding: DriverHomeBinding());
          }
        } else {
          Get.offAll(Name());
        }
      } else {
        Get.offAll(Name());
      }
    } on SocketException catch (e) {
      DialogService.instance.hideLoading();

      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Error',
          message: 'No internet connection. Please reconnect and try again.');
    } on FirebaseAuthException catch (e) {
      //showing failure snackbar
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Authentication Error', message: '${e.message}');

      return null;
    } catch (e) {
      DialogService.instance.hideLoading();
    }
  }

  // saveUserData(email, dob, String firstName, String lastName, String imgPath,
  //     String role, String signupMeth, BuildContext context) async {
  //   if (firstName.isEmpty) firstName = fName.text;
  //   if (lastName.isEmpty) lastName = lName.text;

  saveUserData(
      email,
      dob,
      String fName,
      String lName,
      String imgPath,
      String role,
      String signupMeth,
      String phone,
      BuildContext context) async {
    final _generalCtrl = Get.find<GeneralController>();
    UserModel user = UserModel(
      userId: auth.currentUser!.uid,
      email: email,
      phone: _generalCtrl.phoneNumberDialCode.value+phone,
      role: role,
      fullName: '$fName $lName',
      signupMethod: signupMeth,
      joinedOn: DateTime.now(),
      dob: dob,
      isOnline: true,
      onBoardComp: true,
    );

    if (imgPath.isNotEmpty) {
      String downloadUrl = await FirebaseStorageService.instance
          .uploadSingleImage(imgFilePath: imgPath, context: context);
      if (downloadUrl.isNotEmpty) {
        user.profileImg = downloadUrl;
        log('profile_picture:${user.profileImg.toString()}');
      }
    }

    bool isCreated = await FirebaseCRUDServices.instance.createDocument(
        collectionReference: usersCollection,
        docId: auth.currentUser!.uid,
        data: user.toJson(),
        context: context);
    if (isCreated) {
      resetParams();
      CustomSnackBars.instance.showSuccessSnackbar(
          title: 'Success!', message: 'Account created successfully.');
    }
  }

  getRememberedEmail() async {
    String? email = await LocalStorageService.instance.read(key: 'email');
    if (email != null) {
      emailController.text = email;
    }
  }

  resetParams() {
    fName.clear();
    lName.clear();
    dob = DateTime(2000);
    signupMethod.value = 'email';
    imgPath.value = '';
  }

  validateCode() async {
    // await FirebaseCRUDServices.instance.get
  }

  Future<void> onSignup({required bool fromLink,required String cId,required BuildContext context}) async {
    if (signUpFormKey.currentState!.validate() &&
        phoneNumberController.text.isNotEmpty) {
      signupLoading(true);

     isLoading(true);

      if (codeController.text.isNotEmpty ) {
        DialogService.showProgressDialog2();
        var snapshot = await FirebaseCRUDServices.instance
            .readSingleDocByFieldName(
                collectionReference: invitesCollection,
                fieldName: 'inviteCode',
                fieldValue: codeController.text.trim());

        if (snapshot != null) {

          InviteModel inviteModel = InviteModel.fromMap(snapshot.data() as Map<String,dynamic>);
          await sendCodeToPhoneNumber(
            onFailed: (){
              signupLoading(false);
              isLoading(false);
            },
              onSuccess: () {
                signupLoading(false);
                isLoading(false);
                DialogService.instance.hideLoading();
                Get.to(() => SignUpOtp(
                      fromLink: true,
                      cId: inviteModel.circleId,
                    ));
              },
              phoneNumber: phoneNumberController.text,
              dialCode:
                  Get.find<GeneralController>().phoneNumberDialCode.value);

          // Get.to(() => SignUpOtp(
          //       fromLink: true,
          //       cId: inviteModel.circleId,
          //       isCodeCorrect: true,
          //     ));
        } else {
          DialogService.instance.hideLoading();
          signupLoading(false);
          isLoading(false);
          CustomSnackBars.instance.showFailureSnackbar(
              title: 'Alert!', message: 'Invalid invite code');
        }
      } else {

        await sendCodeToPhoneNumber(
          onFailed: (){
            signupLoading(false);
            isLoading(false);
          },
            onSuccess: () {
              print("sendCodeToPhoneNumber Success Called");
              isLoading(false);
              signupLoading(false);
              Get.to(() => SignUpOtp(
                    fromLink: fromLink,
                    cId: cId,
                  ));
            },
            phoneNumber: phoneNumberController.text,
            dialCode: Get.find<GeneralController>().phoneNumberDialCode.value);


      }

    } else if (phoneNumberController.text.isEmpty) {
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Phone Number', message: 'Enter a phone number');
    } else {
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Error', message: 'Please fill required fields first');
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await getRememberedEmail();
  }

  @override
  void onClose() {
    fName.dispose();
    lName.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    forgotEmailController.dispose();
    super.onClose();
  }

  Future<void> sendCodeToPhoneNumber(
      {
        required Function onSuccess,
        required Function onFailed,
      required phoneNumber,
      required dialCode}) async {
    log('CODE : ' + dialCode);
    isLoading.value = true;
    try {
      print("sendCodeToPhoneNumber Called");
      await _firebaseAuthService.sendOtpToPhoneNumber(
        onFailed: onFailed,

          phoneNumber: phoneNumber, onSuccess: onSuccess, dialCode: dialCode);
    } catch (e) {
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  Future<void> verifyOtpAndSignin(
      BuildContext context, String id, String otp) async {
    DialogService.instance.showProgressDialog(context: context);
    try {
      print("verifyOtpAndSignin Called");
      userModelGlobal.value?.userId =
          await _firebaseAuthService.linkPhoneNumberWithEmail(
              id, otp, emailController.text, passwordController.text);
      if (userModelGlobal.value?.userId != null) {
        DialogService.instance.hideLoading();
        isAuth.value = true;
        clearSignUpControllers();
      } else {
        DialogService.instance.hideLoading();
        await auth.currentUser?.delete();
        isAuth.value = false;
      }
      DialogService.instance.hideLoading();
    } catch (e) {

      DialogService.instance.hideLoading();
    }
  }

  Future<void> removeUser() async {
    await LocalStorageService.instance.deleteKey(key: 'email');
  }

  Future<bool> isLoggedIn() async {
    final userId =
        await _sharedPreferenceService.getSharedPreferenceString('userId');
    if (userId != null) {
      return true;
    } else {
      return false;
    }
  }

  GlobalKey<FormState> forgetPasswordKey = GlobalKey<FormState>();
  TextEditingController forgotEmailController = TextEditingController();

  /// this [forgotPassword] used in
  /// forgotPassword button in [Login] screen

  void forgotPassword(BuildContext context) async {
    try {
      /// Start loading
      DialogService.instance.showProgressDialog(context: context);

      /// Check internet connectivity
      final networkStatus =
          await NetworkConnectivity.instance.getNetworkStatus();
      if (networkStatus == NetworkStatus.offline) {
        DialogService.instance.hideLoading();
        CustomSnackBars.instance.showFailureSnackbar(
            title: 'Warning', message: 'No internet connection');
        return;
      }

      await forgetPassword(email: forgotEmailController.text.trim());

      DialogService.instance.hideLoading();

      CustomSnackBars.instance.showSuccessSnackbar(
          title: 'Email Sent',
          message: 'Email link sent to reset your password');
      forgotEmailController.clear();

      // Get.to(()=>const CreateNewPass());

      // Check the result and navigate accordingly
    } catch (e) {
      DialogService.instance.hideLoading();
      CustomSnackBars.instance.showFailureSnackbar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
    }
  }

  /// this [signOut] used on
  /// signOut button of [DriverProfile] Screen

  Future<void> signOut() async {
    GoogleSignIn googleSignIn = GoogleSignIn();

    await GoogleSignIn().signOut();
    try {
      await googleSignIn.disconnect();
      await googleSignIn.currentUser!.clearAuthCache();

      log("Google acccount disconnected and signed out");
    } catch (e) {
      log('failed to disconnect on signout');
    }

    await FirebaseAuth.instance.signOut();

    /// remove user from local
    /// storage

    await removeUser();
    // SharedPreferenceService.instance.removeSharedPreferenceBool(SharedPrefKeys.loggedIn);
    if (userModelGlobal.value != null) {
      userModelGlobal.value = UserModel();
    }
    Get.offAll(() => Login());
  }


  Future<void> getBluetoothPermssion() async {
    if (userModelGlobal.value?.bluetoothOn == true) {
      await FirebaseCRUDServices.instance.updateDocumentSingleKey(
          collection: usersCollection,
          docId: auth.currentUser!.uid,
          key: 'bluetoothOn',
          value: false);
    } else {
      BluetoothPermissionStatus status =
          await PermissionService.instance.getBluetoothPermissionStatus();
      if (status == BluetoothPermissionStatus.granted) {
        userModelGlobal.value?.bluetoothOn = true;
      } else if (await Permission.bluetooth.isPermanentlyDenied) {
        openAppSettings();
      } else {
        userModelGlobal.value?.bluetoothOn = true;
      }
      await FirebaseCRUDServices.instance.updateDocumentSingleKey(
          collection: usersCollection,
          docId: auth.currentUser!.uid,
          key: 'bluetoothOn',
          value: userModelGlobal.value?.bluetoothOn);
    }
  }

  Future<void> getLocationPermission() async {
    if (userModelGlobal.value?.locOn == true) {
      await FirebaseCRUDServices.instance.updateDocumentSingleKey(
          collection: usersCollection,
          docId: auth.currentUser!.uid,
          key: 'locOn',
          value: false);
    } else {
      LocationPermissionStatus status =
          await PermissionService.instance.getLocationPermissionStatus();
      if (status == LocationPermissionStatus.granted) {
        userModelGlobal.value?.locOn = true;
      } else if (await Permission.location.isPermanentlyDenied) {
        openAppSettings();
      } else {
        userModelGlobal.value?.locOn = true;
      }
      await FirebaseCRUDServices.instance.updateDocumentSingleKey(
          collection: usersCollection,
          docId: auth.currentUser!.uid,
          key: 'locOn',
          value: userModelGlobal.value?.locOn);
    }
  }

  Future<void> getNotificationPermission() async {
    if (userModelGlobal.value?.notifOn == true) {
      await FirebaseCRUDServices.instance.updateDocumentSingleKey(
          collection: usersCollection,
          docId: auth.currentUser!.uid,
          key: 'notifOn',
          value: false);
    } else {
      NotificationPermissionStatus status =
          await PermissionService.instance.getNotifPermissionStatus();
      if (status == NotificationPermissionStatus.granted) {
        userModelGlobal.value?.notifOn = true;
      } else if (await Permission.notification.isPermanentlyDenied) {
        openAppSettings();
      } else {
        userModelGlobal.value?.notifOn = true;
      }
      await FirebaseCRUDServices.instance.updateDocumentSingleKey(
          collection: usersCollection,
          docId: auth.currentUser!.uid,
          key: 'notifOn',
          value: userModelGlobal.value?.notifOn);
    }
  }

}
