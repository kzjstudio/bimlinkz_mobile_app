import 'package:bimlinkz_mobile_app/main.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/chat_Screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:get/get.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future initialize() async {
    // Request permission for iOS
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Get the device token
    String? token = await _fcm.getToken();
    print("FirebaseMessaging token: $token");

    // Save the token to Firestore
    if (token != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(AuthController.instance.auth.currentUser!.uid)
          .update({'deviceToken': token});
    }

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      handleNotification(message);
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print('Handling a background message: ${message.messageId}');
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

  void handleNotification(RemoteMessage message) {
    final chatId = message.data['chatId'];
    if (chatId != null) {
      Get.to(() => ChatScreen(
            chatId: chatId,
            contractorFirstName: '', // Pass the contractor's first name
            contractorLastName: '', // Pass the contractor's last name
            contractorId: chatId, // Pass the contractor's ID
          ));
    }
  }
}
