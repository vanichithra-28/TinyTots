import 'package:flutter/material.dart';

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activities'),
        backgroundColor: Color(0xFFffffff),
      ),
      backgroundColor: Color(0xFFf8f9fa),
    );
  }
}