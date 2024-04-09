import "package:flutter/material.dart";

class SignInScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String? _email, _password;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Handle sign-in logic here
      print('Email: $_email, Password: $_password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Sign In',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 32),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    onSaved: (value) => _email = value,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onSaved: (value) => _password = value,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Sign In'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/createAccount');
                    },
                    child: Text('Create an Account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
