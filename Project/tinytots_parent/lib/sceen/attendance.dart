import 'package:flutter/material.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      appBar: AppBar(
        title: Text('Activities'),
        backgroundColor: Color(0xFFffffff),
      ),
      backgroundColor: Color(0xFFf8f9fa),
   

     body: Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Name',
            
          ),   
        ),
        
      ],
     ), 
    );

  }
}