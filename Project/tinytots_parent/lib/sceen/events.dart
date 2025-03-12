import 'package:flutter/material.dart';
import 'package:tinytots_parent/main.dart';

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
          .order('created_at', ascending: false);

      setState(() {
        _eventList = response;
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
          SizedBox(
              height: 700,
              child: GridView.builder(
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
                  return Card(
                    color: Color(0xFFeceef0),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 250,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Color(0xffadc178), width: 2.5),
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
                            SizedBox(width: 15,),
                            Expanded(
                                child: Text(
                              event['event_name'],
                              style: TextStyle(
                                color: Color(0xff000000),
                              ),
                            )),
                            Expanded(
                                child: Text(
                              event['event_date'],
                              style: TextStyle(
                                color: Color(0xff000000),
                              ),
                            )),
                          ],
                        )
                      ],
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }
}
