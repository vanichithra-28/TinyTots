import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:tinytots_staff/screen/infant.dart';
import 'package:tinytots_staff/screen/prescchooler.dart';
import 'package:tinytots_staff/screen/toddler.dart';

class AttendanceChild extends StatefulWidget {
  const AttendanceChild({super.key});

  @override
  State<AttendanceChild> createState() => _AttendanceChildState();
}

class _AttendanceChildState extends State<AttendanceChild> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFFbc6c25),
        title: Text('Attendance'),
      ),
      backgroundColor: Color(0xfff8f9fa),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Infant(),
                      ));
                },
                child: Container(
                  height: 200,
                  width: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                    color: Color(0xFFffffff),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      HugeIcon(
  icon: HugeIcons.strokeRoundedBaby01,
  color: Colors.black,
  size: 70.0,
)
                    ],
                  ),
                ),
              ),
              
              
              SizedBox(height: 20),
               GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ToddlerAttendance(),
                      ));
                },
                child: Container(
                  height: 200,
                  width: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                    color: Color(0xFFffffff),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      HugeIcon(
  icon: HugeIcons.strokeRoundedChild,
  color: Colors.black,
  size: 70.0,
)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PreschoolAttendance(),
                      ));
                },
                child: Container(
                  height: 200,
                  width: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                    color: Color(0xFFffffff),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/children.png', // Replace with your GIF path
                        height: 150, // Adjust size as needed
                        width: 150, // Adjust size as needed
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
