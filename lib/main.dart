import 'package:bimlinkz_mobile_app/Controllers/global.dart';
import 'package:bimlinkz_mobile_app/theme.dart';
import 'package:bimlinkz_mobile_app/screens/splash_screen.dart';
import 'package:bimlinkz_mobile_app/Controllers/theme_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
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
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController =
      Get.put(ThemeController()); // Initialize the controller
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bimlinkz',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeController.themeMode.value,
        home: SplashScreen());
  }
}
