import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final Color iconColor = Color(0xFF555555);

  int _selectedIndex = 0;

  void _onitemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 15,
      items: [
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
    );
  }
}
