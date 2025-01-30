import 'package:flutter/material.dart';

class Attendance_list extends StatefulWidget {
  const Attendance_list({super.key});

  @override
  State<Attendance_list> createState() => _Attendance_listState();
}

class _Attendance_listState extends State<Attendance_list> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 500,
             
              color: Color(0xffffffff),
                  child: Text('Day wise Attendance List',style:TextStyle(
                                  color: Color(0xffB4B4B6)) ,),
            ),
          ),
        ),
        
         Expanded(
           child: Padding(
             padding: const EdgeInsets.all(8.0),
             child: Container(
              height: 500,
             
              color: Color(0xffffffff),
                   child: Text('Month wise Attendance List',style:TextStyle(
                                  color: Color(0xffB4B4B6)) ,),
                     ),
           ),
         ),
      ],
      ),
    );
  }
}