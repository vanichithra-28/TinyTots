import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:tinytots_admin/main.dart';

class Task extends StatefulWidget {
  final String staffId;

  const Task({super.key, required this.staffId});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> with SingleTickerProviderStateMixin {
  final TextEditingController taskController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  List<Map<String, dynamic>> _taskList = [];
  Future<void> insert() async {
    try {
      String task = taskController.text;
      String endDate = endDateController.text;
      await supabase.from('tbl_task').insert(
          {'task': task, 'end_date': endDate, 'staff_id': widget.staffId});
      display();
      taskController.clear();
      endDateController.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Inserted"),
      ));
    } catch (e) {
      print("ERROR INSERTING TASKS: $e");
    }
  }

  Future<void> display() async {
    try {
      final response = await supabase
          .from('tbl_task')
          .select()
          .eq("staff_id", widget.staffId);
      setState(() {
        _taskList = response;
      });
    } catch (e) {
      print("ERROR FETCHING TASKS $e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        endDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> delete(int delId) async {
    try {
      await supabase.from('tbl_task').delete().eq('id', delId);
      display();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          " Deleted",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      print('ERROR IN DELETING$e');
    }
  }

  String formatDate(String timestamp) {
    DateTime date = DateTime.parse(timestamp);
    return DateFormat('dd-MM-yyyy').format(date); // Formats to YYYY-MM-DD
  }

  @override
  void initState() {
    super.initState();
    display();
  }

  @override
  Widget build(BuildContext context) {
    print("Staffid: ${widget.staffId}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff3e53a0),
        title: const Text('Task', style: TextStyle(color: Color(0xffffffff))),
        elevation: 2,
      ),
      backgroundColor: const Color(0xFFeceef0),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Assign Task",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xff3e53a0),
              ),
            ),
            const SizedBox(height: 18),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        controller: taskController,
                        decoration: const InputDecoration(
                          labelText: 'Task',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Enter a task' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: endDateController,
                        decoration: const InputDecoration(
                          labelText: 'End Date',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff3e53a0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      ),
                      onPressed: () {
                        if (taskController.text.isNotEmpty &&
                            endDateController.text.isNotEmpty) {
                          insert();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter all fields"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.send, color: Color(0xFFeceef0)),
                      label: const Text('Submit', style: TextStyle(color: Color(0xFFeceef0))),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Divider(thickness: 1.5),
            const SizedBox(height: 12),
            const Text(
              "Task List",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff3e53a0),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFeceef0),
                    width: 2,
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Sl.No', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Task', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Start Date', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('End Date', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: _taskList.asMap().entries.map((entry) {
                      final status = entry.value['status'] == 1
                          ? Chip(
                              label: const Text('Completed'),
                              backgroundColor: Colors.green.shade100,
                              labelStyle: const TextStyle(color: Colors.green),
                            )
                          : Chip(
                              label: const Text('Pending'),
                              backgroundColor: Colors.red.shade100,
                              labelStyle: const TextStyle(color: Colors.red),
                            );
                      return DataRow(cells: [
                        DataCell(Text((entry.key + 1).toString())),
                        DataCell(Text(entry.value['task'] ?? '')),
                        DataCell(Text(formatDate(entry.value['created_at']))),
                        DataCell(Text(formatDate(entry.value['end_date']))),
                        DataCell(status),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              delete(entry.value['id']);
                            },
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
