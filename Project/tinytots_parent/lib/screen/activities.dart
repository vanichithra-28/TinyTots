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
        title: const Text(
          'Activities',
          style: TextStyle(
            color: Color(0xFFbc6c25),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFFbc6c25)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFbc6c25),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFFbc6c25),
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
          // Activities Tab
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Activities',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFbc6c25),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _activities.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Text(
                              "No activities available",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      : Column(
                          children: _activities.map((activity) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.event,
                                            color: Color(0xFFbc6c25)),
                                        const SizedBox(width: 8),
                                        Text(
                                          formatDate(activity['created_at']),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFbc6c25),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    _activityRow(
                                        'Feed', activity['feed_details']),
                                    _activityRow('Learning',
                                        activity['learning_activities']),
                                    _activityRow('Play time',
                                        activity['play_time_activities']),
                                    _activityRow(
                                        'Nap', activity['nap_schedule']),
                                  ],
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Meal Plan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFbc6c25),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _mealPlans.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Text(
                              "No meal plans available",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _mealPlans.length,
                          itemBuilder: (context, index) {
                            final meal = _mealPlans[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.restaurant_menu,
                                    color: Color(0xFFbc6c25)),
                                title: Text(
                                  meal['meal_name'] ?? 'Meal',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFbc6c25),
                                  ),
                                ),
                                subtitle: Text(
                                  "Day: ${meal['meal_day'] ?? 'N/A'}",
                                  style: const TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
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

  // Helper widget for activity rows
  Widget _activityRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF495057),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
