import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Activities extends StatefulWidget {

  const Activities({super.key, });

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _mealPlans = [];
  List<Map<String, dynamic>> _activities = [];

  @override
  void initState() {
    super.initState();
    fetchMealPlans();
    fetchActivities();
  }

  Future<void> fetchMealPlans() async {
    try {
      final response = await supabase
          .from('tbl_meal')
          .select();

      setState(() {
        _mealPlans = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error fetching meals: $e');
    }
  }

  Future<void> fetchActivities() async {
    try {
      final response = await supabase
          .from('tbl_activity')
          .select();

      setState(() {
        _activities = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error fetching activities: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activities'),
        backgroundColor: Color(0xFFffffff),
      ),
      backgroundColor: Color(0xFFf8f9fa),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Meal Plan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _mealPlans.isEmpty
                  ? Text("No meal plans available")
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _mealPlans.length,
                      itemBuilder: (context, index) {
                        final meal = _mealPlans[index];
                        return Card(
                          child: ListTile(
                            title: Text(meal['meal_name'] ?? 'Meal'),
                            subtitle:
                                Text("Day: ${meal['meal_day'] ?? 'N/A'}"),
                          ),
                        );
                      },
                    ),
              SizedBox(height: 20),
              Text(
                'Activities',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _activities.isEmpty
                  ? Text("No activities available")
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _activities.length,
                      itemBuilder: (context, index) {
                        final activity = _activities[index];
                        return Card(
                          child: ListTile(
                            title: Text(activity['activity_name'] ?? 'Activity'),
                            subtitle: Text(
                                "Time: ${activity['activity_time'] ?? 'N/A'}"),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
