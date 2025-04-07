import 'package:flutter/material.dart';
import 'package:tinytots_admin/main.dart';

class Classroom extends StatefulWidget {
  const Classroom({super.key});

  @override
  State<Classroom> createState() => _ClassroomState();
}

class _ClassroomState extends State<Classroom>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  List<dynamic> infants = [];
  List<dynamic> toddlers = [];
  List<dynamic> preschoolers = [];

  int calculateAgeInMonths(String dob) {
    DateTime birthDate = DateTime.parse(dob);
    DateTime today = DateTime.now();
    int months =
        (today.year - birthDate.year) * 12 + today.month - birthDate.month;
    return months;
  }

  Future<void> fetchChildren() async {
    try {

      final childrenResponse =
          await supabase.from('tbl_child').select().eq('status', 1);
      List<Map<String, dynamic>> allChildren =
          List<Map<String, dynamic>>.from(childrenResponse);

      

      setState(() {
        infants = allChildren
            .where((child) => calculateAgeInMonths(child['dob']) <= 12)
            .toList();

        toddlers = allChildren
            .where((child) =>
                calculateAgeInMonths(child['dob']) > 12 &&
                calculateAgeInMonths(child['dob']) <= 36)
            .toList();

        preschoolers = allChildren
            .where((child) =>
                calculateAgeInMonths(child['dob']) > 36 &&
                calculateAgeInMonths(child['dob']) <= 62)
            .toList();

       
      });
    } catch (e) {
      print("ERROR FETCHING CHILDREN: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchChildren(); // Fetch children when the widget initializes
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 600,
        width: 1000,
        color: const Color(0xffffffff),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Infants'),
                Tab(text: 'Toddlers'),
                Tab(text: 'Preschoolers'),
              ],
              labelColor: Colors.black,
              indicatorColor: Colors.blue,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  infants.isEmpty
                      ? const Center(child: Text('No infants found'))
                      : ListView.builder(
                          itemCount: infants.length,
                          itemBuilder: (context, index) {
                            final child = infants[index];
                            return ListTile(
                              title: Text(child['name'] ?? 'Unnamed Child'),
                              
                            );
                          },
                        ),
                  toddlers.isEmpty
                      ? const Center(child: Text('No toddlers found'))
                      : ListView.builder(
                          itemCount: toddlers.length,
                          itemBuilder: (context, index) {
                            final child = toddlers[index];
                            return ListTile(
                              title: Text(child['name'] ?? 'Unnamed Child'),
                              
                            );
                          },
                        ),
                  preschoolers.isEmpty
                      ? const Center(child: Text('No preschoolers found'))
                      : ListView.builder(
                          itemCount: preschoolers.length,
                          itemBuilder: (context, index) {
                            final child = preschoolers[index];
                            return ListTile(
                              title: Text(child['name'] ?? 'Unnamed Child'),
                              
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}