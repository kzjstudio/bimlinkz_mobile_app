import 'package:bimlinkz_mobile_app/screens/create_account_with_email_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAccountScreen extends StatelessWidget {
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
                'Join bimliknz and find tradesmen and specialist for all your needs. ',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.deepPurpleAccent,
                    backgroundColor: Colors.white),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.g_mobiledata),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Sign up with Google'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => CreateAccountWithEmailScreen(),
                      transition: Transition.rightToLeftWithFade);
                },
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.deepPurpleAccent,
                    backgroundColor: Colors.white),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Sign up with email'),
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
