import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinytots_staff/main.dart';

class PreschoolAttendance extends StatefulWidget {
  const PreschoolAttendance({super.key});

  @override
  State<PreschoolAttendance> createState() => _PreschoolAttendanceState();
}

class _PreschoolAttendanceState extends State<PreschoolAttendance>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> preschoolers = [];
  Map<int, bool> checkInAttendance = {};
  Map<int, bool> checkOutAttendance = {};
  Map<int, String> attendanceIds = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchPreschoolers();
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

  Future<void> fetchPreschoolers() async {
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
        if (id != null) {
          existingAttendance[record['child_id']] = id.toString();
          existingCheckIns[record['child_id']] = record['check_in'] != null;
          existingCheckOuts[record['child_id']] = record['check_out'] != null;
        }
      }

      setState(() {
        preschoolers = allChildren
            .where((child) =>
                calculateAgeInMonths(child['dob']) > 36 &&
                calculateAgeInMonths(child['dob']) <= 62)
            .toList();

        checkInAttendance = {
          for (var child in preschoolers)
            child['id']: existingCheckIns[child['id']] ?? false
        };

        checkOutAttendance = {
          for (var child in preschoolers)
            child['id']: existingCheckOuts[child['id']] ?? false
        };

        attendanceIds = {
          for (var child in preschoolers)
            child['id']: existingAttendance[child['id']] ?? ''
        };
      });
    } catch (e) {
      print("ERROR $e");
    }
  }

  Future<void> updateAttendance(int childId, bool isCheckIn, bool value) async {
    try {
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final String currentId = attendanceIds[childId] ?? '';

      if (value) {
        if (currentId.isEmpty) {
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
          await supabase.from('tbl_attendance').update({
            isCheckIn ? 'check_in' : 'check_out':
                DateTime.now().toIso8601String(),
          }).eq('id', currentId);
        }
      } else if (currentId.isNotEmpty) {
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
      print("ERROR $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating attendance: $e")));
    }
  }

  Widget buildAttendanceTab(bool isCheckIn) {
    final attendanceMap = isCheckIn ? checkInAttendance : checkOutAttendance;
    return preschoolers.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: preschoolers.length,
            itemBuilder: (context, index) {
              final child = preschoolers[index];
              return Card(
                child: ListTile(
                  title: Text(child['name']),
                  trailing: Checkbox(
                    value: attendanceMap[child['id']] ?? false,
                    onChanged: (bool? value) {
                      updateAttendance(child['id'], isCheckIn, value!);
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
        title: const Text("Preschool Attendance"),
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
            buildAttendanceTab(true),
            buildAttendanceTab(false),
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
