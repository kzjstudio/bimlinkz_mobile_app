import 'package:bimlinkz_mobile_app/Controllers/global.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/chat_screen.dart';
import 'package:bimlinkz_mobile_app/services/push_notifications.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/landing_screen.dart';
import 'package:bimlinkz_mobile_app/theme.dart';
import 'package:bimlinkz_mobile_app/Controllers/theme_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  SystemChrome.restoreSystemUIOverlays();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
          name: 'Bimlinkz',
          options: const FirebaseOptions(
              apiKey: 'AIzaSyA8cjWYfUqYCNo__LBkwBIF6CARzQPD5mI',
              appId: '1:161008572662:web:4bb6f6292513552e43b4d7',
              messagingSenderId: '161008572662',
              projectId: 'bimixx-2eab2'))
      .then((value) {
    Global.init();
    PushNotificationService().initialize();
  });

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    showNotification(message);
  });

  runApp(MyApp());
}

Future<void> onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  if (payload != null) {
    print('notification payload: $payload');
    // Navigate to the chat screen with the specified chatId
    Get.to(() => ChatScreen(
          chatId: payload,
          contractorFirstName: '', // Pass the contractor's first name
          contractorLastName: '', // Pass the contractor's last name
          contractorId: payload, // Pass the contractor's ID
        ));
  }
}

Future<void> showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'high_importance_channel', // channel ID
    'High Importance Notifications', // channel name
    channelDescription:
        'This channel is used for important notifications.', // channel description
    importance: Importance.max,
    priority: Priority.high,
    sound: RawResourceAndroidNotificationSound('notification_sound'),
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
    payload: message.data['chatId'],
  );
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  MyApp({super.key}); // Initialize the controller
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bimlinkz',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeController.themeMode.value,
        home: const LandingScreen());
  }
}
