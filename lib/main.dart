import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:bimlinkz_mobile_app/bindings/authBindings.dart';
import 'package:bimlinkz_mobile_app/screens/landing_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        initialBinding: AuthBindings(),
        debugShowCheckedModeBanner: false,
        title: 'Bimlinkz',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, brightness: Brightness.light),
          useMaterial3: true,
          textTheme: GoogleFonts.nunitoTextTheme(),
        ),
        home: const LandingScreen());
  }
}
