import 'package:flutter/material.dart';
import 'package:tinytots_staff/main.dart';

class PreschoolAttendance extends StatefulWidget {
  const PreschoolAttendance({super.key});

  @override
  State<PreschoolAttendance> createState() => _PreschoolAttendanceState();
}

class _PreschoolAttendanceState extends State<PreschoolAttendance> {
  List<Map<String, dynamic>> preschoolers = [];
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

  Future<void> fetchPreschoolers() async {
    try {
      final response = await supabase.from('tbl_child').select();
      List<Map<String, dynamic>> allChildren =
          List<Map<String, dynamic>>.from(response);

      setState(() {
        preschoolers = allChildren
            .where((child) =>
                convertAgeToMonths(child['age']) > 36 &&
                convertAgeToMonths(child['age']) < 60)
            .toList();
        attendance = {for (var child in preschoolers) child['id']: false};
      });
    } catch (e) {
      print("ERROR $e");
    }
  }

  Future<void> markAttendance() async {
    try {
      for (var child in preschoolers) {
        if (attendance[child['id']] == true) {
          await supabase.from('tbl_attendance').insert({
            'child_id': child['id'],
            'date': DateTime.now().toIso8601String(),
            'check_in':DateTime.now().toIso8601String(),
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
    fetchPreschoolers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      appBar: AppBar(
        title: const Text("Preschool Attendance"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: markAttendance,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: preschoolers.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: preschoolers.length,
                itemBuilder: (context, index) {
                  final child = preschoolers[index];
                  return Card(
                    child: ListTile(
                      title: Text(child['name']),
                      subtitle: Text(child['age']),
                      trailing: Checkbox(
                        value: attendance[child['id']] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            attendance[child['id']] = value!;
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
