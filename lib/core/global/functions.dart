import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:lanefocus/core/constants/instance_collections.dart';
import 'package:lanefocus/core/constants/instance_constants.dart';

import '../../model/user/user_model.dart';
import '../../services/firebaseServices/firebase_crud_services.dart';
import '../../services/notificationService/local_notification_service.dart';
import '../constants/firebase_constants.dart';
import '../utils/snackbar.dart';

Future<Position> getCurrentLocation() async {
  try {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    print("--------------------------- permission === $permission");
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  } catch (e) {
    print('Error getting current location: $e');
    rethrow; // Rethrow the exception for handling at the caller's level
  }
}

updateUserCurrentLocation({required String userId}) async {
  print("-----------------------updateUserCurrentLocation--------------");
  final Position position = await getCurrentLocation();
  // Define GeoFirePoint by instantiating GeoFirePoint with latitude and longitude.

  final GeoFirePoint geoFirePoint =
      GeoFirePoint(GeoPoint(position.latitude, position.longitude));

  print("------------------- geoFirePoint ${geoFirePoint}");

  await FirebaseCRUDServices.instance.updateDocument(
      collectionPath: FirebaseConstants.userCollection,
      docId: userId,
      data: {'userActiveAddress': geoFirePoint.data});
}

  getUserDataStream({required String userId}) async {
  // getting user's data stream
  // FirebaseCRUDServices.instance
  //     .getSingleDocStream(collectionReference: usersCollection, docId: userId)

  await usersCollection
      .doc(auth.currentUser!.uid)
      .snapshots()
      .listen((DocumentSnapshot<Object?> event) {
    userModelGlobal.value =
        UserModel.fromJson(event.data() as Map<String, dynamic>);

    print("errror: ${userModelGlobal.value}");
  });

  //you can cancel the stream if you wanna do
  // userDataStream.cancel();
  String token = await LocalNotificationService.instance.getDeviceToken() ?? '';

  await FirebaseFirestore.instance
      .collection(FirebaseConstants.userCollection)
      .doc(auth.currentUser!.uid)
      .update({'token': token});
}

//
// }


Future<void> forgetPassword({required String email}) async{
  try{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email).onError((error, stackTrace){
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failure", message: "$error");
    });
  }on FirebaseAuthException catch(e){
    CustomSnackBars.instance.showFailureSnackbar(title: 'Failure',
        message: e.toString());
  }
}


/// Read Single Document
Future<DocumentSnapshot?> readSingleDocument(
    {required CollectionReference collectionReference,
      required String docId}) async {
  try {
    DocumentSnapshot documentSnapshot =
    await collectionReference.doc(docId).get();

    if (documentSnapshot.exists) {
      return documentSnapshot;
    } else {
      return null;
    }
  } on FirebaseException catch (e) {
    //getting firebase error message
    final errorMessage = getFirestoreErrorMessage(e);

    //showing failure snackbar
    CustomSnackBars.instance
        .showFailureSnackbar(title: 'error'.tr, message: errorMessage);
    return null;
  } catch (e) {
    log("This was the exception while reading document from Firestore: $e");
    return null;
  }
}


bool isSameDay(DateTime a, DateTime b) {
  return b.year == a.year && b.month == a.month && b.day == a.day;
}
/// Method to get a user-friendly message from FirebaseException
String getFirestoreErrorMessage(FirebaseException e) {
  switch (e.code) {
    case 'cancelled':
      return 'The operation was cancelled.';
    case 'unknown':
      return 'An unknown error occurred.';
    case 'invalid-argument':
      return 'Invalid argument provided.';
    case 'deadline-exceeded':
      return 'The deadline was exceeded, please try again.';
    case 'not-found':
      return 'Requested document was not found.';
    case 'already-exists':
      return 'The document already exists.';
    case 'permission-denied':
      return 'You do not have permission to execute this operation.';
    case 'resource-exhausted':
      return 'Resource limit has been exceeded.';
    case 'failed-precondition':
      return 'The operation failed due to a precondition.';
    case 'aborted':
      return 'The operation was aborted, please try again.';
    case 'out-of-range':
      return 'The operation was out of range.';
    case 'unimplemented':
      return 'This operation is not implemented or supported yet.';
    case 'internal':
      return 'Internal error occurred.';
    case 'unavailable':
      return 'The service is currently unavailable, please try again later.';
    case 'data-loss':
      return 'Data loss occurred, please try again.';
    case 'unauthenticated':
      return 'You are not authenticated, please login and try again.';
    default:
      return 'An unexpected error occurred, please try again.';
  }
}