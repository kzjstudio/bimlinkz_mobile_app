import 'package:bimlinkz_mobile_app/screens/mobile/account_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/home_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/messages_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/jobs_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:badges/badges.dart' as badges;

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _selectedIndex = 0;
  int unreadMessagesCount = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        // User navigated to the Messages screen, reset the unread messages count
        setState(() {
          unreadMessagesCount = 0;
        });
        // Mark messages as read in the database
        _markMessagesAsRead();
      }
    });
  }

  final screens = [
    const HomeScreen(),
    MessagesScreen(),
    const JobScreen(),
    AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkForUnreadMessages();
  }

  void _checkForUnreadMessages() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    FirebaseFirestore.instance
        .collection('Chats')
        .where('participants', arrayContains: currentUserId)
        .snapshots()
        .listen((snapshot) {
      int unreadCount = 0;
      for (var doc in snapshot.docs) {
        var messages = doc.reference.collection('messages');
        messages
            .where('receiverId', isEqualTo: currentUserId)
            .where('isRead', isEqualTo: false)
            .snapshots()
            .listen((messagesSnapshot) {
          unreadCount += messagesSnapshot.docs.length;
          setState(() {
            unreadMessagesCount = unreadCount;
          });
        });
      }
    });
  }

  Future<void> _markMessagesAsRead() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    final chats = await FirebaseFirestore.instance
        .collection('Chats')
        .where('participants', arrayContains: currentUserId)
        .get();

    for (var chat in chats.docs) {
      final messages = await chat.reference
          .collection('messages')
          .where('receiverId', isEqualTo: currentUserId)
          .where('isRead', isEqualTo: false)
          .get();

      for (var message in messages.docs) {
        await message.reference.update({'isRead': true});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          elevation: 15,
          items: [
            const BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home_outlined),
            ),
            BottomNavigationBarItem(
              label: 'Messages',
              icon: unreadMessagesCount > 0
                  ? badges.Badge(
                      showBadge: unreadMessagesCount == 0 ? false : true,
                      badgeContent: Text(
                        unreadMessagesCount.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      child: const Icon(Icons.mail_outline_outlined),
                    )
                  : const Icon(Icons.mail_outline_outlined),
            ),
            const BottomNavigationBarItem(
              label: 'Jobs',
              icon: Icon(Icons.task_outlined),
            ),
            const BottomNavigationBarItem(
              label: 'Account',
              icon: Icon(
                Icons.account_circle_outlined,
              ),
            )
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
