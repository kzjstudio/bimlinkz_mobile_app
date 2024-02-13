import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAccountWithEmailScreen extends GetWidget<AuthController> {
  final _formKey = GlobalKey<FormState>();
  var passwordVisable = true.obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            "Sign up with email",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an email address';
                          } else if (!RegExp(
                                  r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null; // Return null if the input is valid
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), hintText: 'Email'),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Obx(
                        () => TextFormField(
                          controller: passwordController,
                          obscureText: passwordVisable.value,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    passwordVisable.value =
                                        !passwordVisable.value;
                                  },
                                  icon: Icon(Icons.visibility)),
                              border: OutlineInputBorder(),
                              hintText: 'Password'),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: userNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Plesae enter a user name';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Public user name'),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            controller.createUser(
                                emailController.text,
                                passwordController.text,
                                userNameController.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.deepPurpleAccent,
                            backgroundColor: Colors.white),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text('SIGN UP'),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('By joining you agree to Bimlinkz'),
                          TextButton(
                              onPressed: () {}, child: Text('terms of service'))
                        ],
                      )
                    ],
                  ),
                ))),
      ),
    );
  }
}
