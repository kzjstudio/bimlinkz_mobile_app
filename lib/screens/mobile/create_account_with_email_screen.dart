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
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
              child: Column(
            children: [
              const Center(
                child: Image(
                  width: 200,
                  height: 200,
                  image: AssetImage('images/logo.jpg'),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Create account',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: const Text('Login'))
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                      const SizedBox(
                        height: 25,
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
                        height: 20,
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
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            )),
                            foregroundColor:
                                const MaterialStatePropertyAll<Color>(
                                    Colors.white),
                            backgroundColor:
                                const MaterialStatePropertyAll<Color>(
                                    Color(0xff05CFB5))),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'SIGN UP',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            )),
                            foregroundColor:
                                const MaterialStatePropertyAll<Color>(
                                    Colors.transparent),
                            backgroundColor:
                                const MaterialStatePropertyAll<Color>(
                                    Colors.white)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign up with google',
                              style: TextStyle(color: Colors.black),
                            ),
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
                  )),
            ],
          )),
        ),
      ),
    );
  }
}

//color code #05CFB5