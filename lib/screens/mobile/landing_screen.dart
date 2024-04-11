import 'package:bimlinkz_mobile_app/screens/mobile/account_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/company_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/home_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/messages_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/search_screen.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _selectedIndex = 0;

  void _onitemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final screens = [
    HomeScreen(),
    Companies(),
    const MessagesScreen(),
    const SearchScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: screens[_selectedIndex],
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                  canvasColor: Theme.of(context).primaryColor,
                  primaryColor: Colors.red),
              child: BottomNavigationBar(
                elevation: 15,
                items: const [
                  BottomNavigationBarItem(
                    label: "Home",
                    icon: Icon(Icons.home_outlined),
                  ),
                  BottomNavigationBarItem(
                      label: 'Companies',
                      icon: Icon(
                        Icons.business_center_outlined,
                      )),
                  BottomNavigationBarItem(
                    label: 'Messages',
                    icon: Icon(Icons.mail_outline_outlined),
                  ),
                  BottomNavigationBarItem(
                    label: 'Tasks',
                    icon: Icon(Icons.task_outlined),
                  ),
                  BottomNavigationBarItem(
                    label: 'Account',
                    icon: Icon(
                      Icons.account_circle_outlined,
                    ),
                  )
                ],
                currentIndex: _selectedIndex,
                onTap: _onitemTapped,
              ),
            )));
  }
}
