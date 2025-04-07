import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tinytots_parent/main.dart';
import 'package:tinytots_parent/sceen/childreg.dart';
import 'package:tinytots_parent/sceen/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  List<Map<String, dynamic>> accounts = [];

  Future<void> display() async {
    try {
      final response = await supabase
          .from('tbl_child')
          .select()
          .lte('status', 1)
          .eq('parent_id', supabase.auth.currentUser!.id);
      setState(() {
        accounts = response;
      });
    } catch (e) {
      print('Error: $e');
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
      appBar: AppBar(backgroundColor: const Color(0xfff8f9fa)),
      backgroundColor: const Color(0xfff8f9fa),
      body: Center(
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 50,
            childAspectRatio: 1,
          ),
          itemCount: accounts.length + 1,
          itemBuilder: (context, index) {
            if (index == accounts.length) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChildRegistration()));
                },
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.transparent,
                      child:
                          Icon(Icons.add, size: 50, color: Color(0xFFbc6c25)),
                    ),
                    const SizedBox(height: 10),
                    const Text('Add Profile',
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                  ],
                ),
              );
            }

            final account = accounts[index];
            return GestureDetector(
              onTap: () async {
                if (account['status'] == 0) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset('assets/wait.json', height: 100),
                          const SizedBox(height: 10),
                          const Text("Approval Pending",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                } else if (account['status'] == 1) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setInt('child', account['id']);
                  // Pass the child ID to the Dashboard
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Dashboard(childId: account['id']),
                    ),
                  );
                }
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey,
                    backgroundImage: account['photo'] != null
                        ? NetworkImage(account['photo'])
                        : null,
                    child: account['photo'] == null
                        ? const Icon(Icons.person,
                            size: 60, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Text(account['name'],
                      style:
                          const TextStyle(color: Colors.black, fontSize: 18)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}