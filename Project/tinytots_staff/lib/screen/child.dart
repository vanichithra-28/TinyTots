import 'package:flutter/material.dart';

class Child extends StatefulWidget {
  const Child({super.key});

  @override
  State<Child> createState() => _ChildState();
}

class _ChildState extends State<Child> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFbc6c25),
      
      ),
      body: Container(
        child: Column(
          children: [
            Card(
              
            )
          ],
        ),
      ),
    );
  }
}