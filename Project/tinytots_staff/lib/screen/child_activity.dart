import 'package:flutter/material.dart';

class ChildActivity extends StatefulWidget {
  const ChildActivity({super.key});

  @override
  State<ChildActivity> createState() => _ChildActivityState();
}

class _ChildActivityState extends State<ChildActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
        title: Text('Child Activity'),
      ),
      backgroundColor: Color(0xFFeceef0),
    );
    
  }
}