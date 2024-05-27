import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';

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
  }
}
