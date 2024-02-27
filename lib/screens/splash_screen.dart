import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: Colors.white,
      child: Center(
        child: Container(
          height: 100,
          width: 100,
          child: const CircularProgressIndicator(
            backgroundColor: Colors.purpleAccent,
          ),
        ),
      ),
    );
  }
}
