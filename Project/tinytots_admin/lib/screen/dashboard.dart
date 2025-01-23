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
  final List  _pages = [
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
      backgroundColor: Color(0xffedf2fb),
      body: 
      Row(
        children: [
          
          Expanded(
          
                child: Container(
                  
                
                  color: Color(0xffcaf0f8),
                  
                   child: SideBar(
                    
                      onItemSelected: onSidebarItemTapped,
                      
                    )
                ),
              ),
               Expanded(
            flex: 7,
            child: Column(
              children: [
              
                Appbar(),
              
                Expanded(
                  child:SingleChildScrollView(
                  child: _pages[_selectedIndex],
                ),)
              ],
            ),
          ),
        ],
      ),
          
    );
  }
}
