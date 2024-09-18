import 'package:bimlinkz_mobile_app/screens/mobile/landing_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailConfirmationScreen extends StatefulWidget {
  final String email;

  const EmailConfirmationScreen({super.key, required this.email});

  @override
  _EmailConfirmationScreenState createState() =>
      _EmailConfirmationScreenState();
}

class _EmailConfirmationScreenState extends State<EmailConfirmationScreen> {
  final TextEditingController _codeController = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  void _verifyCode() async {
    // Fetch user data from Firestore
    var query = await db
        .collection('users')
        .where('Email', isEqualTo: widget.email)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      var userDoc = query.docs.first;
      var storedCode = userDoc['confirmationCode'];

      if (storedCode == _codeController.text) {
        // If the code matches, mark the email as confirmed in Firestore
        await db
            .collection('users')
            .doc(userDoc.id)
            .update({'isConfirmed': true});

        Get.snackbar("Success", "Your email has been confirmed.");

        // Redirect to the landing page
        Get.offAll(() => const LandingScreen());
      } else {
        Get.snackbar("Error", "Invalid confirmation code.",
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar("Error", "User not found.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Your Email")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text("Enter the confirmation code we sent to your email:"),
            const SizedBox(height: 20),
            TextFormField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: "Confirmation Code",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyCode,
              child: const Text("Verify Code"),
            ),
          ],
        ),
      ),
    );
  }
}
