import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lanefocus/core/constants/instance_constants.dart';

CollectionReference<Map<String, dynamic>> usersCollection =
    FirebaseFirestore.instance.collection("users");

CollectionReference<Map<String, dynamic>> invitesCollection =
    FirebaseFirestore.instance.collection("inviteLinks");

CollectionReference<Map<String, dynamic>> circlesCollection =
    usersCollection.doc(auth.currentUser!.uid).collection("circles");

CollectionReference<Map<String, dynamic>> chatCollection =
    FirebaseFirestore.instance.collection("chat");



CollectionReference<Map<String, dynamic>> notificationCollection =
FirebaseFirestore.instance.collection("notifications");