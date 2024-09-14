import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:bimlinkz_mobile_app/models/jobs.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/chat_Screen.dart';
import 'package:bimlinkz_mobile_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobDetailScreen extends StatelessWidget {
  final Job job;

  const JobDetailScreen({super.key, required this.job});

  void sendMessage(Job job) {
    // Here, implement the functionality to send a message to the job poster.
    print('Message sent to ${job.title} poster');
  }

  @override
  Widget build(BuildContext context) {
    var jobId = job.userId.obs;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(job.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  'Posted by: ${job.firstName} ${job.lastName} ',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Card(
                color: AppColors.secondary,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 28),
                  child: Text(job.description,
                      style: const TextStyle(fontSize: 18)),
                )),
            const SizedBox(height: 20),
            Text(' In the ${job.parish} area.',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text('Contractor Type: ${job.jobCategory}',
                style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            const SizedBox(height: 30),
            Obx(
              () => ElevatedButton(
                style: const ButtonStyle(
                    foregroundColor:
                        WidgetStatePropertyAll(AppColors.lightBackground),
                    backgroundColor: WidgetStatePropertyAll(AppColors.primary)),
                onPressed:
                    jobId.value == AuthController.instance.auth.currentUser!.uid
                        ? null
                        : () => Get.to(
                              () => ChatScreen(
                                  contractorFirstName: job.firstName,
                                  contractorLastName: job.lastName,
                                  contractorId: job.userId),
                            ),
                child: const Text(
                  'Send Message',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
