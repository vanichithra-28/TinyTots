import 'package:flutter/material.dart';
import 'package:tinytots_parent/main.dart';
import 'package:tinytots_parent/sceen/payment.dart';

class Children extends StatefulWidget {
  const Children({super.key});

  @override
  State<Children> createState() => _ChildrenState();
}

class _ChildrenState extends State<Children> {
  bool isLoading = true;
  Map<String, dynamic> parentData = {};
  List<Map<String, dynamic>> childrenData = [];

  Future<void> display() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Fetch parent data
      final parentResponse = await supabase
          .from('tbl_parent')
          .select()
          .eq('id', supabase.auth.currentUser!.id)
          .single();

      // Fetch children data using parent's ID
      final childResponse = await supabase
          .from('tbl_child')
          .select()
          .eq('parent_id', parentResponse['id']);

      setState(() {
        parentData = parentResponse;
        childrenData = List<Map<String, dynamic>>.from(childResponse);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('ERROR DISPLAYING DATA: $e');
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
        title: const Text('Child Profile'),
        backgroundColor: const Color(0xFFffffff),
      ),
      backgroundColor: const Color(0xFFf8f9fa),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 680,
                width: 365,
                decoration: BoxDecoration(
                  color: const Color(0xFFffffff),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: childrenData.isEmpty
                    ? const Center(child: Text('No child data found'))
                    : Column(
                        children: [
                          const SizedBox(height: 20),
                          // Uncomment and adjust if you have a child photo URL
                          // CircleAvatar(
                          //   radius: 80,
                          //   backgroundImage: NetworkImage(childrenData[0]['photo_url'] ?? ''),
                          // ),
                          const SizedBox(height: 20),
                          Text(
                            childrenData[0]['name'] ?? 'No Name',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Age: ${childrenData[0]['age'] ?? 'N/A'}',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Gender: ${childrenData[0]['gender'] ?? 'N/A'}',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'DOB: ${childrenData[0]['dob'] ?? 'N/A'}',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Payment()),
                              );
                            },
                             style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFbc6c25),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4))),
                            child: const Text('Fee payment',style: TextStyle(color: Color(0xfff8f9fa)),),
                            
                          ),
                        ],
                      ),
              ),
            ),
    );
  }
}