import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinytots_staff/main.dart';

class Infant extends StatefulWidget {
  const Infant({super.key});

  @override
  State<Infant> createState() => _InfantState();
}

class _InfantState extends State<Infant> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> infants = [];
  Map<int, bool> checkInAttendance = {};
  Map<int, bool> checkOutAttendance = {};
  Map<int, String> attendanceIds = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchInfants();
  }

  int calculateAgeInMonths(String dob) {
    try {
      DateTime birthDate = DateFormat("yyyy-MM-dd").parse(dob);
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

  Future<void> fetchInfants() async {
    try {
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final childrenResponse = await supabase.from('tbl_child').select().eq('status', 1);
      List<Map<String, dynamic>> allChildren =
          List<Map<String, dynamic>>.from(childrenResponse);

      final attendanceResponse =
          await supabase.from('tbl_attendance').select().eq('date', todayDate);

      Map<int, String> existingAttendance = {};
      Map<int, bool> existingCheckIns = {};
      Map<int, bool> existingCheckOuts = {};

      for (var record in attendanceResponse) {
        final id = record['id'];
        final childId = record['child_id'] as int?;
        if (id != null && childId != null) {
          existingAttendance[childId] = id.toString();
          existingCheckIns[childId] = record['check_in'] != null;
          existingCheckOuts[childId] = record['check_out'] != null;
        } else {
          print("Skipping attendance record with null id or child_id: $record");
        }
      }

      setState(() {
        infants = allChildren
            .where((child) => calculateAgeInMonths(child['dob']) <= 12)
            .toList();

        checkInAttendance = {
          for (var infant in infants)
            infant['id']: existingCheckIns[infant['id']] ?? false
        };

        checkOutAttendance = {
          for (var infant in infants)
            infant['id']: existingCheckOuts[infant['id']] ?? false
        };

        attendanceIds = {
          for (var infant in infants)
            infant['id']: existingAttendance[infant['id']] ?? ''
        };
      });
    } catch (e) {
      print("Error fetching infants: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching infants: $e")),
      );
    }
  }

  Future<void> updateAttendance(int childId, bool isCheckIn, bool value) async {
    try {
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final String currentId = attendanceIds[childId] ?? '';

      if (value) {
        if (currentId.isEmpty) {
          // New attendance record
          final response = await supabase.from('tbl_attendance').insert({
            'child_id': childId,
            'date': todayDate,
            'role': 'CHILD',
            isCheckIn ? 'check_in' : 'check_out':
                DateTime.now().toIso8601String(),
          }).select();

          final newId = response[0]['id'];
          if (newId != null) {
            setState(() {
              attendanceIds[childId] = newId.toString();
            });
          }
        } else {
          // Update existing record
          await supabase.from('tbl_attendance').update({
            isCheckIn ? 'check_in' : 'check_out':
                DateTime.now().toIso8601String(),
          }).eq('id', currentId);
        }
      } else if (currentId.isNotEmpty) {
        // Remove check-in/check-out time but keep record
        await supabase.from('tbl_attendance').update({
          isCheckIn ? 'check_in' : 'check_out': null,
        }).eq('id', currentId);
      }

      setState(() {
        if (isCheckIn) {
          checkInAttendance[childId] = value;
        } else {
          checkOutAttendance[childId] = value;
        }
      });
    } catch (e) {
      print("Error updating attendance: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating attendance: $e")),
      );
    }
  }

  Widget buildAttendanceTab(bool isCheckIn) {
    final attendanceMap = isCheckIn ? checkInAttendance : checkOutAttendance;

    return infants.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: infants.length,
            itemBuilder: (context, index) {
              final infant = infants[index];
              return Card(
                child: ListTile(
                  title: Text(infant['name']),
                  trailing: Checkbox(
                    value: attendanceMap[infant['id']] ?? false,
                    onChanged: (bool? value) {
                      updateAttendance(infant['id'], isCheckIn, value!);
                    },
                  ),
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      appBar: AppBar(
        title: const Text("Infant Attendance"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Check In'),
            Tab(text: 'Check Out'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            buildAttendanceTab(true), // Check In tab
            buildAttendanceTab(false), // Check Out tab
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}