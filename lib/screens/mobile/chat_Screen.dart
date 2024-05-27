import 'package:bimlinkz_mobile_app/Controllers/user_profile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';

class ChatScreen extends StatefulWidget {
  final String contractorFirstName;
  final String contractorLastName;
  final String contractorId;

  const ChatScreen({
    Key? key,
    required this.contractorFirstName,
    required this.contractorLastName,
    required this.contractorId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();
  late Stream<QuerySnapshot> _chatStream;

  @override
  void initState() {
    super.initState();
    _chatStream = FirebaseFirestore.instance
        .collection('Chats')
        .doc(_getChatId())
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  String _getChatId() {
    final currentUserId = AuthController.instance.auth.currentUser!.uid;
    final contractorId = widget.contractorId;
    return currentUserId.compareTo(contractorId) < 0
        ? '$currentUserId $contractorId'
        : '$contractorId $currentUserId';
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    final chatId = _getChatId();
    final message = _messageController.text.trim();
    final currentUserId = AuthController.instance.auth.currentUser!.uid;

    final messageData = {
      'senderId': currentUserId,
      'receiverId': widget.contractorId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('Chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);

    // Update the chat document with the last message info
    await FirebaseFirestore.instance.collection('Chats').doc(chatId).set({
      'participants': [currentUserId, widget.contractorId],
      'participant_names': {
        'sender':
            '${UserProfileController.instance.firstName.value} ${UserProfileController.instance.lastName.value}',
        'receiver': '${widget.contractorFirstName} ${widget.contractorLastName}'
      },
      'last_message': message,
      'last_message_timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${widget.contractorFirstName} ${widget.contractorLastName}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message['senderId'] ==
                        AuthController.instance.auth.currentUser!.uid;

                    return ListTile(
                      title: Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            message['message'],
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
