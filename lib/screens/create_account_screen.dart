import 'package:flutter/material.dart';

class CreateAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    color: Colors.amber,
                  ),
                ],
              ),
              SizedBox(height: 24.0),
              Text(
                'Join bimliknz and find tradesmen and specialist for all your needs. ',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: Text('Sign up with Google'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: Text('Sign up with email'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('By joining you aggree to Bimlinkz'),
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
