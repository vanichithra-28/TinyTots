import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:tinytots_parent/sceen/dashboard_content.dart';
import 'package:tinytots_parent/sceen/menu.dart';
import 'package:tinytots_parent/sceen/posts.dart';
import 'package:tinytots_parent/sceen/profile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  List<String> pageTitle = [
    "Dashboard",
    "Profile",
    "Post",
    "Menu",
  ];

  List<Widget> pages = [DashboardContent(), Profile(), Posts(), Menu()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
        title: Text(pageTitle[_selectedIndex]),
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
  icon: HugeIcons.strokeRoundedVideoReplay,
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
