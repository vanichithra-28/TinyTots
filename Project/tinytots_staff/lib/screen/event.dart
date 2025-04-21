import 'package:flutter/material.dart';
import 'package:tinytots_staff/main.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  List<Map<String, dynamic>> events = [];
  Map<int, List<String>> participants = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      final now = DateTime.now().toIso8601String();
      final eventList = await supabase
          .from('tbl_event')
          .select()
          .gte('event_date', now)
          .order('event_date', ascending: true);

      Map<int, List<String>> eventParticipants = {};

      for (var event in eventList) {
        final partList = await supabase
            .from('tbl_participant')
            .select('child_id')
            .eq('event_id', event['id']);

        List<String> childNames = [];
        for (var part in partList) {
          final child = await supabase
              .from('tbl_child')
              .select('name')
              .eq('id', part['child_id'])
              .single();
          if (child != null && child['name'] != null) {
            childNames.add(child['name']);
          }
        }
        eventParticipants[event['id']] = childNames;
      }

      setState(() {
        events = List<Map<String, dynamic>>.from(eventList);
        participants = eventParticipants;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching events: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: const Color(0xFFeceef0),
      
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : events.isEmpty
              ? Center(child: Text('No upcoming events'))
              : ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    final eventParts = participants[event['id']] ?? [];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event['event_name'] ?? 'No Name',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Date: ${event['event_date'] ?? ''}',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Participants:',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                            ...eventParts.isEmpty
                                ? [Text('No participants')]
                                : eventParts
                                    .map((p) => Text('• $p'))
                                    .toList(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}