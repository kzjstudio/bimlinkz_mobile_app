import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: Colors.white,
      child: const Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(
            backgroundColor: Colors.purpleAccent,
          ),
        ),
      ),
    );
  }
}
