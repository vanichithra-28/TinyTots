import 'package:flutter/material.dart';
import 'package:tinytots_admin/main.dart';

class StaffAttendance extends StatefulWidget {
  const StaffAttendance({super.key});

  @override
  State<StaffAttendance> createState() => _StaffAttendanceState();
}

class _StaffAttendanceState extends State<StaffAttendance> {
  List<Map<String, dynamic>> staffList = [];
  Map<String, bool> attendance = {};

  @override
  void initState() {
    super.initState();
    select();
  }

  void markAll(bool value) {
    setState(() {
      for (var staff in staffList) {
        attendance[staff['id']] = value;
      }
    });
  }

  Future<void> select() async {
    try {
      final response = await supabase.from('tbl_staff').select();
      setState(() {
        staffList = response;
        for (var staff in staffList) {
          attendance[staff['id']] = false;
        }
      });
    } catch (e) {
      print('Error fetching staff: $e');
    }
  }

  Future<void> insertAttendance() async {
    // Only insert for checked (present) staff
    final checkedEntries = attendance.entries.where((entry) => entry.value == true).toList();

    if (checkedEntries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one staff to mark present.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final currentDate = DateTime.now().toIso8601String().split('T')[0];

      // Check for existing attendance for today
      final existing = await supabase
          .from('tbl_attendance')
          .select('staff_id')
          .eq('date', currentDate).eq('role', 'staff')
          .not('staff_id', 'is', null);

      final existingIds = existing.map((e) => e['staff_id']).toSet();

      // Prepare attendance records, only for checked and not already marked
      final attendanceRecords = checkedEntries
          .where((entry) => !existingIds.contains(entry.key))
          .map((entry) {
        final staff = staffList.firstWhere((s) => s['id'] == entry.key);
        return {
          'staff_id': entry.key,
          'role': staff['role'] ?? 'staff',
          'check_in': DateTime.now().toIso8601String(),
          'date': currentDate,
        };
      }).toList();

      if (attendanceRecords.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Attendance already marked for selected staff today.'),
            backgroundColor: Colors.blueGrey,
          ),
        );
        return;
      }

      await supabase.from('tbl_attendance').insert(attendanceRecords);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Attendance saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      await select(); // Refresh after save
    } catch (e) {
      print('Error saving attendance: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving attendance: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchTodayAttendance() async {
    final currentDate = DateTime.now().toIso8601String().split('T')[0];
    final records = await supabase
        .from('tbl_attendance')
        .select('staff_id, check_in, date')
        .eq('date', currentDate).eq('role', 'staff')
        .not('staff_id', 'is', null);
    return records;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Staff Attendance',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => markAll(true),
                  icon: const Icon(Icons.check_box, color: Color(0xffffffff)),
                  label: const Text('Mark All Present'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => markAll(false),
                  icon: const Icon(Icons.check_box_outline_blank, color: Color(0xffffffff)),
                  label: const Text('Mark All Absent'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: staffList.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final staff = staffList[index];
                  return CheckboxListTile(
                    title: Text(staff['staff_name']),
                    value: attendance[staff['id']] ?? false,
                    onChanged: (val) {
                      setState(() {
                        attendance[staff['id']] = val ?? false;
                      });
                    },
                    activeColor: Colors.green[700],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: insertAttendance,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Save Attendance'),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Today\'s Attendance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchTodayAttendance(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No attendance marked today.'),
                      );
                    }
                    final records = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(Colors.blue[50]),
                        dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return Colors.blue[100];
                            }
                            return null;
                          },
                        ),
                        columnSpacing: 32,
                        columns: const [
                          DataColumn(
                            label: Text('Staff Name', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          DataColumn(
                            label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          DataColumn(
                            label: Text('Time', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                        rows: records.map((record) {
                          final staff = staffList.firstWhere(
                            (s) => s['id'] == record['staff_id'],
                            orElse: () => {'staff_name': 'Unknown'},
                          );
                          final isPresent = record['check_in'] != null;
                          final time = record['check_in'] != null
                              ? (record['check_in'] as String).split('T').last.split('.').first
                              : '-';
                          return DataRow(
                            cells: [
                              DataCell(Text(staff['staff_name'] ?? 'Unknown')),
                              DataCell(
                                Row(
                                  children: [
                                    Icon(
                                      isPresent ? Icons.check_circle : Icons.cancel,
                                      color: isPresent ? Colors.green : Colors.red,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      isPresent ? 'Present' : 'Absent',
                                      style: TextStyle(
                                        color: isPresent ? Colors.green[700] : Colors.red[700],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Text(
                                  time,
                                  style: const TextStyle(fontFamily: 'monospace'),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}