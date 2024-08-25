import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:lanefocus/core/constants/instance_collections.dart';
import 'package:lanefocus/core/constants/instance_constants.dart';
import 'package:lanefocus/core/utils/snackbar.dart';
import 'package:lanefocus/model/notifications/notification_model.dart';
import 'package:lanefocus/services/firebaseServices/firebase_crud_services.dart';
import 'package:lanefocus/services/notificationService/local_notification_service.dart';
import 'package:lanefocus/view/screens/admin/admin_nav_bar/admin_alert/admin_alert.dart';
import 'package:permission_handler/permission_handler.dart';

class AlertController extends GetxController {

  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;

  RxBool isLoad = false.obs;
  RxList<Contact> contacts = <Contact>[].obs;
  RxList<Contact> matchedContacts = <Contact>[].obs;

  RxList<Map<String,dynamic>> tokens = <Map<String,dynamic>>[].obs;

  RxList<String> localEmergencyContactList = <String>[].obs;

  /// used to get the alert message
  /// this controller used in [AlertDialogWidget]

  TextEditingController alertController = TextEditingController();


  Future<void> getContacts() async {
    try {
      isLoad.value = true;
      if (await FlutterContacts.requestPermission()) {
        contacts.value = await FlutterContacts.getContacts(

            withProperties: true, withPhoto: true);
        log('message:${contacts.isEmpty}');


        log('contacts: ${contacts.isNotEmpty && contacts[5].phones.isNotEmpty ? contacts[5].phones
            [0].toString() : 'No phone number'}');


        /// here get the numbers of users of
        /// and not the contact of current user

        QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').
        where('userId',isNotEqualTo: auth.currentUser!.uid).get();
        List<DocumentSnapshot> firestoreContacts = snapshot.docs;

        /// Filtering documents that contain 'phone' field

        List<String> firestoreContactPhones = firestoreContacts.where((doc) {
          var data = doc.data() as Map<String, dynamic>?;
          return data != null && data.containsKey('phone');
        }).map((doc) => (doc.data() as Map<String, dynamic>)['phone'].toString()).toList();

        // /// Normalize phone numbers by removing leading zeros
        //
        // List<String> normalizedFirestoreContactPhones = firestoreContactPhones.map((phone) {
        //   return phone.startsWith('0') ? phone.substring(1) : phone;
        // }).toList();

        /// Finding matched contacts

        // Filtering matched contacts
        matchedContacts.value = contacts.where((contact) {
          return contact.phones.any((phone) {
            // Direct comparison without normalization
            return firestoreContactPhones.contains(phone.normalizedNumber);
          });
        }).toList();


        /// this helper function use to check is emergencyContact field
        /// is available in firestore or not

       await checkAndAddEmergencyContactsField(userModelGlobal.value!.userId.toString());

        // if (matchedContacts.isEmpty) {
        //  CustomSnackBars.instance.showFailureSnackbar(title: 'Ohh', message: 'No matched contacts found');
        // }

        log('Matched contacts: ${matchedContacts.length}');
      } else {
        await Permission.contacts.request();
      }
    } catch (e) {
      isLoad.value = false;
      log('Error: $e');
      CustomSnackBars.instance.showFailureSnackbar(title: 'Error', message: 'An error occurred while fetching contacts');
    } finally {
      isLoad.value = false;
    }
  }


  /// use to check is emergencyContact field is present in
  /// user collection or not if present then get emergency contacts
  /// else add emergencyContact field in user collection

  Future<void> checkAndAddEmergencyContactsField(String userId) async {
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

    try {
      bool isExist = await FirebaseCRUDServices.instance.isDocExist(
          collectionReference: usersCollection,
          docId: userId
      );

      if (isExist) {
        try {
          var documentSnapshot = await usersCollection.doc(userId).get();
          var documentData = documentSnapshot.data() as Map<String, dynamic>;

          if (documentData.containsKey('emergencyContacts')) {
            log('emergencyContacts field is present');
            // Retrieve emergencyContacts from Firestore
            List<String> emergencyContactList = List<String>.from(documentData['emergencyContacts']);


          //  log('emergencyContactIDS:${emergencyContactIds.toString()}');
            localEmergencyContactList.addAll(emergencyContactList);
            update();
           // await getTokensForEmergencyContacts(localEmergencyContactList,auth.currentUser!.uid);



          // localEmergencyContactIDS.addAll(emergencyContactIds);
          } else {
            await usersCollection.doc(userId).update({
              'emergencyContacts': []
            });
            log('emergencyContacts field has been added');
          }
        } catch (e) {
          log('Error retrieving or updating document: $e');
        }
      } else {
        // Handle case where the document does not exist, if necessary
        log('Document does not exist');
      }
    } catch (e) {
      log('Error checking document existence: $e');
    }
  }


   /// use to get tokens and uids of emergency Contacts
  /// and add both in [tokens] list as Map<'token','', 'uid',''>
  /// and inside of this function send notification also called

  Future<void> getTokensForEmergencyContacts(List<String> emergencyNumbers, String currentUserId) async {
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
    // List<String> tokens = [];

    try {
      // Retrieve all documents from the collection
      DocumentSnapshot documentSnapshot = await usersCollection.doc(userModelGlobal.value!.userId.toString()).get();
        var data = documentSnapshot.data() as Map<String, dynamic>;

        // Check if the document contains the 'emergencyContacts' field and it's a list
        if (data.containsKey('emergencyContacts') && data['emergencyContacts'] is List) {
          List<dynamic> emergencyContacts = data['emergencyContacts'];
          for (var contact in emergencyContacts) {
          final snapshot =
              await usersCollection.where('phone', isEqualTo: contact).get();
          Map<String, dynamic> data =
              snapshot.docs[0].data() as Map<String, dynamic>;
          final token = data['token'];
          final uid = data['userId'];

          /// here notification send process
          await sendNotificationToMultipleUsers(token,uid);
       //   tokens.add({'token':token,'userId':uid});
        }
        }

    } catch (e) {
      print("Error retrieving documents: $e");
    }
  }


  /// this bool use to show loader when no alert


  RxBool isFetched = false.obs;


  /// this [fetchNotifications] is a stream
  /// function use to get the notifications as a stream

  fetchNotifications(){
    isFetched.value = true;
    notificationCollection.where('sentTo',isEqualTo: auth.currentUser!.uid).orderBy('date',descending: true).snapshots().listen((snapshots){
      List<NotificationModel> tempList = [];
      if(snapshots.docs.isNotEmpty) {
        snapshots.docs.forEach((doc) {
          tempList.add(NotificationModel.fromJson(doc.data()));
          isFetched.value = false;
        });
        notificationList.assignAll(tempList);

      }else{
        isFetched.value = false;
        CustomSnackBars.instance.showFailureSnackbar(title: 'Alerts', message: 'No Alerts');
      }

    }).onError((e){
      log('error:${e.toString()}');
      isFetched.value = false;
    });

  }


  RxBool isSend = false.obs;
  /// this [sendNotificationToMultipleUsers] used in
  /// [getTokensForEmergencyContacts] function


  ///  old code ////

//   Future<void> sendNotificationToMultipleUsers(List<Map<String,dynamic>> tokens) async {
//     log('inside function');
//     String accessToken = await LocalNotificationService.instance.getAccessToken();
//     log('access token:${accessToken.toString()}');
//       for (int i = 0; i< tokens.length; i++) {
//       log('inside loop');
//        isSend.value =  await LocalNotificationService.instance.sendFCMNotificationWithToken(
//           deviceToken: tokens[i]['token'],
//           title: 'Alert',
//           body: alertController.text.trim(),
//           type: 'alerts',
//           sentBy: userModelGlobal.value!.userId!,
//           sentTo: tokens[i]['userId'],
//           savedToFirestore: true,
//           accessToken: accessToken.toString()
//         );
//         log('inside loop');
//     }
//       alertController.clear();
// }


  Future<void> sendNotificationToMultipleUsers(String token, String uid) async {
    log('inside function');
    String accessToken = await LocalNotificationService.instance.getAccessToken();
    log('access token:${accessToken.toString()}');
      log('inside loop');
      isSend.value =  await LocalNotificationService.instance.sendFCMNotificationWithToken(
          deviceToken:token,
          title: 'Alert',
          body: alertController.text.trim(),
          type: 'alerts',
          sentBy: userModelGlobal.value!.userId!,
          sentTo:uid,
          savedToFirestore: true,
          accessToken: accessToken.toString()
      );
      log('inside loop');

    alertController.clear();
  }
}

