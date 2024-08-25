import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lanefocus/config/routes/routes.dart';
import 'package:lanefocus/core/bindings/bindings.dart';
import 'package:lanefocus/firebase_options.dart';
import 'package:lanefocus/services/firebaseServices/dynamic_links.dart';
import 'package:lanefocus/services/notificationService/local_notification_service.dart';

import 'config/theme/light_theme.dart';

//for getting notifications when the app is in background and the user doesn't tap on the notification
@pragma(
    'vm:entry-point') //for getting background notifications in release mode also
Future<void> backgroundNotificationHandler(RemoteMessage message) async {
  print('Notification is: ${message.notification.toString()}');
  print("Message is (App is in background): ${message.data}");
  log('Notification is: ${message.notification!.title.toString()}');
  LocalNotificationService.instance.display(message);
}

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await DynamicLinkService.initDynamicLink();
  await LocalNotificationService.instance.initialize();
  await LocalNotificationService.instance.pushNotifications();
  FirebaseMessaging.onBackgroundMessage(backgroundNotificationHandler);
  await GetStorage.init();
  runApp(
    const MyApp(),
  );
}

//DO NOT REMOVE Unless you find their usage.
String dummyImg =
    'https://images.unsplash.com/photo-1558507652-2d9626c4e67a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80';

String dummyImg2 =
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=764&q=80';
String dummyUserPlaceholder =
    "https://firebasestorage.googleapis.com/v0/b/lanefocusflutter.appspot.com/o/no_image_found.png?alt=media&token=e5549b6b-7d9a-4696-9522-d05086d01638";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      title: 'LaneFocus',
      theme: lightTheme,
      themeMode: ThemeMode.light,
      initialBinding: InitialBindings(),
      initialRoute: AppLinks.splash_screen,
      getPages: AppRoutes.pages,
      defaultTransition: Transition.fadeIn,
    );
  }
}
