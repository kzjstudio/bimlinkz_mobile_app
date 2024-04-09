import 'package:bimlinkz_mobile_app/screens/mobile/become_a_tradesman_landing_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/create_account_with_email_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CreateTradesAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Create Account',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    color: Colors.amber,
                    child: const Center(child: Text("logo")),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Join BimLinkz and position yourself among skilled tradespeople and specialists, connecting you to a wider network of potential clients and projects.',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => BecomeATradesManScreen(),
                      transition: Transition.rightToLeftWithFade);
                },
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.deepPurpleAccent,
                    backgroundColor: Colors.white),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Continue to fill your information'),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('By joining you agree to Bimlinkz'),
                  TextButton(onPressed: () {}, child: Text('terms of service'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
