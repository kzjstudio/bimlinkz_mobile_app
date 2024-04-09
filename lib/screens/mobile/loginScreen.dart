import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/create_account_with_email_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            // Center the content horizontally
            child: ConstrainedBox(
              // Constrain the width
              constraints: BoxConstraints(maxWidth: 500),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 250.0,
                        width: 250.0,
                        padding: const EdgeInsets.only(top: 40),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200),
                        ),
                        child: const Center(
                          child: Image(
                            width: 300,
                            height: 300,
                            image: AssetImage('images/logo.jpg'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Welcome to Bimlinkz',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(width.toString()),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          hintText: 'Enter valid mail id as abc@gmail.com',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          hintText: 'Enter your secure password',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.transparent),
                              ),
                              onPressed: () {},
                              child: Text('Forgot Password?')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(170, 35),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {},
                            icon: const FaIcon(
                              FontAwesomeIcons.google,
                              size: 20,
                            ),
                            label: const Text("Sign in"),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(170, 35),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {},
                            icon: const FaIcon(
                              FontAwesomeIcons.facebook,
                              size: 20,
                            ),
                            label: const Text("Sign in"),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)))),
                            minimumSize: MaterialStateProperty.all(
                                const Size(double.infinity, 40))),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            AuthController.instance.signIn(
                                emailController.text, passwordController.text);
                          }
                        },
                        child: const Text('Login'),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Not a Member yet?'),
                          TextButton(
                              onPressed: () {
                                Get.to(() => CreateAccountWithEmailScreen());
                              },
                              child: const Text(' Sign up now'))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
