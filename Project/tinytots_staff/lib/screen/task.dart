import 'package:flutter/material.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
        title: Text('Task'),
      ),
        backgroundColor: Color(0xfff8f9fa),
      body: Column(
        children: [
          Text('hi')
        ],
      ),
    );
  }
}