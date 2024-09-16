import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  final VoidCallback onMessagesViewed;

  MessagesScreen({required this.onMessagesViewed});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final String currentUserId = AuthController.instance.auth.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    widget.onMessagesViewed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Chats')
            .where('participants', arrayContains: currentUserId)
            .orderBy('last_message_timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading chats'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No messages.'));
          }

          final chatsList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chatsList.length,
            itemBuilder: (context, index) {
              final chat = chatsList[index];
              final otherUserId = chat['participants']
                  .firstWhere((id) => id != currentUserId, orElse: () => null);
              final otherUserName = chat['participant_names'][otherUserId];
              final lastMessage = chat['last_message'];
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(otherUserId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey,
                      ),
                      title: Text('Loading...'),
                    );
                  } else if (userSnapshot.hasError) {
                    return const ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.error),
                      ),
                      title: Text('Error loading user info'),
                    );
                  } else {
                    // Check if data is null
                    final userData =
                        userSnapshot.data?.data() as Map<String, dynamic>?;

                    // Handle case where user data is null
                    if (userData == null) {
                      return const ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                        ),
                        title: Text('User not found'),
                        subtitle: Text('No information available'),
                      );
                    }
                    DateTime date =
                        DateTime.parse(chat['last_message_timestamp']);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(userData['imageUrl'] ?? ''),
                        onBackgroundImageError: (_, __) =>
                            const Icon(Icons.error),
                      ),
                      title: Text(
                        otherUserName ?? 'Unknown user',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(lastMessage),
                      trailing: Text(date.toString()),
                      onTap: () {
                        Get.to(
                          () => ChatScreen(
                            contractorFirstName:
                                userData['First_Name'] ?? 'Unknown',
                            contractorLastName: userData['Last_Name'] ?? '',
                            contractorId: otherUserId,
                          ),
                          transition: Transition.rightToLeft,
                        );
                      },
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
