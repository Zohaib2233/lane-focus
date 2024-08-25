import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lanefocus/core/utils/dialogs.dart';

import '../../core/constants/firebase_constants.dart';
import '../../core/utils/app_strings.dart';
import '../../core/utils/snackbar.dart';
import '../../model/notifications/notification_model.dart';
import '../../model/user/user_model.dart';

class FirebaseCRUDServices {
  FirebaseCRUDServices._privateConstructor();

  //singleton instance variable
  static FirebaseCRUDServices? _instance;

  //This code ensures that the singleton instance is created only when it's accessed for the first time.
  //Subsequent calls to FirebaseCRUDService.instance will return the same instance that was created before.

  //getter to access the singleton instance
  static FirebaseCRUDServices get instance {
    _instance ??= FirebaseCRUDServices._privateConstructor();
    return _instance!;
  }

  /// check if the document exists in Firestore
  Future<bool> isDocExist(
      {required CollectionReference collectionReference,
      required String docId}) async {
    try {
      DocumentSnapshot documentSnapshot =
          await collectionReference.doc(docId).get();

      if (documentSnapshot.exists) {
        return true;
      } else {
        return false;
      }
    } on FirebaseException catch (e) {
      log("This was the exception while reading document from Firestore: $e");

      return false;
    } catch (e) {
      log("This was the exception while reading document from Firestore: $e");

      return false;
    }
  }

  /// check if the document exists in Firestore
  Future<bool> isDocExistByUsername(
      {required String collectionString, required String username}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection(FirebaseConstants.userCollection)
              .where('username', isEqualTo: username)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on FirebaseException catch (e) {
      log("This was the exception while reading document from Firestore: $e");

      return false;
    } catch (e) {
      log("This was the exception while reading document from Firestore: $e");

      return false;
    }
  }

  String getCollectionId({required CollectionReference collectionReference}) {
    DocumentReference reference = collectionReference.doc();
    return reference.id;
  }

  /// Create Document
  Future<bool> createDocument(
      {required CollectionReference collectionReference,
      required String docId,
      required Map<String, dynamic> data,
      required BuildContext context}) async {
    try {
      DialogService.instance.showProgressDialog(context: context);

      await collectionReference.doc(docId).set(data);

      DialogService.instance.hideLoading();

      //returning true to indicate that the document is created
      return true;
    } on SocketException catch (e) {
      DialogService.instance.hideLoading();
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Error',
          message: 'No internet connection. Please reconnect and try again.');
      return false;
    } on FirebaseException catch (e) {
      //getting firebase error message
      final errorMessage = getFirestoreErrorMessage(e);
      DialogService.instance.hideLoading();

      //showing failure snackbar
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Error", message: errorMessage);

      //returning false to indicate that the document was not created
      return false;
    } catch (e) {
      DialogService.instance.hideLoading();

      log("This was the exception while creating document on Firestore: $e");

      //returning false to indicate that the document was not created
      return false;
    }
  }

  //method to get single document stream
  Stream<DocumentSnapshot<Object?>> getSingleDocStream(
      {required CollectionReference collectionReference,
      required String docId}) {
    return collectionReference.doc(docId).snapshots();
  }

  //method to get stream of snapshots
  StreamSubscription<QuerySnapshot>? getStream(
      {required CollectionReference collectionReference}) {
    try {
      //getting document snapshots stream
      StreamSubscription<QuerySnapshot> stream =
          collectionReference.snapshots().listen((event) {});

      return stream;
    } on FirebaseException catch (e) {
      //getting firebase error message
      final errorMessage = getFirestoreErrorMessage(e);

      //showing failure snackbar
      CustomSnackBars.instance
          .showFailureSnackbar(title: 'Error', message: errorMessage);

      return null;
    } catch (e) {
      log("This was the exception while getting stream from Firestore: $e");

      return null;
    }
  }

  /// Create Document and update Id
  Future<(bool,String?)> createDocument2(
      {required CollectionReference collectionReference,
      required String docIdName,
      required Map<String, dynamic> data}) async {
    try {
      DocumentReference document = collectionReference.doc();

      await document.set(data);
      await document.update({docIdName: document.id});

      //returning true to indicate that the document is created
      return (true,document.id);
    } on FirebaseException catch (e) {
      //getting firebase error message
      final errorMessage = getFirestoreErrorMessage(e);

      //showing failure snackbar
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Error", message: errorMessage);

      //returning false to indicate that the document was not created
      return (false,null);
    } catch (e) {
      log("This was the exception while creating document on Firestore: $e");

      //returning false to indicate that the document was not created
      return (false,null);
    }
  }

  Future<DocumentSnapshot?> readSingleDoc(
      {required CollectionReference collectionReference,
      required String docId}) async {
    try {
      DocumentSnapshot snapshot = await collectionReference.doc(docId).get();
      return snapshot;
    } on FirebaseException catch (e) {
      //getting firebase error message
      final errorMessage = getFirestoreErrorMessage(e);

      //showing failure snackbar
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Error", message: errorMessage);

      //returning false to indicate that the document was not created
      return null;
    } catch (e) {
      print("This was the exception while updating document on Firestore: $e");

      //returning false to indicate that the document was not created
      return null;
    }
  }

  Stream<List<UserModel>> readAllUserDoc() {
    List<UserModel> userModels = [];
    // QuerySnapshot<Map<String,dynamic>> snapshots = await FirebaseConstants.fireStore
    //     .collection(FirebaseConstants.userCollection)
    //     .get();
    //
    // for(DocumentSnapshot snapshot in snapshots.docs){
    //   userModels.add(UserModel.fromJson(snapshot));
    //
    // }
    print("==========readAllUserDoc=========");

    return FirebaseConstants.fireStore
        .collection(FirebaseConstants.userCollection)
        .snapshots()
        .map((snapshots) {
      return snapshots.docs.map((e) => UserModel.fromJson(e.data())).toList();
    });
    // return userModels;
  }

  /// Update Document
  Future<bool> updateDocument(
      {required String collectionPath,
      required String docId,
      required Map<String, dynamic> data}) async {
    try {
      await FirebaseConstants.fireStore
          .collection(collectionPath)
          .doc(docId)
          .update(data);

      return true;
    } on FirebaseException catch (e) {
      //getting firebase error message
      final errorMessage = getFirestoreErrorMessage(e);

      //showing failure snackbar
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Error", message: errorMessage);

      //returning false to indicate that the document was not created
      return false;
    } catch (e) {
      print("This was the exception while updating document on Firestore: $e");

      //returning false to indicate that the document was not created
      return false;
    }
  }

  Future<bool> deleteDocument({
    required String collectionPath,
    required String docId,
  }) async {
    try {
      await FirebaseConstants.fireStore
          .collection(collectionPath)
          .doc(docId)
          .delete();

      return true;
    } on FirebaseException catch (e) {
      //getting firebase error message
      final errorMessage = getFirestoreErrorMessage(e);

      //showing failure snackbar
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Error", message: errorMessage);

      //returning false to indicate that the document was not created
      return false;
    } catch (e) {
      print("This was the exception while updating document on Firestore: $e");

      //returning false to indicate that the document was not created
      return false;
    }
  }

  /* --------- Notifications -------------------*/

  Future saveNotificationToFirestore(
      {required String title,
      required String body,
      required String sentBy,
      required String sentTo,
      required String type,
      DateTime? time,
      DateTime? date}) async {
    try {
      DocumentReference reference =
          FirebaseFirestore.instance.collection('notifications').doc();

      print("**********************reference $reference");

      await reference.set(NotificationModel(
              title: title,
              body: body,
              sentBy: sentBy,
              sentTo: sentTo,
              type: type,
              time: time,
              date: date,
              notId: reference.id)
          .toJson());
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamNotifications(userId) {
    return FirebaseFirestore.instance
        .collection(FirebaseConstants.notificationCollection)
        .where(Filter.and(Filter('sentTo', isEqualTo: userId),
            Filter('type', isNotEqualTo: AppStrings.notificationMessage)))
        // .where('sentTo', isEqualTo: userId).where('type',isNotEqualTo: AppStrings.notificationMessage)
        .orderBy('time', descending: true)
        .snapshots();
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

  //update single key of a document
  Future<bool> updateDocumentSingleKey({
    required CollectionReference collection,
    required String docId,
    required String key,
    required var value,
  }) async {
    try {
      await collection.doc(docId).update({
        key: value,
      });

      return true;
    } on FirebaseException catch (e) {
      //getting firebase error message
      final errorMessage = getFirestoreErrorMessage(e);

      //showing failure snackbar
      CustomSnackBars.instance
          .showFailureSnackbar(title: 'Error', message: errorMessage);

      //returning false to indicate that the document was not created
      return false;
    } catch (e) {
      log("This was the exception while updating document single key on Firestore: $e");

      //returning false to indicate that the document was not created
      return false;
    }
  }

  /// Read Single Document with where query
  Future<QueryDocumentSnapshot?> readSingleDocByFieldName({
    required CollectionReference collectionReference,
    required String fieldName,
    required String fieldValue,
  }) async {
    try {
      QuerySnapshot documentSnapshot = await collectionReference
          .where(fieldName, isEqualTo: fieldValue)
          .get();

      if (documentSnapshot.docs.isNotEmpty) {
        return documentSnapshot.docs[0];
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      //getting firebase error message
      final errorMessage = getFirestoreErrorMessage(e);

      //showing failure snackbar
      CustomSnackBars.instance
          .showFailureSnackbar(title: 'Error', message: errorMessage);
      return null;
    } catch (e) {
      log("This was the exception while reading document from Firestore: $e");
      return null;
    }
  }
}
