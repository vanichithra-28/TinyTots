import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tinytots_admin/main.dart'; // For supabase

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  Map<String, int> totalCount = {
    'Infant': 0,
    'Toddler': 0,
    'Preschool': 0,
  };

  int staffCount = 0;

  List<Map<String, dynamic>> _upcomingEvents = [];
  bool _loadingEvents = true;

  @override
  void initState() {
    super.initState();
    fetchUpcomingEvents();
    fetchChildrenCount();
    fetchStaffCount();
  }

  Future<void> fetchUpcomingEvents() async {
    try {
      final response = await supabase
          .from('tbl_event')
          .select()
          .order('event_date', ascending: true);

      final now = DateTime.now();
      setState(() {
        _upcomingEvents = response
            .where((event) =>
                DateTime.tryParse(event['event_date'] ?? '')?.isAfter(now) ??
                false)
            .toList();
        _loadingEvents = false;
      });
    } catch (e) {
      setState(() {
        _loadingEvents = false;
      });
      print("Error fetching events: $e");
    }
  }

  Future<void> fetchChildrenCount() async {
    try {
      final children = await supabase.from('tbl_child').select('dob').eq('status', 1);
      Map<String, int> tempCount = {'Infant': 0, 'Toddler': 0, 'Preschool': 0};

      for (var child in children) {
        if (child['dob'] != null) {
          int ageInMonths = calculateAgeInMonths(child['dob']);
          String category = '';
          if (ageInMonths <= 12) {
            category = 'Infant';
          } else if (ageInMonths <= 36) {
            category = 'Toddler';
          } else if (ageInMonths <= 62) {
            category = 'Preschool';
          }
          if (category.isNotEmpty) {
            tempCount[category] = (tempCount[category] ?? 0) + 1;
          }
        }
      }
      setState(() {
        totalCount = tempCount;
      });
    } catch (e) {
      print('Error fetching children count: $e');
    }
  }

  Future<void> fetchStaffCount() async {
    try {
      final staff = await supabase.from('tbl_staff').select('id');
      setState(() {
        staffCount = staff.length;
      });
    } catch (e) {
      print('Error fetching staff count: $e');
    }
  }

  int calculateAgeInMonths(String dob) {
    try {
      DateTime birthDate = DateTime.parse(dob);
      DateTime today = DateTime.now();
      int years = today.year - birthDate.year;
      int months = today.month - birthDate.month;
      if (today.day < birthDate.day) {
        months -= 1;
      }
      return (years * 12) + months;
    } catch (e) {
      print("Error parsing date: $e");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards Section
            Text(
              'Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryCard(
                    'Infants', totalCount['Infant'] ?? 0, Color(0xFFF4A896)),
                _buildSummaryCard(
                    'Toddlers', totalCount['Toddler'] ?? 0, Color(0xFF00C897)),
                _buildSummaryCard(
                    'Preschool', totalCount['Preschool'] ?? 0, Colors.blueGrey),
                _buildSummaryCard('Staff', staffCount, Color(0xFF3e53a0)),
              ],
            ),
            SizedBox(height: 24),
            // Calendar Section
            Text(
              'Calendar',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Color(0xFFF4A896).withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Color(0xFF00C897),
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: true,
                  titleCentered: true,
                  formatButtonShowsNext: false,
                ),
              ),
            ),
            SizedBox(height: 24),
            // Upcoming Events Section
            Text(
              'Upcoming Events',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: _loadingEvents
                  ? Center(child: CircularProgressIndicator())
                  : _upcomingEvents.isEmpty
                      ? Center(
                          child: Text("No upcoming events",
                              style: TextStyle(fontSize: 16)))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _upcomingEvents.length,
                          itemBuilder: (context, index) {
                            final event = _upcomingEvents[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: event['event_photo'] != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          event['event_photo'],
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(Icons.event,
                                                      color: Color(0xFF00C897)),
                                        ),
                                      )
                                    : Icon(Icons.event,
                                        color: Color(0xFF00C897)),
                                title: Text(
                                  event['event_name'] ?? 'Unnamed Event',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "${event['event_date']} - ${event['event_details'] ?? 'No details'}",
                                  style: TextStyle(color: Colors.grey[600]),
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

  Widget _buildSummaryCard(String title, int count, Color color) {
    return Expanded(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.2), color.withOpacity(0.4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                ),
              ),
              SizedBox(height: 8),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
