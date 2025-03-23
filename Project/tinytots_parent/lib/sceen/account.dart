import 'package:flutter/material.dart';
import 'package:tinytots_parent/main.dart';
import 'package:tinytots_parent/sceen/childreg.dart';
import 'package:tinytots_parent/sceen/dashboard.dart';

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
          .select().lte('status', 1);
      
      setState(() {
        accounts = response;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    display();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff8f9fa
        ),
      ),
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
          itemCount: accounts.length + 1, // Extra item for "Add Profile"
          itemBuilder: (context, index) {
            if (index == accounts.length) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChildRegistration()));

                  print('Add Profile tapped');
                },
                
                child: Column(
                  children: [
                    
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.add, size: 50, color: Color(0xFFbc6c25)),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Add Profile',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
              );
            }
            final account = accounts[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Dashboard()));
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                         NetworkImage(account['photo'])
                        ,
                    child: account['photo'] == null
                        ? Icon(Icons.person, size: 60, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    account['name'],
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
