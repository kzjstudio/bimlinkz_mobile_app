import 'package:bimlinkz_mobile_app/screens/mobile/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

enum UserRole { freelancer, company, client }

class RoleSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <UserRole>[
            UserRole.freelancer,
            UserRole.company,
            UserRole.client,
          ]
              .map((role) => ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        )),
                    child: Text(role.toString().split('.').last),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
