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
  final _formKey = GlobalKey<FormState>();
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
          .eq('id', childrenData['id']);

      await display();

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
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFFbc6c25)),
        titleTextStyle: const TextStyle(
          color: Color(0xFFbc6c25),
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      backgroundColor: const Color(0xFFf8f9fa),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                decoration: BoxDecoration(
                  color: const Color(0xFFffffff),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.13),
                      spreadRadius: 5,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: childrenData.isEmpty
                    ? const Center(child: Text('No child data found'))
                    : SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 24),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 16),
                                  CircleAvatar(
                                    radius: 55,
                                    backgroundColor:
                                        const Color(0xFFbc6c25).withOpacity(0.08),
                                    backgroundImage: (childrenData['photo'] != null &&
                                            childrenData['photo'] != '')
                                        ? NetworkImage(childrenData['photo'])
                                        : null,
                                    child: (childrenData['photo'] == null ||
                                            childrenData['photo'] == '')
                                        ? const Icon(Icons.child_care,
                                            size: 60, color: Color(0xFFbc6c25))
                                        : null,
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          childrenData['name'] ?? 'No Name',
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFbc6c25),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Age: ${childrenData['age'] ?? 'N/A'} months',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF495057),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Gender: ${childrenData['gender'] ?? 'N/A'}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF495057),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'DOB: ${childrenData['dob'] ?? 'N/A'}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF495057),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Divider(
                                color: Colors.grey.withOpacity(0.3),
                                thickness: 1,
                                indent: 16,
                                endIndent: 16,
                              ),
                              const SizedBox(height: 18),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Allergies',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFbc6c25),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: allergyController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        hintText: 'Enter allergies (if any)',
                                        fillColor: Color(0xFFf6f6f6),
                                        filled: true,
                                      ),
                                      maxLines: 2,
                                      maxLength: 100,
                                      validator: (value) {
                                        if (value != null &&
                                            value.trim().isNotEmpty &&
                                            value.trim().length < 3) {
                                          return 'Please enter at least 3 characters or leave blank if none';
                                        }
                                        if (value != null &&
                                            value.length > 100) {
                                          return 'Allergy info must be under 100 characters';
                                        }
                                        if (value != null &&
                                            value.trim().isNotEmpty &&
                                            !RegExp(r'^[a-zA-Z,\s]+$')
                                                .hasMatch(value.trim())) {
                                          return 'Only letters, commas, and spaces allowed';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.center,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            update();
                                          }
                                        },
                                        icon: const Icon(Icons.save,
                                            color: Colors.white),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFbc6c25),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 32, vertical: 12),
                                        ),
                                        label: const Text(
                                          'Update Allergy',
                                          style: TextStyle(
                                            color: Color(0xfff8f9fa),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
                              Divider(
                                color: Colors.grey.withOpacity(0.3),
                                thickness: 1,
                                indent: 16,
                                endIndent: 16,
                              ),
                              const SizedBox(height: 18),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Payment(
                                            childId: childrenData['id'],
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.payment,
                                        color: Colors.white),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFbc6c25),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                    ),
                                    label: const Text(
                                      'Fee Payment',
                                      style: TextStyle(
                                        color: Color(0xfff8f9fa),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
    );
  }
}