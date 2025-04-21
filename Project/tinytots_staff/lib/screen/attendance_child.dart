import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:tinytots_staff/screen/infant.dart';
import 'package:tinytots_staff/screen/prescchooler.dart';
import 'package:tinytots_staff/screen/toddler.dart';

class AttendanceChild extends StatefulWidget {
  const AttendanceChild({super.key});

  @override
  State<AttendanceChild> createState() => _AttendanceChildState();
}

class _AttendanceChildState extends State<AttendanceChild> {
  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width > 600 ? 400 : double.infinity;

    Widget buildAttendanceCard({
      required VoidCallback onTap,
      required Widget icon,
      required String label,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Container(
            width: cardWidth,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(height: 18),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFbc6c25),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFFbc6c25),
        title: const Text('Attendance',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
      ),
      backgroundColor: const Color(0xfff8f9fa),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildAttendanceCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Infant()),
                    );
                  },
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedBaby01,
                    color: Colors.brown[700]!,
                    size: 70.0,
                  ),
                  label: "",
                ),
                buildAttendanceCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ToddlerAttendance()),
                    );
                  },
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedChild,
                    color: Colors.brown[700]!,
                    size: 70.0,
                  ),
                  label: "",
                ),
                buildAttendanceCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PreschoolAttendance()),
                    );
                  },
                  icon: Image.asset(
                    'assets/children.png',
                    height: 70,
                    width: 70,
                    fit: BoxFit.contain,
                  ),
                  label: "",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
