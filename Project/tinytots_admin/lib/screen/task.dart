// ignore_for_file: sort_child_properties_last

import 'dart:math';
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
  @override
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
       backgroundColor:Color(0xff3e53a0),
        title: Text('Task',style: TextStyle(color: Color(0xffffffff)),),
      ),
      backgroundColor: Color(0xFFeceef0),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextFormField(
                    controller: taskController,
                    decoration: InputDecoration(
                      labelText: 'Task',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: endDateController,
                    decoration: InputDecoration(
                      labelText: 'End Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff3e53a0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4))),
                    onPressed: () {
                      insert();
                    },
                    child: Text('submit',style: TextStyle(color: Color(0xFFeceef0)),))
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Center(
            child: Container(
                width: 1000,
                padding: EdgeInsets.all(16), // Padding inside the container
                margin: EdgeInsets.all(16), // Margin outside the container
                decoration: BoxDecoration(
                  color: Color(0xffffffff), // Background color of the container
                  borderRadius: BorderRadius.zero, // Rounded corners
                  border: Border.all(
                    color: Color(0xFFeceef0), // Border color
                    width: 2, // Border width
                  ),
                ),
                child: SingleChildScrollView(
                    child: DataTable(
                  columns: [
                    DataColumn(
                        label: Text('Sl.No',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff252422)))),
                    DataColumn(
                        label: Text('Task',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff252422)))),
                    DataColumn(
                        label: Text('Start Date',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff252422)))),
                    DataColumn(
                        label: Text('End Date',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff252422)))),
                    DataColumn(
                        label: Text('Status',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff252422)))),
                    DataColumn(
                        label: Text('Action',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff252422)))),
                  ],
                  rows: _taskList.asMap().entries.map((entry) {
                    return DataRow(cells: [
                      DataCell(Text(
                        (entry.key + 1).toString(),
                        style: TextStyle(color: Color(0xff252422)),
                      )),
                      DataCell(Text(
                        entry.value['task'],
                        style: TextStyle(color: Color(0xff252422)),
                      )),
                      DataCell(Text(formatDate(entry.value['created_at'])
                        ,
                        style: TextStyle(color: Color(0xff252422)),
                      )),
                      DataCell(Text(formatDate(entry.value['end_date'])
                        ,
                        style: TextStyle(color: Color(0xff252422)),
                      )),
                      DataCell(entry.value['status'] == 1
                          ? Text(
                              'Completed',
                              style: TextStyle(color: Colors.green),
                            )
                          : Text(
                             'Pending',
                              style: TextStyle(color: Colors.red),
                            )),
                      DataCell(IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      delete(entry.value['id']);
                    },
                  )),
                    ]);
                  }).toList(),
                ))),
          )
        ],
      ),
    );
  }
}
