import 'package:bimlinkz_mobile_app/screens/mobile/jobs_screen.dart';
import 'package:flutter/material.dart';

class JobDetailScreen extends StatelessWidget {
  final Job job;

  const JobDetailScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(job.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(job.description, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              Text('Parish: ${job.parish}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 5),
              Text('Contractor Type: ${job.jobCategory}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => sendMessage(job),
                child: const Text('Send Message'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendMessage(Job job) {
    // Here, implement the functionality to send a message to the job poster.
    print('Message sent to ${job.title} poster');
  }
}
