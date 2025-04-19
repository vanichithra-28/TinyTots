import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinytots_parent/main.dart';
import 'package:tinytots_parent/screen/payment.dart';

class Children extends StatefulWidget {
  const Children({super.key});

  @override
  State<Children> createState() => _ChildrenState();
}

class _ChildrenState extends State<Children> {
  final TextEditingController allergyController = TextEditingController();
  bool isLoading = true;
  Map<String, dynamic> childrenData = {};

  Future<void> display() async {
    try {
      setState(() {
        isLoading = true;
      });

          final prefs = await SharedPreferences.getInstance();
    int? childId = prefs.getInt('child');

      final childResponse = await supabase
          .from('tbl_child')
          .select()
          .eq('id', childId!).single();

      setState(() {
        childrenData = childResponse;
        // Set initial allergy value if it exists
        if (childrenData.isNotEmpty && childrenData['allergy'] != null) {
          allergyController.text = childrenData['allergy'];
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('ERROR DISPLAYING DATA: $e');
    }
  }

  Future<void> update() async {
    try {
      await supabase
          .from('tbl_child')
          .update({
            'allergy': allergyController.text.trim(),
          })
          .eq('id', childrenData['id']); // Added specific child ID to update
      
      // Refresh the display after update
      await display();
      // allergyController.clear();

      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Allergy updated successfully')),
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update allergy: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    display();
  }

  @override
  void dispose() {
    allergyController.dispose();
    super.dispose();
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
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: CircleAvatar(
                                      radius: 80,
                                      backgroundImage: NetworkImage(
                                          childrenData['photo'] ?? ''),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        childrenData['name'] ?? 'No Name',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Age: ${childrenData['age'] ?? 'N/A'} months',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Gender: ${childrenData['gender'] ?? 'N/A'}',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'DOB: ${childrenData['dob'] ?? 'N/A'}',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Allergies',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    controller: allergyController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      hintText: 'Enter allergies (if any)',
                                    ),
                                    maxLines: 2,
                                  ),
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.center,
                                    child: ElevatedButton(
                                      onPressed: update,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFbc6c25),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      child: const Text(
                                        'Update Allergy',
                                        style: TextStyle(color: Color(0xfff8f9fa)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Payment(childId: childrenData['id'],)),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFbc6c25),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4))),
                              child: const Text(
                                'Fee payment',
                                style: TextStyle(color: Color(0xfff8f9fa)),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
              ),
            ),
    );
  }
}