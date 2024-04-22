import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedRole;
  var isButtonActive = true.obs;
  final List<String> _roles = const ['Freelancer', 'Company', 'Client'];
  final Map<String, String> _roleDescriptions = {
    'Freelancer':
        'Freelancers provide services or work on projects for various clients without committing to a single employer.',
    'Company':
        'Companies frequently engage freelancers for specific services or extend project-based opportunities to individuals on a contractual basis.',
    'Client':
        'Clients seek professionals to engage for specific tasks or projects related to their personal or professional endeavors.'
  };

  String? _selectedRoleDescription;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Bimlinkz Sign Up')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage(
                            'images/logotrans.png'), // Ensure the logo asset is in the correct folder
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Welcome to Bimlinkz',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Select your role',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedRole = newValue;
                      _selectedRoleDescription = _roleDescriptions[newValue];
                    });
                  },
                  items: _roles.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  validator: (value) =>
                      value == null ? 'Please select a role' : null,
                ),
                if (_selectedRoleDescription != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _selectedRoleDescription!,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                Obx(
                  () => ElevatedButton(
                    onPressed: isButtonActive.isTrue
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              isButtonActive.value = false;
                              AuthController.instance.createUser(
                                  _emailController.text,
                                  _passwordController.text,
                                  _nameController.text,
                                  _selectedRole.toString());
                            }
                          }
                        : null,
                    child: const Text('Sign Up'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
