import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

              // Safely check if the document's data is null
              final chatData = chat.data() as Map<String, dynamic>?;

              if (chatData == null) {
                return const ListTile(
                  title: Text('No chat data available'),
                );
              }

              // Fetch participants and other details safely
              final otherUserId = chatData['participants']
                  ?.firstWhere((id) => id != currentUserId, orElse: () => null);
              final otherUserName = chatData['participant_names']?[otherUserId];
              final lastMessage = chatData['last_message'] ?? 'No message';

              // Safely check and fetch unread_counts
              final unreadCount = chatData['unread_counts'] != null
                  ? chatData['unread_counts'][currentUserId] ?? 0
                  : 0;

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
                    // Safely access user data
                    final userData =
                        userSnapshot.data?.data() as Map<String, dynamic>?;

                    if (userData == null) {
                      return const ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                        ),
                        title: Text('User not found'),
                        subtitle: Text('No information available'),
                      );
                    }

                    DateTime date = chatData['last_message_timestamp'].toDate();
                    var formattedDate = DateFormat('MM/ d/ y').format(date);

                    return ListTile(
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(userData['imageUrl'] ?? ''),
                            onBackgroundImageError: (_, __) =>
                                const Icon(Icons.error),
                          ),
                          if (unreadCount > 0)
                            Positioned(
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$unreadCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      title: Text(
                        otherUserName ?? 'Unknown user',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(lastMessage),
                      trailing: Text(formattedDate),
                      onTap: () async {
                        // Reset unread count when the user opens the chat
                        await FirebaseFirestore.instance
                            .collection('Chats')
                            .doc(chat.id)
                            .update({
                          'unread_counts.$currentUserId':
                              0, // Reset unread count for the current user
                        });

                        // Navigate to the ChatScreen
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
