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

  List<Map<String, dynamic>> infants = [];
  List<Map<String, dynamic>> toddlers = [];
  List<Map<String, dynamic>> preschoolers = [];

  Map<String, String> paymentStatusMap = {}; // key = child_id, value = 'Pending'/'Completed'

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

  Future<void> fetchPaymentStatus() async {
    final response = await supabase.from('tbl_payment').select();
    for (var payment in response) {
      final childId = payment['child_id'].toString();
      final status = payment['status'] == 1 ? 'Completed' : 'Pending';
      paymentStatusMap[childId] = status;
    }
  }

  Future<void> fetchChildren() async {
    try {
      final childrenResponse =
          await supabase.from('tbl_child').select().eq('status', 1);
      List<Map<String, dynamic>> allChildren =
          List<Map<String, dynamic>>.from(childrenResponse);

      await fetchPaymentStatus();

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

  Widget childTile(Map child) {
    final paymentStatus =
        paymentStatusMap[child['id'].toString()] ?? 'Pending';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xfff0f4ff),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(child['name'] ?? 'Unnamed Child',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Payment: $paymentStatus'),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchChildren();
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
         decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
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
                            return childTile(infants[index]);
                          },
                        ),
                  toddlers.isEmpty
                      ? const Center(child: Text('No toddlers found'))
                      : ListView.builder(
                          itemCount: toddlers.length,
                          itemBuilder: (context, index) {
                            return childTile(toddlers[index]);
                          },
                        ),
                  preschoolers.isEmpty
                      ? const Center(child: Text('No preschoolers found'))
                      : ListView.builder(
                          itemCount: preschoolers.length,
                          itemBuilder: (context, index) {
                            return childTile(preschoolers[index]);
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
