import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:bimlinkz_mobile_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: 'AIzaSyA8cjWYfUqYCNo__LBkwBIF6CARzQPD5mI',
              appId: '1:161008572662:web:4bb6f6292513552e43b4d7',
              messagingSenderId: '161008572662',
              projectId: 'bimixx-2eab2'))
      .then((value) => Get.put(AuthController()));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bimlinkz',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              background: Colors.white,
              seedColor: Colors.deepPurple,
              brightness: Brightness.light),
          useMaterial3: true,
          textTheme: GoogleFonts.nunitoTextTheme(),
        ),
        home: SplashScreen());
  }
}
