import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:tinytots_staff/screen/dashboard_content.dart';
import 'package:tinytots_staff/screen/mypost.dart';
import 'package:tinytots_staff/screen/post.dart';
import 'package:tinytots_staff/screen/profile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  List<String> pageTitle = [
    "Dashboard",
    "Account",
    "New post",
    "My post",
  ];

  List<Widget> pages = [DashboardContent(), Profile(), Post(), Mypost()];

  // Method to handle logout
  void _handleLogout() {
    // Add your logout logic here
    // For example: navigate to login screen, clear user data, etc.
    print('Logout tapped');
    // Navigator.pushReplacementNamed(context, '/login'); // Example navigation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
        title: Text(pageTitle[_selectedIndex]),
        actions: [
          PopupMenuButton<String>(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedMoreVertical,
              color: Colors.black,
              size: 30.0,
            ),
            onSelected: (String result) {
              if (result == 'logout') {
                _handleLogout();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Color(0xfff8f9fa),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        selectedItemColor: Color(0xFF000000),
        unselectedItemColor: Color(0xFF000000),
        backgroundColor: Color(0xFFFFFFFF),
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedHome12,
              color: Colors.black,
              size: 30.0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedUser,
              color: Colors.black,
              size: 30.0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedAddSquare,
              color: Colors.black,
              size: 30.0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedMenu02,
              color: Colors.black,
              size: 30.0,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}