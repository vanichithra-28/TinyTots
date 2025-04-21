import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> completedTasks = [];
  List<Map<String, dynamic>> pendingTasks = [];
  bool isLoading = true;
  String? errorMessage;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        completedTasks = List<Map<String, dynamic>>.from(
            response.where((task) => task['status'] == 1));
        pendingTasks = List<Map<String, dynamic>>.from(
            response.where((task) => task['status'] == 0));
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
          .update({'status': isCompleted ? 1 : 0})
          .match({'id': taskId});
      fetchTasks();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update task status.')),
      );
    }
  }

  Widget buildTaskList(List<Map<String, dynamic>> tasks) {
    return tasks.isEmpty
        ? const Center(child: Text('No tasks found'))
        : ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              bool isCompleted = task['status'] == 1;
              return Card(
                child: ListTile(
                  title: Text(task['task'] ?? 'N/A'),
                  subtitle: Text("End Date: ${task['end_date'] ?? 'N/A'}"),
                  trailing: Checkbox(
                    value: isCompleted,
                    onChanged: (bool? value) {
                      if (value != null) {
                        updateTaskStatus(task['id'], value);
                      }
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
        elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFFbc6c25),
        title: const Text("Tasks", style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Pending"),
            Tab(text: "Completed"),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : TabBarView(
                  controller: _tabController,
                  children: [
                    buildTaskList(pendingTasks),
                    buildTaskList(completedTasks),
                  ],
                ),
    );
  }
}
