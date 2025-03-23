import 'package:flutter/material.dart';
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
    final user = supabase.auth.currentUser;
    if (user != null) {
      final response = await supabase
          .from('tbl_attendance')
          .select('*')
          .eq('parent_id', user.id);
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
                            title: Text(record['name']),
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
