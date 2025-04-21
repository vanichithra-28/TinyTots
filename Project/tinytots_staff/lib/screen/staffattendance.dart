import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinytots_staff/main.dart';

class StaffAttendancePage extends StatefulWidget {
  const StaffAttendancePage({super.key});

  @override
  State<StaffAttendancePage> createState() => _StaffattendanceState();
}

class _StaffattendanceState extends State<StaffAttendancePage> {
  List<Map<String, dynamic>> attendanceList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    try {
      final data = await supabase
          .from('tbl_attendance')
          .select()
          .eq('staff_id', supabase.auth.currentUser!.id)
          .eq('role', 'staff')
          .order('date', ascending: false);
      setState(() {
        attendanceList = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching attendance: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Attendance'),
        backgroundColor: Color(0xFFbc6c25),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFeceef0),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : attendanceList.isEmpty
              ? const Center(child: Text('No attendance records found.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  itemCount: attendanceList.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final record = attendanceList[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.07),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFbc6c25).withOpacity(0.15),
                          child: const Icon(Icons.event_available, color: Color(0xFFbc6c25)),
                        ),
                        title: Text(
                          record['date'] ?? 'Unknown Date',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFbc6c25),
                            fontSize: 17,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.login, size: 16, color: Colors.green),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Check in: ${record['check_in'] != null ? DateFormat('hh:mm a').format(DateTime.parse(record['check_in'])) : 'N/A'}',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}