import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        title: const Text(
          'Event Participation',
          style: TextStyle(
            color: Color(0xFFbc6c25),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFffffff),
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFFbc6c25)),
      ),
      backgroundColor: const Color(0xFFf8f9fa),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.10),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.event, color: Color(0xFFbc6c25), size: 48),
              const SizedBox(height: 18),
              const Text(
                'Would you like your child to participate in this event?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF495057),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Not Participating',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Switch(
                    value: isParticipating,
                    activeColor: const Color(0xFFbc6c25),
                    onChanged: (value) async {
                      setState(() {
                        isParticipating = value;
                      });
                      await updateParticipation();
                    },
                  ),
                  const Text(
                    'Participating',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFbc6c25),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  await updateParticipation();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isParticipating
                            ? 'Participation confirmed!'
                            : 'Participation withdrawn.',
                      ),
                      backgroundColor: isParticipating
                          ? Colors.green
                          : Colors.orange,
                    ),
                  );
                },
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, color: Color(0xfff8f9fa)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFbc6c25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
