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
       backgroundColor: Color(0xfff8f9fa),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              SizedBox(height: 20),
              Container( 
                height: 250,
                width: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all( Radius.circular(35)
                  ),
                  color: Color(0xFFffffff),
                ),
              ), SizedBox(height: 20),
             Container( 
                height: 250,
                width: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all( Radius.circular(35)
                  ),
                  color: Color(0xFFffffff),
                ),
              ), SizedBox(height: 20),
              Container( 
                height: 250,
                width: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all( Radius.circular(35)
                  ),
                  color: Color(0xFFffffff),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}