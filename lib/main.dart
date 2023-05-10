import 'package:bimlinkz_mobile_app/constants/colors.dart';
import 'package:bimlinkz_mobile_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
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
        home: const HomeScreen());
  }
}
