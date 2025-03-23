import 'package:flutter/material.dart';
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
                onDoubleTap: () {
                  Navigator.push(context,MaterialPageRoute(builder:(context) => Infant(),));
                },

                child: Container( 
                  height: 250,
                  width: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all( Radius.circular(35)
                    ),
                    color: Color(0xFFffffff),
                  ),
                  
                child: Text('Infants')
                
                ),
              ), SizedBox(height: 20),
             GestureDetector(
              onDoubleTap: () {
                                  Navigator.push(context,MaterialPageRoute(builder:(context) => ToddlerAttendance(),));

              },
               child: Container( 
                  height: 250,
                  width: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all( Radius.circular(35)
                    ),
                    color: Color(0xFFffffff),
                  ),
                  child: Text('Toddlers'),
                ),
             ), SizedBox(height: 20),
              GestureDetector(
                onDoubleTap: () {
                                                    Navigator.push(context,MaterialPageRoute(builder:(context) => PreschoolAttendance(),));

                },
                child: Container( 
                  height: 250,
                  width: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all( Radius.circular(35)
                    ),
                    color: Color(0xFFffffff),
                  ),
                  child: Text('Preschoolers'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}