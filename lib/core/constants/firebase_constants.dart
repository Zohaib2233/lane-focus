import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseConstants {
  static const String userCollection = 'users';


  static const String circlesCollection = 'circles';
  static const String chatRoomsCollection = 'chatRooms';
  static const String messagesCollection = 'messages';
  static const String notificationCollection = 'notifications';
  static const String followRequestsCollection = 'followRequests';

  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;


  static CollectionReference userCollectionReference = FirebaseFirestore
      .instance.collection('users');
  static CollectionReference circleCollectionReference = FirebaseFirestore
      .instance.collection('circles');
  static CollectionReference invitesCollectionReference = FirebaseFirestore
      .instance.collection('invitesLinks');


}
