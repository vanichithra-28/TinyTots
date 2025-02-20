import 'package:flutter/material.dart';

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
        backgroundColor: Color(0xffffffff),
        title: Text('Attendance'),
      ),
      backgroundColor: Color(0xFFeceef0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Column(
            children: [
              SizedBox(height: 20),
              Container( 
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all( Radius.circular(35)
                  ),
                  color: Color(0xFFf8f9fa),
                ),
              ), SizedBox(height: 20),
             Container( 
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all( Radius.circular(35)
                  ),
                  color: Color(0xFFf8f9fa),
                ),
              ), SizedBox(height: 20),
              Container( 
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all( Radius.circular(35)
                  ),
                  color: Color(0xFFf8f9fa),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}