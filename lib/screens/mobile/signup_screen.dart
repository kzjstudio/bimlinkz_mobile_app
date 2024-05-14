import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final _selectedRole = 'Freelancer'.obs;

  List<String> roles = ['Freelancer', 'Company', 'Client'];

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  Map<String, String> roleDescriptions = {
    'Freelancer': 'Individual providing services to multiple clients.',
    'Company': 'Business seeking to expand its network and hire talent.',
    'Client':
        'Looking for services and solutions for personal or business needs.'
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        FocusScope.of(context).requestFocus(FocusNode());
      }),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'images/logotrans.png',
                      width: 200,
                      height: 200,
                    ), // Ensure you have an image asset named 'logo.png' in your assets folder
                    const SizedBox(height: 10),
                    const Text(
                      'Welcome to Bimlinks',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 40),
                    Obx(
                      () => DropdownButtonFormField(
                        value: _selectedRole.value,
                        decoration: const InputDecoration(
                          labelText: 'Select Your Role',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (String? newValue) {
                          _selectedRole.value = newValue.toString();
                        },
                        items:
                            roles.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    if (_selectedRole != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child:
                            Obx(() => Text(roleDescriptions[_selectedRole]!)),
                      ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'User name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a user name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!value.contains('@')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        }),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            const Size(double.infinity, 50), // set minimum size
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          AuthController.instance.createUser(
                              _emailController.text,
                              _passwordController.text,
                              _nameController.text,
                              _selectedRole.value);
                        }
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
