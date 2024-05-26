import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/chat_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagesScreen extends StatefulWidget {
  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<Map<String, dynamic>> chatsList = [];
  bool isLoading = true;

  Future<void> getChats() async {
    try {
      final chats = await FirebaseFirestore.instance
          .collection('Chats')
          .where('participants',
              arrayContains: AuthController.instance.auth.currentUser!.uid)
          .get();
      final data = chats.docs.map((doc) => doc.data()).toList();
      data.sort((a, b) =>
          (b['createdAt'] as Timestamp).compareTo(a['createdAt'] as Timestamp));

      setState(() {
        chatsList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading chats: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: chatsList.length,
              itemBuilder: (context, index) {
                final chat = chatsList[index];
                final otherUserId = chat['participants'].firstWhere((id) =>
                    id != AuthController.instance.auth.currentUser!.uid);
                final otherUserName = chat['reciever_Name'];
                final lastMessage = chat['message'];
                final recieverLastName = chat['reciever_LastName'];

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(otherUserId)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                        ),
                        title: Text('Loading...'),
                      );
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return const ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.error),
                        ),
                        title: Text('Error loading user info'),
                      );
                    } else {
                      final userData =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(userData['imageUrl'] ?? ''),
                          onBackgroundImageError: (_, __) =>
                              const Icon(Icons.error),
                        ),
                        title: Text(
                          ' $otherUserName $recieverLastName',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(lastMessage),
                        onTap: () {
                          Get.to(
                            () => ChatScreen(
                              contractorFirstName: otherUserName,
                              contractorLastName: otherUserId,
                              contractorId: ,
                            ),
                            transition: Transition.rightToLeft,
                          );
                        },
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
