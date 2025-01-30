import 'package:flutter/material.dart';
import 'package:tinytots_parent/sceen/children.dart';
import 'package:tinytots_parent/sceen/events.dart';
import 'package:tinytots_parent/sceen/payment.dart';
import 'package:tinytots_parent/sceen/posts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
              height: 300,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
                color: const Color(0xFFffffff),
               boxShadow: [BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),) ]
              ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 100,
                          width: 70,
                          decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: const Color(0xFFADD8E6),
                                      ),),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                           height: 100,
                          width: 70,
                          decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: const Color(0xFFADD8E6),
                                      ),),
                      ),
                    ),
                
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 100,
                          width: 70,
                          decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: const Color(0xFFADD8E6),
                                      ),),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                           height: 100,
                          width: 70,
                          decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: const Color(0xFFADD8E6),
                                      ),),
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
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Allows more than 3 items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: Color(0xff023047),),
            label: '',
          ),
          BottomNavigationBarItem(
            
            icon: Icon(Icons.create,color: Color(0xff023047),),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,color: Color(0xff023047),),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications,color: Color(0xff023047),),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,color: Color(0xff023047),),
            label: '',
          ),
        ],
      ),
    );
  }
}
