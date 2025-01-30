import 'package:flutter/material.dart';
import 'package:tinytots_admin/components/sidebar.dart';
import 'package:tinytots_admin/components/appbar.dart';
import 'package:tinytots_admin/screen/attendance.dart';
import 'package:tinytots_admin/screen/home.dart';
import 'package:tinytots_admin/screen/event.dart';
import 'package:tinytots_admin/screen/manage_fee_structure.dart';
import 'package:tinytots_admin/screen/parent&child.dart';
import 'package:tinytots_admin/screen/task.dart';
import 'package:tinytots_admin/screen/admission.dart';
import 'package:tinytots_admin/screen/manage_staff.dart';



class Dashboard extends StatefulWidget { 
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  final List _pages = [
    Home(),
    Staff(),
    Admission(),
    Parent_child(),
    Events(),
    Schedule(),
    Attendance_list(),
    Fee_structure(),
  ];

  void onSidebarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFeceef0),
      body: Row(
        children: [
          Expanded(
            child: Container(
          //     decoration: BoxDecoration( gradient :LinearGradient(colors: [
          //   const Color(0xFFF4A896), // Golden
          //       Color(0xFF00C897),
          // ], begin: Alignment.topCenter, end: Alignment.bottomCenter),),
             
              child: SideBar(
                selectedIndex: _selectedIndex,  // Pass selected index
                onItemSelected: onSidebarItemTapped,
              ),
            ),
          ),

          Expanded(
            flex: 6,
            child: Column(
              children: [
                Appbar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: _pages[_selectedIndex],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
