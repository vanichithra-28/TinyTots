import 'package:flutter/material.dart';
import 'package:tinytots_staff/main.dart';

class Log extends StatefulWidget {
  final int childId;
  const Log({super.key, required this.childId});

  @override
  State<Log> createState() => _LogState();
}

class _LogState extends State<Log> {
  final TextEditingController learningController = TextEditingController();
  final TextEditingController playtimeController = TextEditingController();
  TimeOfDay? napStartTime;
  TimeOfDay? napEndTime;
  TimeOfDay? playStartTime;
  TimeOfDay? playEndTime;
  String? selectedMealId;
  List<Map<String, dynamic>> meals = [];
  String? allergyStatus; // New variable to store allergy status

  @override
  void initState() {
    super.initState();
    _fetchMeals();
    _fetchAllergyStatus(); // Fetch allergy status
  }

  Future<void> _fetchMeals() async {
    try {
      final response = await supabase.from('tbl_meal').select('id, meal_name');
      setState(() {
        meals = response;
      });
    } catch (e) {
      print('Failed to fetch meals: $e');
    }
  }

  Future<void> _fetchAllergyStatus() async {
    try {
      final response = await supabase
          .from('tbl_child')
          .select('allergy')
          .eq('id', widget.childId)
          .single();
      setState(() {
        allergyStatus = response['allergy'];
      });
    } catch (e) {
      print('Failed to fetch allergy status: $e');
    }
  }

  Future<void> storeData() async {
    try {
      final staffId = supabase.auth.currentUser?.id;
      final napSchedule = napStartTime != null && napEndTime != null
          ? '${napStartTime!.format(context)} - ${napEndTime!.format(context)}'
          : '';
      final playSchedule = playStartTime != null && playEndTime != null
          ? '${playStartTime!.format(context)} - ${playEndTime!.format(context)}'
          : '';

      await supabase.from('tbl_activity').insert([
        {
          'child_id': widget.childId,
          'feed_details': meals.firstWhere((meal) => meal['id'].toString() == selectedMealId)['meal_name'],
          'nap_schedule': napSchedule,
          'learning_activities': learningController.text,
          'play_time_activities': playSchedule,
          'staff_id': staffId,
        }
      ]);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Activity added successfully",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black54,
        ),
      );
    } catch (e) {
      print('Upload failed: $e');
    }
  }

  Future<void> _selectNapTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          napStartTime = picked;
        } else {
          napEndTime = picked;
        }
      });
    }
  }

  Future<void> _selectPlayTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          playStartTime = picked;
        } else {
          playEndTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFbc6c25),
        title: const Text('Activity Log'),
      ),
      backgroundColor: const Color(0xfff8f9fa),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Allergy Note
              if (allergyStatus != null && allergyStatus!.isNotEmpty && allergyStatus != 'None')
                Card(
                  color: Colors.red[50],
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: Icon(Icons.warning, color: Colors.redAccent),
                    title: Text(
                      'Allergy: $allergyStatus',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
              // Feed Details
              Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Feed Details",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: 'Feed details',
                        ),
                        isExpanded: true,
                        value: selectedMealId,
                        items: meals.map((meal) {
                          return DropdownMenuItem<String>(
                            value: meal['id'].toString(),
                            child: Text(meal['meal_name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMealId = value;
                          });
                        },
                        hint: const Text('Select a meal'),
                      ),
                    ],
                  ),
                ),
              ),
              // Nap Schedule
              Card(
                 color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nap Schedule",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: Color(0xFFbc6c25)),
                                ),
                              ),
                              icon: Icon(Icons.bedtime),
                              onPressed: () => _selectNapTime(context, true),
                              label: Text(
                                napStartTime == null
                                    ? 'Start'
                                    : napStartTime!.format(context),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: Color(0xFFbc6c25)),
                                ),
                              ),
                              icon: Icon(Icons.bedtime_off),
                              onPressed: () => _selectNapTime(context, false),
                              label: Text(
                                napEndTime == null
                                    ? 'End'
                                    : napEndTime!.format(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Learning Activities
              Card(
                 color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Learning Activities",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: learningController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: 'Describe activities',
                          alignLabelWithHint: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Play Time
              Card(
                 color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Play Time",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: Color(0xFFbc6c25)),
                                ),
                              ),
                              icon: Icon(Icons.play_arrow),
                              onPressed: () => _selectPlayTime(context, true),
                              label: Text(
                                playStartTime == null
                                    ? 'Start'
                                    : playStartTime!.format(context),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: Color(0xFFbc6c25)),
                                ),
                              ),
                              icon: Icon(Icons.stop),
                              onPressed: () => _selectPlayTime(context, false),
                              label: Text(
                                playEndTime == null
                                    ? 'End'
                                    : playEndTime!.format(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Upload Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFbc6c25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 3,
                  ),
                  onPressed: storeData,
                  icon: Icon(Icons.cloud_upload, color: Color(0xfff8f9fa)),
                  label: const Text(
                    'Upload',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xfff8f9fa),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}