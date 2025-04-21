import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinytots_parent/screen/dashboard_content.dart';
import 'package:tinytots_parent/screen/intro.dart';

import 'package:tinytots_parent/screen/posts.dart';
import 'package:tinytots_parent/screen/profile.dart';

import '../main.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required childId});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  List<String> pageTitle = [
    "Dashboard",
    "Profile",
    "Post",
    
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentCheck();
  }

  List<Widget> pages = [DashboardContent(), Profile(), Posts(),];
  Future<void> paymentCheck() async {
  try {
    final now = DateTime.now();
    print(now.month);
    final prefs = await SharedPreferences.getInstance();
    final int? childId = prefs.getInt('child');
    if (childId == null) {
      print("Child ID not found in SharedPreferences");
      return;
    }

    // Check for any pending (unpaid) payments up to now.
    final pendingPayments = await supabase
        .from('tbl_payment')
        .select()
        .eq('child_id', childId)
        .eq('status', 0)
        .lte('due_date', now.toIso8601String());
    if (pendingPayments.isNotEmpty) {
      // If there is any pending payment, show the payment reminder alert.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Payment Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: Lottie.asset(
                  'assets/pending.json',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10),
              const Text('Payment Pending.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      // Do not create a new payment entry when unpaid payments exist.
      return;
    }

    // Define the due date for the current month.
    final dueDate = DateTime(now.year, now.month, 4);

    // Check if a payment entry for the current month already exists
    final currentMonthPayment = await supabase
        .from('tbl_payment')
        .select()
        .eq('child_id', childId)
        .eq('due_date', dueDate.toIso8601String());
    if ((currentMonthPayment as List).isNotEmpty) {
      // A payment entry for this month already exists.
      return;
    }

    // Retrieve fee type from the child record.
    final childResponse = await supabase
        .from('tbl_child')
        .select('fee_type')
        .eq('id', childId)
        .single();
    final feeType = childResponse['fee_type'];
    print(feeType);

    // Retrieve fee amount from fees table using the fee type.
    final feeResponse = await supabase
        .from('tbl_fees')
        .select('fee_amount')
        .eq('fee_name', feeType)
        .single();
    print(feeResponse);
    final feeAmount = feeResponse['fee_amount'];

    // Insert a new payment record for the current month.
    await supabase.from('tbl_payment').insert({
      'child_id': childId,
      'due_date': dueDate.toIso8601String(),
      'amount_due': feeAmount,
      'status': 0, // pending status
    });
  } catch (e) {
    print('Error: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
        title: Text(pageTitle[_selectedIndex]),
      ),
      backgroundColor: Color(0xfff8f9fa),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        selectedItemColor: Color(0xFF000000),
        unselectedItemColor: Color(0xFF000000),
        backgroundColor: Color(0xFFFFFFFF),
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        onTap: (value) async {
          if (value == 3) {
            // Show confirmation dialog before logout
            final shouldLogout = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                  TextButton(
                    child: const Text('Logout', style: TextStyle(color: Color(0xFFbc6c25))),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ],
              ),
            );
            if (shouldLogout == true) {
              // TODO: Add your logout logic here (e.g., clear auth/session)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Intro()),
              );
            }
          } else {
            setState(() {
              _selectedIndex = value;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedHome12,
              color: Colors.black,
              size: 30.0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedUser,
              color: Colors.black,
              size: 30.0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedVideoReplay,
              color: Colors.black,
              size: 30.0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedLogout03,
              color: Colors.black,
              size: 30.0,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
