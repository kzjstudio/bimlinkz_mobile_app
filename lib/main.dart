import 'package:bimlinkz_mobile_app/constants/colors.dart';
import 'package:bimlinkz_mobile_app/screens/landing_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bimlinkz',
        theme: ThemeData(
          textTheme: GoogleFonts.nunitoTextTheme(),
          primarySwatch: mypalette,
        ),
        home: const LandingScreen());
  }
}
