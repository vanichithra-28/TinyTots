import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities>
    with SingleTickerProviderStateMixin {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _mealPlans = [];
  List<Map<String, dynamic>> _activities = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchMealPlans();
    fetchActivities();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchMealPlans() async {
    try {
     
      final response = await supabase.from('tbl_meal').select();

      setState(() {
        _mealPlans = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error fetching meals: $e');
    }
  }

  Future<void> fetchActivities() async {
    try {
       final prefs = await SharedPreferences.getInstance();
    int? childId = prefs.getInt('child');
    final user = supabase.auth.currentUser;
      if (user != null && childId != null) {
      final response = await supabase
          .from('tbl_activity')
          .select()
          .eq('child_id', childId);
      
      setState(() {
        _activities = List<Map<String, dynamic>>.from(response);
      });
    }
      
    } catch (e) {
      print('Error fetching activities: $e');
    }
  }

  String formatDate(String? timestamp) {
    if (timestamp == null) return 'N/A';
    try {
      final dateTime = DateTime.parse(timestamp);
      return DateFormat('MMM dd, yyyy')
          .format(dateTime); // e.g., "Mar 26, 2025"
    } catch (e) {
      return 'Invalid Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities'),
        backgroundColor: const Color(0xFFffffff),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Activities'),
            Tab(text: 'Meal Plans'),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFf8f9fa),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Activities',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _activities.isEmpty
                      ? const Text("No activities available")
                      : Column(
                          children: _activities.map((activity) {
                            return SizedBox(
                              width: double.infinity,
                              child: Card(
                                color: Color(0xffffffff),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date: ${formatDate(activity['created_at'])}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Feed: ${activity['feed_details'] ?? 'N/A'}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Learning: ${activity['learning_activities'] ?? 'N/A'}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Play time: ${activity['play_time_activities'] ?? 'N/A'}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Nap: ${activity['nap_schedule'] ?? 'N/A'}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                ],
              ),
            ),
          ),
          // Meal Plans Tab
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Meal Plan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _mealPlans.isEmpty
                      ? const Text("No meal plans available")
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _mealPlans.length,
                          itemBuilder: (context, index) {
                            final meal = _mealPlans[index];
                            return Card(
                              color: Color(0xffffffff),
                              child: ListTile(
                                title: Text(meal['meal_name'] ?? 'Meal'),
                                subtitle:
                                    Text("Day: ${meal['meal_day'] ?? 'N/A'}"),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
