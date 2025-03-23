import 'package:flutter/material.dart';
import 'package:tinytots_staff/main.dart';

class Infant extends StatefulWidget {
  const Infant({super.key});

  @override
  State<Infant> createState() => _InfantState();
}

class _InfantState extends State<Infant> {
  List<Map<String, dynamic>> infants = [];
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

  Future<void> fetchInfants() async {
    try {
      final response = await supabase.from('tbl_child').select();
      List<Map<String, dynamic>> allChildren =
          List<Map<String, dynamic>>.from(response);

      setState(() {
        infants = allChildren
            .where((child) => convertAgeToMonths(child['age']) <= 12)
            .toList();
        attendance = {for (var infant in infants) infant['id']: false};
      });
    } catch (e) {
      print("ERROR $e");
    }
  }

  Future<void> markAttendance() async {
    try {
      for (var infant in infants) {
        if (attendance[infant['id']] == true) {
          await supabase.from('tbl_attendance').insert({
            'child_id': infant['id'],
            'date': DateTime.now().toIso8601String(),
            'check_in':DateTime.now().toIso8601String(),
            'status': 1
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
    fetchInfants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      appBar: AppBar(
        title: const Text("Infant Attendance"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: markAttendance,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: infants.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: infants.length,
                itemBuilder: (context, index) {
                  final infant = infants[index];
                  return Card(
                    child: ListTile(
                      title: Text(infant['name']),
                      subtitle: Text(infant['age']),
                      trailing: Checkbox(
                        value: attendance[infant['id']] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            attendance[infant['id']] = value!;
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
