import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:tinytots_admin/main.dart'; // Assuming supabase is initialized here

class AttendanceList extends StatefulWidget {
  const AttendanceList({super.key});

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  Map<String, int> dailyAttendance = {'Infant': 0, 'Toddler': 0, 'Preschool': 0};
  Map<String, int> monthlyAttendance = {'Infant': 0, 'Toddler': 0, 'Preschool': 0};
  bool isLoading = true; // Loading state
  String? errorMessage; // Error state

  @override
  void initState() {
    super.initState();
    fetchAttendanceData();
  }

  int calculateAgeInMonths(String dob) {
    try {
      DateTime birthDate = DateFormat("yyyy-MM-dd").parse(dob);
      DateTime today = DateTime.now();
      int years = today.year - birthDate.year;
      int months = today.month - birthDate.month;
      if (today.day < birthDate.day) {
        months -= 1;
      }
      return (years * 12) + months;
    } catch (e) {
      print("Error parsing date: $e");
      return 0;
    }
  }

  Future<void> fetchAttendanceData() async {
    try {
      // Check if user is signed in
      final user = supabase.auth.currentUser;
      if (user == null) {
        setState(() {
          errorMessage = 'Please sign in to view attendance.';
          isLoading = false;
        });
        return;
      }

      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String currentMonth = DateFormat('yyyy-MM').format(DateTime.now());

      final attendanceResponse = await supabase
          .from('tbl_attendance')
          .select('*, tbl_child(dob)')
          .eq('role', 'CHILD');

      Map<String, int> dailyTemp = {'Infant': 0, 'Toddler': 0, 'Preschool': 0};
      Map<String, int> monthlyTemp = {'Infant': 0, 'Toddler': 0, 'Preschool': 0};

      for (var record in attendanceResponse) {
        final childData = record['tbl_child'];
        if (childData != null && childData['dob'] != null) {
          int ageInMonths = calculateAgeInMonths(childData['dob']);
          String category = '';

          if (ageInMonths <= 12) {
            category = 'Infant';
          } else if (ageInMonths <= 36) {
            category = 'Toddler';
          } else if (ageInMonths <= 62) {
            category = 'Preschool';
          }

          String recordDate = record['date'];

          // Daily data for today
          if (recordDate == todayDate && record['check_in'] != null) {
            dailyTemp[category] = (dailyTemp[category] ?? 0) + 1;
          }

          // Monthly data
          if (recordDate.startsWith(currentMonth) && record['check_in'] != null) {
            monthlyTemp[category] = (monthlyTemp[category] ?? 0) + 1;
          }
        }
      }

      setState(() {
        dailyAttendance = dailyTemp;
        monthlyAttendance = monthlyTemp;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching attendance data: $e';
        isLoading = false;
      });
      print('Error fetching attendance data: $e');
    }
  }

  Widget buildPieChart(Map<String, int> data, String title) {
    double total = data.values.fold(0, (a, b) => a + b).toDouble();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xffB4B4B6),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 300,
          child: total == 0
              ? const Center(child: Text('No attendance data'))
              : PieChart(
                  PieChartData(
                    sections: [
                      if ((data['Infant'] ?? 0) > 0)
                        PieChartSectionData(
                          color: Color(0xffffafcc),
                          value: (data['Infant'] ?? 0).toDouble(),
                          title: 'Infant\n${(((data['Infant'] ?? 0) / total) * 100).toStringAsFixed(1)}%',
                          radius: 100,
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      if ((data['Toddler'] ?? 0) > 0)
                        PieChartSectionData(
                          color: Color(0xffa2d2ff),
                          value: (data['Toddler'] ?? 0).toDouble(),
                          title: 'Toddler\n${(((data['Toddler'] ?? 0) / total) * 100).toStringAsFixed(1)}%',
                          radius: 100,
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      if ((data['Preschool'] ?? 0) > 0)
                        PieChartSectionData(
                          color: Color(0xffcdb4db),
                          value: (data['Preschool'] ?? 0).toDouble(),
                          title: 'Preschool\n${(((data['Preschool'] ?? 0) / total) * 100).toStringAsFixed(1)}%',
                          radius: 100,
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                    ],
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                  ),
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 400,
                color: const Color(0xffffffff),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                        ? Center(child: Text(errorMessage!))
                        : buildPieChart(dailyAttendance, 'Daily Attendance'),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 400,
                color: const Color(0xffffffff),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                        ? Center(child: Text(errorMessage!))
                        : buildPieChart(
                            monthlyAttendance,
                            'Monthly Attendance (${DateFormat('MMMM yyyy').format(DateTime.now())})',
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}