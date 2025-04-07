import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tinytots_parent/main.dart';

class EventParticipation extends StatefulWidget {
  final int eventId;

  const EventParticipation({super.key, required this.eventId});

  @override
  State<EventParticipation> createState() => _EventParticipationState();
}


class _EventParticipationState extends State<EventParticipation> {
  bool isParticipating = false;

  Future<void> updateParticipation() async {
    final prefs = await SharedPreferences.getInstance();
    int? childId = prefs.getInt('child');
    final status = isParticipating ? 1 : 0;

    await supabase.from('tbl_participant').insert({
        'child_id': childId,
        'event_id': widget.eventId,
        'status': status,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Participation'),
        backgroundColor: Color(0xFFffffff),
      ),
      backgroundColor: Color(0xFFf8f9fa),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Participating'),
            Switch(
              value: isParticipating,
              onChanged: (value) async {
                setState(() {
                  isParticipating = value;
                });
                await updateParticipation();
              },
            ),
          ],
        ),
      ),
    );
  }
}
