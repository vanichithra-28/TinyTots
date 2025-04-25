import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tinytots_parent/main.dart';
import 'package:tinytots_parent/screen/childreg.dart';
import 'package:tinytots_parent/screen/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  List<Map<String, dynamic>> accounts = [];
  bool isLoading = false;

  Future<void> display() async {
    setState(() {
      isLoading = true;
    });
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
    } finally {
      setState(() {
        isLoading = false;
      });
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
      appBar: AppBar(
        backgroundColor: const Color(0xfff8f9fa),
        elevation: 0,
        title: const Text(
          "My Children",
          style: TextStyle(
            color: Color(0xFFbc6c25),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xfff8f9fa),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFbc6c25),
              ),
            )
          : Center(
              child: accounts.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/empty.json', height: 120),
                        const SizedBox(height: 16),
                        const Text(
                          "No profiles found",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChildRegistration()));
                          },
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text("Add Profile"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFbc6c25),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 14),
                          ),
                        ),
                      ],
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 40,
                        childAspectRatio: 0.85,
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
                            child: Container(
                              decoration: BoxDecoration(
                                color:  Color(0xffffffff),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFFbc6c25),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.transparent,
                                    child: Icon(Icons.add,
                                        size: 40, color: Color(0xFFbc6c25)),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text('Add Profile',
                                      style: TextStyle(
                                          color: Color(0xFFbc6c25),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
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
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Lottie.asset('assets/wait.json', height: 80),
                                      const SizedBox(height: 10),
                                      const Text("Approval Pending",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFbc6c25))),
                                    ],
                                  ),
                                ),
                              );
                            } else if (account['status'] == 1) {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setInt('child', account['id']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Dashboard(childId: account['id']),
                                ),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.10),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: const Color(0xFFe0f7fa),
                                width: 1.2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: const Color(0xFFe0f7fa),
                                  backgroundImage: account['photo'] != null
                                      ? NetworkImage(account['photo'])
                                      : null,
                                  child: account['photo'] == null
                                      ? const Icon(Icons.person,
                                          size: 40, color: Color(0xFFbc6c25))
                                      : null,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  account['name'],
                                  style: const TextStyle(
                                      color: Color(0xFF22223b),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  account['status'] == 0 ? "Pending" : "Approved",
                                  style: TextStyle(
                                    color: account['status'] == 0
                                        ? Colors.orange
                                        : Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}