import 'package:flutter/material.dart';
import 'package:tinytots_parent/main.dart';
import 'package:tinytots_parent/screen/event_participation.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  List<Map<String, dynamic>> _eventList = [];
  Future<void> display() async {
    try {
      final response = await supabase
          .from('tbl_event')
          .select()
          .order('event_date', ascending: true);

      // Filter only upcoming events (event_date >= today)
      final today = DateTime.now();
      final upcomingEvents = response.where((event) {
        final eventDate = DateTime.tryParse(event['event_date'] ?? '');
        return eventDate != null && !eventDate.isBefore(DateTime(today.year, today.month, today.day));
      }).toList();

      setState(() {
        _eventList = upcomingEvents;
      });
    } catch (e) {
      print("ERROR FETCHING TASKS $e");
    }
  }

  @override
  void initState() {
    super.initState();
    display(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Events',
          style: TextStyle(
            color: Color(0xFF22223b),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF22223b)),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFf8f9fa),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: _eventList.isEmpty
            ? const Center(
                child: Text(
                  'No upcoming events.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : ListView.separated(
                itemCount: _eventList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (context, index) {
                  final event = _eventList[index];
                  final eventDate = DateTime.tryParse(event['event_date'] ?? '');
                  final formattedDate = eventDate != null
                      ? "${eventDate.day}/${eventDate.month}/${eventDate.year}"
                      : event['event_date'] ?? '';
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventParticipation(eventId: event['id']),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 4,
                      color: const Color(0xFFeceef0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: event['event_photo'] != null && event['event_photo'].toString().isNotEmpty
                                  ? Image.network(
                                      event['event_photo'],
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        height: 180,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.event, size: 60, color: Colors.grey),
                                      ),
                                    )
                                  : Container(
                                      height: 180,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.event, size: 60, color: Colors.grey),
                                    ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              event['event_name'] ?? '',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff22223b),
                              ),
                            ),
                             Text(
                              event['event_details'] ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xff22223b),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 18, color: Color(0xffadc178)),
                                const SizedBox(width: 8),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff4a4e69),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
