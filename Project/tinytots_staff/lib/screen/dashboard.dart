import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:tinytots_staff/screen/attendance_child.dart';
import 'package:tinytots_staff/screen/child_activity.dart';
import 'package:tinytots_staff/screen/login.dart';
import 'package:tinytots_staff/screen/post.dart';
import 'package:tinytots_staff/screen/view_post.dart';
import 'package:tinytots_staff/screen/task.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  

  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Post()));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ViewPost()));
        break;
      case 4:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
        title: Text('Dashboard'),
      ),
      backgroundColor: Color(0xfff8f9fa),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35)),
                  color: const Color(0xFFffffff),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    )
                  ]),
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Task()));
                            },
                            child: Container(
                              height: 130,
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: const Color(0xFfd4a373),
                              ),
                              child: Center(
                                child: Text(
                                  'Tasks',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xfff8f9fa)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AttendanceChild()));
                            },
                            child: Container(
                              height: 130,
                              width: 70,
                              child: Center(
                                child: Text(
                                  'Attendance',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xfff8f9fa)),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: const Color(0xFF9d8189),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChildActivity()));
                            },
                            child: Container(
                              height: 130,
                              width: 70,
                              child: Center(
                                child: Text(
                                  'Activity',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xfff8f9fa)),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Color(0xffadc178)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewPost()));
                            },
                            child: Container(
                              height: 130,
                              width: 70,
                              child: Center(
                                child: Text(
                                  'Post',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xfff8f9fa)),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Color(0xffff928b)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        selectedItemColor: Color(0xffcb997e),
        backgroundColor: Color(0xFFFFFFFF),
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                _onItemTapped(0); // Call function on tap
              },
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedHome12,
                color: Colors.black,
                size: 24.0,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                _onItemTapped(1); // Call function on tap
              },
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedUser,
              color: Colors.black,
              size: 24.0,
            ),),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                _onItemTapped(2); // Call function on tap
              },
            child:HugeIcon(
  icon: HugeIcons.strokeRoundedAddSquare,
  color: Colors.black,
  size: 24.0,
),),
            label: '',
          ),
          
           BottomNavigationBarItem(
             icon: GestureDetector(
              onTap: () {
                _onItemTapped(3); // Call function on tap
              },
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedMessage01,
              color: Colors.black,
              size: 24.0,
            ),),
            label: '',
          ),
           BottomNavigationBarItem(
             icon: GestureDetector(
              onTap: () {
                _onItemTapped(4); // Call function on tap
              },
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedLogout03,
              color: Colors.black,
              size: 24.0,
            ),),
            label: '',
          ),
        ],
      ),
    );
  }
}
