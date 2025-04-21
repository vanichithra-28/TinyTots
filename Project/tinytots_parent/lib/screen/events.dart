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
        title: Text('Events'),
        backgroundColor: Color(0xFFffffff),
      ),
      backgroundColor: Color(0xFFf8f9fa),
      body: Column(
        children: [
          Expanded(
            child: _eventList.isEmpty
                ? Center(
                    child: Text(
                      'No upcoming events.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 25.0,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: _eventList.length,
                    itemBuilder: (context, index) {
                      final event = _eventList[index];
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
                          color: Color(0xFFeceef0),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 250,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Color(0xffadc178), width: 2.5),
                                      image: DecorationImage(
                                        image: NetworkImage(event['event_photo']),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Text(
                                      event['event_name'],
                                      style: TextStyle(
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      event['event_date'],
                                      style: TextStyle(
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
