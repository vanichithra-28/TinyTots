import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tinytots_staff/screen/activitylog.dart';

class ChildActivity extends StatefulWidget {
  const ChildActivity({super.key});

  @override
  State<ChildActivity> createState() => _ChildActivityState();
}

class _ChildActivityState extends State<ChildActivity> {
  final supabase = Supabase.instance.client;
  List<dynamic> infants = [];
  List<dynamic> toddlers = [];
  List<dynamic> preschoolers = [];
  
  Map<int, bool> checkInAttendance = {};
  Map<int, bool> checkOutAttendance = {};
  Map<int, String> attendanceIds = {};

  @override
  void initState() {
    super.initState();
    fetchChildren();
  }

  int calculateAgeInMonths(String dob) {
    DateTime birthDate = DateTime.parse(dob);
    DateTime today = DateTime.now();
    int months =
        (today.year - birthDate.year) * 12 + today.month - birthDate.month;

    if (today.day < birthDate.day) {
      months--;
    }

    return months;
  }

  Future<void> fetchChildren() async {
    try {
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

     
      final childrenResponse = await supabase.from('tbl_child').select().eq('status', 1);
      List<Map<String, dynamic>> allChildren = List<Map<String, dynamic>>.from(childrenResponse);

     
      final attendanceResponse = await supabase.from('tbl_attendance').select().eq('date', todayDate).eq('role','CHILD');

      Map<int, String> existingAttendance = {};
      Map<int, bool> existingCheckIns = {};
      Map<int, bool> existingCheckOuts = {};

      for (var record in attendanceResponse) {
        final id = record['id'];
        if (id != null) {
          existingAttendance[record['child_id']] = id.toString();
          existingCheckIns[record['child_id']] = record['check_in'] != null;
          existingCheckOuts[record['child_id']] = record['check_out'] != null;
        }
      }

      setState(() {
        // Categorize children by age
        infants = allChildren
            .where((child) => calculateAgeInMonths(child['dob']) <= 12) // 0-12 months
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

        // Set attendance status for all children
        checkInAttendance = {
          for (var child in allChildren)
            if (child['id'] != null) child['id'] as int: existingCheckIns[child['id']] ?? false
        };

        checkOutAttendance = {
          for (var child in allChildren)
            if (child['id'] != null) child['id'] as int: existingCheckOuts[child['id']] ?? false
        };

        attendanceIds = {
          for (var child in allChildren)
            if (child['id'] != null) child['id'] as int: existingAttendance[child['id']] ?? ''
        };
      });
    } catch (e) {
      print("ERROR FETCHING CHILDREN: $e");
    }
  }

  Widget buildTabContent(List<dynamic> children, String ageGroup) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            const SizedBox(height: 16),
            if (children.isEmpty)
              const Center(child: Text('No children in this age group'))
            else
              ...children.map((child) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Log(childId: child['id'])),
                  );
                },
                child: Card(
                  color: const Color(0xfff8f9fa),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          child['name'] ?? 'No Name',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.login,
                              color: checkInAttendance[child['id']] == true
                                  ? Colors.green
                                  : Colors.grey,
                              size: 20,
                            ),
                            
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFFbc6c25),
          title: const Text('Child Activity', style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),),
          bottom: const TabBar(
            labelColor: Color(0xFFbc6c25),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFFbc6c25),
            tabs: [
              Tab(text: 'Infants'),
              Tab(text: 'Toddlers'),
              Tab(text: 'Preschoolers'),
            ],
          ),
        ),
        backgroundColor: const Color(0xfff8f9fa),
        body: TabBarView(
          children: [
            buildTabContent(infants, 'Infant'),
            buildTabContent(toddlers, 'Toddler'),
            buildTabContent(preschoolers, 'Preschooler'),
          ],
        ),
      ),
    );
  }
}