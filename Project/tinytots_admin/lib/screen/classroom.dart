import 'package:flutter/material.dart';

class Classroom extends StatefulWidget {
  const Classroom({super.key});

  @override
  State<Classroom> createState() => _ClassroomState();
}

class _ClassroomState extends State<Classroom> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 600,
        width: 1000,
        color: Color(0xffffffff),
        child: Center(
          child: Row(
            children: [
              Container(),
              Container(),
              Container(),
            ],
          ),
        ),
          
      ),
    );
  }
}