import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  List<Map<String, dynamic>> tasks = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final currentUserId = Supabase.instance.client.auth.currentUser?.id;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final List<dynamic>? response = await Supabase.instance.client
          .from('tbl_task')
          .select()
          .eq('staff_id', currentUserId)
          .order('created_at', ascending: false);

      if (response == null) {
        throw Exception('No data received');
      }

      setState(() {
        tasks = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading tasks. Please try again.';
      });
    }
  }

  Future<void> updateTaskStatus(int taskId, bool isCompleted) async {
    try {
      await Supabase.instance.client
          .from('tbl_task')
          .update({'status': isCompleted ? 1:0})
          .match({'id': taskId});
      fetchTasks();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update task status.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFbc6c25),
        title: const Text('Task'),
      ),
      backgroundColor: const Color(0xfff8f9fa),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 20,
                    columns: const [
                      DataColumn(label: Text('Task Name')),
                      DataColumn(label: Text('Description')),
                      DataColumn(label: Text('Action')),
                      DataColumn(label: Text('Status')),
                    ],
                    rows: tasks.map((task) {
                      bool isCompleted = task['status'] == 'Completed';
                      return DataRow(cells: [
                        DataCell(Text(task['task'] ?? 'N/A')),
                        DataCell(Text(task['end_date'] ?? 'N/A')),
                        DataCell(Checkbox(
                          value: isCompleted,
                          onChanged: (bool? value) {
                            if (value != null) {
                              updateTaskStatus(task['id'], value);
                            }
                          },
                        )),
                        DataCell(task['status'] == 1
                          ? Text(
                              'Completed',
                              style: TextStyle(color: Colors.green),
                            )
                          : Text(
                             'Pending',
                              style: TextStyle(color: Colors.red),
                            )),
                      ]);
                    }).toList(),
                  ),
                ),
    );
  }
}
