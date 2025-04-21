import 'package:flutter/material.dart';
import 'package:tinytots_staff/main.dart';
import 'package:tinytots_staff/screen/changepwd.dart';
import 'package:tinytots_staff/screen/edit.dart';
import 'package:tinytots_staff/screen/staffattendance.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = true;
  Map<String, dynamic> staffData = {};

  Future<void> display() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await supabase
          .from('tbl_staff')
          .select()
          .eq('id', supabase.auth.currentUser!.id)
          .single();
      setState(() {
        staffData = response;
        isLoading = false; // Fixed: Set isLoading to false after data is fetched
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('ERROR DISPLAYING PROFILE DATA: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    display();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6), // Light background
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            height: 700,
            width: 500,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.13),
                  spreadRadius: 5,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: const Color(0xFFbc6c25),
                      backgroundImage: staffData['staff_photo'] != null && staffData['staff_photo'] != ""
                          ? NetworkImage(staffData['staff_photo'])
                          : null,
                      child: staffData['staff_photo'] == null || staffData['staff_photo'] == ""
                          ? const Icon(Icons.person, size: 80, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      staffData['staff_name'] ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFbc6c25),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      staffData['staff_email'] ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF495057),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      staffData['staff_contact'] ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF495057),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      staffData['staff_address'] ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF495057),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      color: Color(0xFFbc6c25),
                      thickness: 1.2,
                      indent: 30,
                      endIndent: 30,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditProfile()),
                        );
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFbc6c25),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      label: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xfff8f9fa),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Change()),
                        );
                      },
                      icon: const Icon(Icons.lock, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFbc6c25),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      label: const Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xfff8f9fa),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StaffAttendancePage()),
                        );
                      },
                      icon: const Icon(Icons.calendar_today, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFbc6c25),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      label: const Text(
                        'View Attendance',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xfff8f9fa),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}