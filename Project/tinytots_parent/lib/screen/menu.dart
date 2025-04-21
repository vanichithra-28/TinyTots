import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:tinytots_parent/screen/feedback.dart';
import 'package:tinytots_parent/screen/intro.dart';

class Menu extends StatefulWidget {
  const Menu({super.key, });

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  void _logout(BuildContext context) async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFbc6c25).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(18),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedLogout03,
                color: const Color(0xFFbc6c25),
                size: 40.0,
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => _logout(context),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFbc6c25),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Color(0xFFbc6c25)),
                ),
              ),
              child: const Text('Logout'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedbackPage()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFbc6c25),
                textStyle: const TextStyle(
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: const Text('Give Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}