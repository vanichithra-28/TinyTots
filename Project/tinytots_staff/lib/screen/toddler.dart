import 'package:flutter/material.dart';
import 'package:tinytots_staff/main.dart';

class ToddlerAttendance extends StatefulWidget {
  const ToddlerAttendance({super.key});

  @override
  State<ToddlerAttendance> createState() => _ToddlerAttendanceState();
}

class _ToddlerAttendanceState extends State<ToddlerAttendance> {
  List<Map<String, dynamic>> toddlers = [];
  Map<int, bool> attendance = {};

  int convertAgeToMonths(String ageText) {
    final parts = ageText.split(" ");
    int years = 0, months = 0;
    for (int i = 0; i < parts.length; i++) {
      if (parts[i] == "year" || parts[i] == "years") {
        years = int.parse(parts[i - 1]);
      } else if (parts[i] == "month" || parts[i] == "months") {
        months = int.parse(parts[i - 1]);
      }
    }
    return (years * 12) + months;
  }

  Future<void> fetchToddlers() async {
    try {
      final response = await supabase.from('tbl_child').select();
      List<Map<String, dynamic>> allChildren =
          List<Map<String, dynamic>>.from(response);

      setState(() {
        toddlers = allChildren
            .where((child) =>
                convertAgeToMonths(child['age']) > 12 &&
                convertAgeToMonths(child['age']) <= 36)
            .toList();
        attendance = {for (var toddler in toddlers) toddler['id']: false};
      });
    } catch (e) {
      print("ERROR $e");
    }
  }

  Future<void> markAttendance() async {
    try {
      for (var toddler in toddlers) {
        if (attendance[toddler['id']] == true) {
          await supabase.from('tbl_attendance').insert({
            'child_id': toddler['id'],
            'date': DateTime.now().toIso8601String(),
            'status': 'Present'
          });
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Attendance marked successfully!"))
      );
    } catch (e) {
      print("ERROR $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchToddlers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      appBar: AppBar(
        title: const Text("Toddler Attendance"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: markAttendance,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: toddlers.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: toddlers.length,
                itemBuilder: (context, index) {
                  final toddler = toddlers[index];
                  return Card(
                    child: ListTile(
                      title: Text(toddler['name']),
                      subtitle: Text(toddler['age']),
                      trailing: Checkbox(
                        value: attendance[toddler['id']] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            attendance[toddler['id']] = value!;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
