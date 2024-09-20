import 'package:bimlinkz_mobile_app/screens/mobile/account_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/home_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/messages_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/job_listing_screen.dart';
import 'package:bimlinkz_mobile_app/theme.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:badges/badges.dart' as badges;
import 'dart:async';
import 'package:flutter/scheduler.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _selectedIndex = 0;
  int unreadMessagesCount = 0;
  StreamSubscription<QuerySnapshot>? _subscription;
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      const HomeScreen(),
      MessagesScreen(
        onMessagesViewed: () {
          // Schedule the setState call to avoid calling it during build
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                unreadMessagesCount = 0;
              });
            }
          });
        },
      ),
      const JobScreen(),
      AccountScreen(),
    ];
    _checkForUnreadMessages();
  }

  void _checkForUnreadMessages() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    _subscription = FirebaseFirestore.instance
        .collection('Chats')
        .where('participants', arrayContains: currentUserId)
        .snapshots()
        .listen((snapshot) {
      int unreadCount = 0;
      final List<Future<void>> futures = [];
      for (var doc in snapshot.docs) {
        var messages = doc.reference.collection('messages');
        var future = messages
            .where('receiverId', isEqualTo: currentUserId)
            .where('isRead', isEqualTo: false)
            .get()
            .then((messagesSnapshot) {
          unreadCount += messagesSnapshot.docs.length;
        });
        futures.add(future);
      }
      Future.wait(futures).then((_) {
        if (mounted) {
          setState(() {
            unreadMessagesCount = unreadCount;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      // Reset unread messages count and mark as read
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            unreadMessagesCount = 0;
          });
        }
      });
      _markMessagesAsRead();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DoubleBackToCloseApp(
            snackBar: const SnackBar(content: Text('Press again to exsit')),
            child: screens[_selectedIndex]),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 15,
          items: [
            const BottomNavigationBarItem(
              label: "Home",
              icon: Icon(
                Icons.home,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Messages',
              icon: unreadMessagesCount > 0
                  ? badges.Badge(
                      badgeContent: Text(
                        unreadMessagesCount.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      child: const Icon(Icons.mail_outline_outlined),
                    )
                  : const Icon(Icons.mail),
            ),
            const BottomNavigationBarItem(
              label: 'Jobs',
              icon: Icon(Icons.task),
            ),
            const BottomNavigationBarItem(
              label: 'Account',
              icon: Icon(
                Icons.person,
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
