import 'package:bimlinkz_mobile_app/screens/account_screen.dart';
import 'package:bimlinkz_mobile_app/screens/home_screen.dart';
import 'package:bimlinkz_mobile_app/screens/messages_screen.dart';
import 'package:bimlinkz_mobile_app/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final Color iconColor = const Color(0xFF555555);
  int _selectedIndex = 0;

  void _onitemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final screens = [
    const HomeScreen(),
    const MessagesScreen(),
    const SearchScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 15,
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Messages',
            icon: Icon(Icons.mail_outline_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Search',
            icon: Icon(Icons.search_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Account',
            icon: Icon(
              Icons.account_circle_outlined,
            ),
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onitemTapped,
        unselectedItemColor: iconColor,
      ),
    ));
  }
}
