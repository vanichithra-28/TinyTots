import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> attendanceRecords = [];

  @override
  void initState() {
    super.initState();
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    int? childId = prefs.getInt('child');
    final user = supabase.auth.currentUser;
    if (user != null && childId != null) {
      final response = await supabase
          .from('tbl_attendance')
          .select()
          .eq('child_id', childId);

      setState(() {
        attendanceRecords = List<Map<String, dynamic>>.from(response);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
        backgroundColor: Color(0xFFffffff),
      ),
      backgroundColor: Color(0xFFf8f9fa),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: attendanceRecords.isEmpty
                  ? Center(child: Text('No attendance records found'))
                  : ListView.builder(
                      itemCount: attendanceRecords.length,
                      itemBuilder: (context, index) {
                        final record = attendanceRecords[index];
                        return Card(
                          child: ListTile(
                            title: Text(record['date'] ?? 'Unknown Date'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Check in: ${record['check_in'] != null ? DateFormat('hh:mm a').format(DateTime.parse(record['check_in'])) : 'N/A'}',
                                ),
                                Text(
                                  'Check out: ${record['check_out'] != null ? DateFormat('hh:mm a').format(DateTime.parse(record['check_out'])) : 'N/A'}',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
