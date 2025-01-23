import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule>
    with SingleTickerProviderStateMixin {
  bool _isFormVisible = false;
  @override
  final Duration _animationDuration = const Duration(milliseconds: 300);
  Widget build(BuildContext context) {
    return Column(
     children: [
      Text('task')
     ],
    );
  }
}
