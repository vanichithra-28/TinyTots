import 'package:flutter/material.dart';

class EventParticipation extends StatefulWidget {
  const EventParticipation({super.key});

  @override
  State<EventParticipation> createState() => _EventParticipationState();
}

class _EventParticipationState extends State<EventParticipation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Participation'),
        backgroundColor: Color(0xFFffffff),
      ),
      backgroundColor: Color(0xFFf8f9fa),
    );
  }
}