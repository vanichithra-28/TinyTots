import 'package:flutter/material.dart';
import 'package:tinytots_admin/screen/Login.dart';
import 'package:tinytots_admin/screen/attendance.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 35.0),
            child: Row(
              children: [
                Icon(Icons.account_circle),
                Text('Admin'),
              ],
            ),
          )
        ],
        backgroundColor: Color(0xffb7efc5),
        foregroundColor: Color(0xff10451d),
        title: Text(
          'DASHBOARD',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Row(
        children: [
          SingleChildScrollView(
            child: Container(
              width: 300,
              height: 700,
              decoration: BoxDecoration(
                color: Color(0xffd8e2dc),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                    child: ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Home'),
                      onTap: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: ListTile(
                      leading: Icon(Icons.menu_book_rounded),
                      title: Text('Attendance'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Attendance()),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: ListTile(
                      leading: Icon(Icons.person_2_rounded),
                      title: Text('Staff'),
                      onTap: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: ListTile(
                      leading: Icon(Icons.video_label_sharp),
                      title: Text('Media'),
                      onTap: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: ListTile(
                      leading: Icon(Icons.abc),
                      title: Text('Learning'),
                      onTap: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: ListTile(
                      leading: Icon(Icons.payment),
                      title: Text('Payments'),
                      onTap: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: ListTile(
                      leading: Icon(Icons.power_settings_new_rounded),
                      title: Text('Logout'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Color(0xffe8e8e4),
            ),
          )
        ],
      ),
    );
  }
}
