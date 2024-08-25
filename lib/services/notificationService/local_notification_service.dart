//local notification service class
import 'dart:convert';
import 'dart:developer';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import '../../core/utils/snackbar.dart';
import '../firebaseServices/firebase_crud_services.dart';



class LocalNotificationService {

  LocalNotificationService._privateConstructor();

  //singleton instance variable
  static LocalNotificationService? _instance;


  //getter to access the singleton instance
  static LocalNotificationService get instance {
    _instance ??= LocalNotificationService._privateConstructor();
    return _instance!;
  }


  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

   final firebaseMessaging = FirebaseMessaging.instance;

  //method to initialize the initialization settings
   Future<void> initialize() async {
    await requestNotificationPermission();
    //initializing settings for android
    InitializationSettings initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    //we are getting details variable from the payload parameter of the notificationsPlugin.show() method
    notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        print("Key of the map is: ${details.payload}");
      },
    );

    getDeviceToken();
  }

  requestNotificationPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      AppSettings.openAppSettings();
    }
  }

  //getting device token for FCM
 Future<String?> getDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("Device token := $token");
    return token;
  }

  //method to display push notification on top of screen
   void display(RemoteMessage message) async {
    try {
      //getting a unique id
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      //creating notification details channel
      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails("alert", "alert",
              importance: Importance.max, priority: Priority.max));

      //displaying heads up notification
      await notificationsPlugin.show(id, message.notification!.title,
          message.notification!.body, notificationDetails,
          payload: message.data['type']);
    } on Exception catch (e) {
      print(
          "This exception occured while getting notification: $e Push Notification Exception");
    }
  }

  // A function to send the notification to the user upon messaging the other user
   Future<void> sendFCMNotification({
    required String deviceToken,
    required String title,
    required String body,
    required String type,
    required String sentBy,
    required String sentTo,
    required bool savedToFirestore
  }) async {
     print("Send Method Called");
    //in header we put the server key of the firebase console that is used for this project
     String accessToken = await getAccessToken();

     print("Access Tokennn = $accessToken");
     String projectId = "lanefocusflutter";
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };
      var request = http.Request(
          'POST', Uri.parse('https://fcm.googleapis.com/v1/projects/$projectId/messages:send'));




      request.body = json.encode(
          {
        "message":
          {
            "token": deviceToken,
            "notification": {"title": title, "body": body},
            "data": {"type": type, "sentBy": sentBy, "sentTo": sentTo}
          }
        }
      );
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print("************ Notification has been send **********");
        if(savedToFirestore){
          await FirebaseCRUDServices.instance.saveNotificationToFirestore(
              title: title,
              body: body,
              sentBy: sentBy,
              sentTo: sentTo,
              type: type);
        }

        //showSuccessSnackbar(title: 'Success', msg: '${response.statusCode}');
      } else {
        log('${response.request.toString()}');
        CustomSnackBars.instance.showFailureSnackbar(
            title: 'Error sending FCM notification',
             message: '${response.statusCode}');
      }
    } catch (e) {
      print("Exception ****** $e *******");
      // Utils.showFailureSnackbar(
      //     title: 'Error sending FCM notification', msg: '$e');
    }
  }


  // A function to send the notification to the user upon messaging the other user
  Future<bool> sendFCMNotificationWithToken({
    required String deviceToken,
    required String title,
    required String body,
    required String type,
    required String sentBy,
    required String sentTo,
    required bool savedToFirestore,
    required String accessToken
  }) async {
    print("Send Method Called");
    //in header we put the server key of the firebase console that is used for this project


    print("Access Tokennn = $accessToken");
    String projectId = "lanefocusflutter";
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };
      var request = http.Request(
          'POST', Uri.parse('https://fcm.googleapis.com/v1/projects/$projectId/messages:send'));




      request.body = json.encode(
          {
            "message":
            {
              "token": deviceToken,
              "notification": {"title": title, "body": body},
              "data": {"type": type, "sentBy": sentBy, "sentTo": sentTo}
            }
          }
      );
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print("************ Notification has been send **********");
        if(savedToFirestore){
          await FirebaseCRUDServices.instance.saveNotificationToFirestore(
              title: title,
              body: body,
              sentBy: sentBy,
              sentTo: sentTo,
              type: type);
        }
        return true;
        //showSuccessSnackbar(title: 'Success', msg: '${response.statusCode}');
      } else {
        log('status code:${response.statusCode.toString()}');
        log('------${response.request.toString()}');
        CustomSnackBars.instance.showFailureSnackbar(
            title: 'Error sending FCM notification',
            message: '${response.statusCode}');
        return false;
      }
    } catch (e) {

      print("Exception ****** $e *******");
      return false;
      // Utils.showFailureSnackbar(
      //     title: 'Error sending FCM notification', msg: '$e');
    }
  }


 //Handle Message
 void handleMessage({required BuildContext context ,required RemoteMessage message}){
     if(message.data['type']=='general'){
       // Get.to(()=>TripsScreen());
     }
 }

  //method to listen to firebase push notifications
//adding push notifications
  Future<void> pushNotifications() async {
    //for onMessage to work properly
    //to get the notification message when the app is in terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("Notification got from the terminated state: ${message.data}");
        // Get.to(() => HostProfile());
      }
    });

    //works only if the app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //displaying push notification via local notification package
      print("Message is (App is in foreground): ${message.data}");
      //adding new notification data to notification models list
      // Get.find<NotificationController>().addNewNotification(message: message);
      log('Notification is: ${message.notification!.title.toString()}');
      /// Display Notification
      display(message);
    });

    //works only when the app is in background but opened and the user taps on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Message is (App is in background and user tapped): ${message.data}");
      //adding new notification data to notification models list
      // Get.find<NotificationController>().addNewNotification(message: message);
      // Get.to(() => HostProfile());
    });
  }

  static String firebaseMessagingScope = "https://www.googleapis.com/auth/firebase.messaging";


  /// Generate Service Account Private Key
  Future<String> getAccessToken() async {

    /// Generate Service Key through Project Setting => Service Account => Generate New Private Key
    /// Copy Map from that file

    var serviceAccountKey =   {
      "type": "service_account",
      "project_id": "lanefocusflutter",
      "private_key_id": "0d8c662925981b844efe70290f261bc2ef8ebae1",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDdFAjOG0A9HZJz\neEuX2BmtvuMYH3gaethaTYfOstfMRH9NsQ1nA5bMqlUmMLlalnkj7gV/xh9Kaw9C\nsNrZ4hs4gwYWROoLj0b8Fhj1LNW/iqz08JKKzk7iEjuU9anmiqhVEJ6YK+ZWbJ6P\n5DzglhGyQJQO8CLcJS0F8p8NgsXpmQjYmrWHk5MIkXH/A5msNqUusgCgQxmnB2Mt\nXnsDD8dKDSrpHQhHdMj+1XMuQw3GYCrGOtlac7MtnskdgFIEhAKm4T6Rwg4jotR6\nje/9zLNOQIKYm+exh0SbHbWprkZV1JglLYNjjrVBukUzW927jEO8KAp677wl217V\nqjmq49k5AgMBAAECggEAEbYxsGWBg4PzgDnCgKNJB2D0K7IVurVd0PpGJ5qvbEeO\nlWhaZQbmFXaOBNXBe87zXJwMp7x1NE6YdeTaW7tgJ+pjWfRiddOgQcD5decGJubS\nzXramrFFo5oHWPtHhddU/h+rPRDDTug72dZUxD9xooDG+91kRZPa5A+Yi4oPFhRM\n/bRJv7XnfgwojliJ7OWKszXAYT7kjYwP6/mBXGJg3uqk791vi7sWTB1sqZW5tBVV\n5o5CsvnE9XsdK1eJlEyEVpnZF8hPfuGdc1ZMIrlf2f8siShmjXWVANA7YaUIICQQ\nuj2xiSuC6Okbf1nsiOLufsqeCcQrPMCzU7BOXIWuowKBgQD0RkRzjQ8TiXlq75Nx\nsJL51eSO9cA7wThyxhJn/rdmwKE4tWgYhqzeQfx7pjxLa1QpQfiMk+ZaDFvmRyCF\nJ3Y26bHnTULnDz2oq7nqPCXb0v/vqjC6+w3P2CoAbnAizDjSzFaRDd8pGQGB6PF5\n2gzMRNR8F+uDBjMZvna8eFMKXwKBgQDnsLk2fw6FGxwYANSn8xWDR9AfDAlsGeZe\nUzA3sBS9A9N3BCy2jXtXoI64cGJ1IituRmcM6pwTd81GuANDR0qQqfDsEYBVagHv\nFUU2u2kJx+W80m9hxHxPaycvpH1Qp2oLfmk0dMpibTmPRMm3VpDUe+2vq1Z5+YH9\n1lj04W5zZwKBgQDXFCehNkpYAWuO5HMGX1qJ7/LWjTs9Ydu58vyx5GzHZESQEeod\n7ja3W5JbrPrZzR7FVPjrji38i3U/RNE1bJGBuDKUXkrR93Fq2glQXLVY4GfJNijB\n+dsnbkVNK/BAM2C0+oYeIgCjxwi0wc4cZAlwsgoFWWpca1EDEdiqCafUMQKBgQCm\nZcnfVck714iJxK72ICMnMgBLC/4IYWGOBPjwRcnfJkxNgfYK9fnLqUhXNn+/2FaQ\n0IdaQ3TslnIbhDTzsNPgqeyZ3sfokEXrS79124tItwRMZGYSNWeCMlbmZKCLuHD0\n6Ejun6Jqpj9coe6tecJymL7QF6H34DZ38+XXmcAVqQKBgC6MBPcOh+V8XB5WXZcf\nsfep1AHb4S28pL5nGzSp9LBs9F3benuJ/dbwjOkcbrmDtHANJOxCNWDeuFK9sh8O\nNoEGxbcXRZo8eGUo4xur/SwPD1OgIj3Y22TZerM3NbtWrPOqnjtc7y9Mn101qqx8\nUfq7q+o26UZ/YBq3TmTzMfLJ\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-nmk6f@lanefocusflutter.iam.gserviceaccount.com",
      "client_id": "101175348612169553052",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-nmk6f%40lanefocusflutter.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

     
     final client = await clientViaServiceAccount(ServiceAccountCredentials.fromJson(
       serviceAccountKey
     ), [firebaseMessagingScope]);

     final accessToken = client.credentials.accessToken.data;

     return accessToken;

  }

}
