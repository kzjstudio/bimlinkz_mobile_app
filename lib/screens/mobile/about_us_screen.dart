import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  final String appVersion =
      "1.0.0";

  const AboutPage({super.key}); // You should fetch this from your app settings or build configuration

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Image.asset(
              'images/logotrans.png', // Make sure to replace with your actual logo asset path
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 20),
            Text(
              'App Version $appVersion',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            Text(
              'About the App',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[700]),
            ),
            const SizedBox(height: 10),
            Text(
              'Our app connects businesses and private contractors with a robust marketplace for job findings, freelancing opportunities, and local services. Whether you are looking to hire or seeking to offer your skills, our platform facilitates seamless interactions and transactions, ensuring reliable and efficient engagements.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
