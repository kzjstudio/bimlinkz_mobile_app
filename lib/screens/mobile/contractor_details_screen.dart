import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/chat_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContractorDetailScreen extends StatelessWidget {
  final Map<String, dynamic> contractor;

  const ContractorDetailScreen({Key? key, required this.contractor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${contractor['First_Name']} ${contractor['Last_Name']}'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(contractor['imageUrl'] ?? ''),
                  onBackgroundImageError: (_, __) => const Icon(Icons.error),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${contractor['First_Name']} ${contractor['Last_Name']}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Email: ${contractor['Email']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Phone: ${contractor['Phone_Number']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Experience: ${contractor['Years_Experience']} years',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Skill: ${contractor['Skill']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Reviews',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 200,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Text('Reviews Placeholder'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => ChatScreen(
              contractorFirstName: contractor['First_Name'],
              contractorLastName: contractor['Last_Name'],
              contractorId: contractor['id']));
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}

void _showMessageDialog(BuildContext context, Map<String, dynamic> contractor) {
  TextEditingController _messageController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Send Message to ${contractor['First_Name']}'),
        content: TextField(
          controller: _messageController,
          decoration: InputDecoration(
            hintText: 'Type your message here...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              String message = _messageController.text;
              FirebaseFirestore.instance.collection('Chats').add({
                'message': message,
                'participants': [
                  AuthController.instance.auth.currentUser!.uid,
                  contractor['id']
                ],
                'sender': AuthController.instance.auth.currentUser!.uid,
                'receiver': contractor['id'],
                'reciever_Name': contractor['First_Name'],
                'reciever_LastName': contractor['Last_Name'],
                'reciever_Email': contractor['Email'],
                'imageUrl': contractor['imageUrl'],
                'createdAt': Timestamp.now(),
                'read': false,
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sent')),
              );
              Navigator.of(context).pop();
            },
            child: const Text('Send'),
          ),
        ],
      );
    },
  );
}
