import 'package:flutter/material.dart';
import 'package:tinytots_staff/main.dart';

class Log extends StatefulWidget {
  final int childId;
  const Log({super.key, required this.childId});

  @override
  State<Log> createState() => _LogState();
}

class _LogState extends State<Log> {
  final TextEditingController feedController = TextEditingController();
  TimeOfDay? napStartTime;
  TimeOfDay? napEndTime;
  TimeOfDay? playStartTime;
  TimeOfDay? playEndTime;
  final TextEditingController learningController = TextEditingController();
  final TextEditingController playtimeController = TextEditingController();

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
          'feed_details': feedController.text,
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
      print(' upload failed: $e');
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: feedController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'Feed details',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () => _selectNapTime(context, true),
                      child: Text(
                        napStartTime == null
                            ? 'Select Nap Start'
                            : 'Start: ${napStartTime!.format(context)}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () => _selectNapTime(context, false),
                      child: Text(
                        napEndTime == null
                            ? 'Select Nap End'
                            : 'End: ${napEndTime!.format(context)}',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: learningController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'Learning activities',
                  alignLabelWithHint: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () => _selectPlayTime(context, true),
                      child: Text(
                        playStartTime == null
                            ? 'Select Play Start'
                            : 'Start: ${playStartTime!.format(context)}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () => _selectPlayTime(context, false),
                      child: Text(
                        playEndTime == null
                            ? 'Select Play End'
                            : 'End: ${playEndTime!.format(context)}',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFbc6c25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: storeData,
              child: const Text(
                'Upload',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xfff8f9fa),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
