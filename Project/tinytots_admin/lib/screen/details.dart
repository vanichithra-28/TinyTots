import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinytots_admin/main.dart';

class Details extends StatefulWidget {
  final int studentId;
  const Details({super.key, required this.studentId});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  bool isLoading = true;
  Map<String, dynamic> studentData = {};
  String formatDate(String? timestamp) {
  if (timestamp == null || timestamp.isEmpty) return 'N/A'; // Handle null or empty timestamps
  try {
    DateTime date = DateTime.parse(timestamp);
    return DateFormat('dd-MM-yyyy').format(date); // Formats to DD-MM-YYYY
  } catch (e) {
    return 'Invalid Date'; // Handle invalid date formats
  }
}

  Future<void> display() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await supabase
          .from('tbl_child')
          .select()
          .eq('id', widget.studentId)
          .single();
      setState(() {
        studentData = response;
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
      print('ERROR DISPLAYING STUDENT DATA:$e');
    }
  }

  Future<void> approve() async {
    try {
      setState(() {
        isLoading = true;
      });

      String currentDate =
          DateTime.now().toIso8601String(); // Get the current date

      await supabase.from('tbl_child').update({
        'status': 1,
        'doj': currentDate,
      }).eq('id', widget.studentId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Approved')),
      );

      display();
    } catch (e) {
      print('ERROR APPROVING STUDENT DATA: $e');
    }
  }

  Future<void> reject() async {
    try {
      setState(() {
        isLoading = true;
      });
     
      await supabase.from('tbl_child').update({
        'status': 2,
      }).eq('id', widget.studentId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rejected')),
      );
      display();
    } catch (e) {
      print('ERROR REJECTING STUDENT DATA:$e');
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
      backgroundColor: Color(0xFFeceef0),
      appBar: AppBar(
        backgroundColor: Color(0xff3e53a0),
        title: Text(
          'Details',
          style: TextStyle(color: Color(0xffffffff)),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 800,
            height: 600,
            decoration: BoxDecoration(
              color: Color(0xffffffff), // Background color of the container
              // Rounded corners
              border: Border.all(
                color: Color(0xFFeceef0), // Border color
                width: 2, // Border width
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 130),
                      CircleAvatar(
                        radius: 120,
                        backgroundImage:
                            NetworkImage(studentData['photo'] ?? "NA"),
                        backgroundColor: Colors.grey, // Placeholder background
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      SizedBox(height: 150),
                      Text(
                        "Name: ${studentData['name'] ?? 'N/A'}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Age: ${studentData['age'] ?? 'N/A'} months",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Gender: ${studentData['gender'] ?? 'N/A'}",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "DOB: ${studentData['dob'] ?? 'N/A'}",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Documents: ${studentData['documents'] ?? 'N/A'}",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10),
                      Text(
                        studentData['doj'] != null
                            ? formatDate(studentData['doj'].toString())
                            : 'No doj',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      if (studentData['status'] == 0)
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              SizedBox(width: 125),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xff3e53a0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4))),
                                    onPressed: () {
                                      approve();
                                    },
                                    child: Text(
                                      'Approve',
                                      style:
                                          TextStyle(color: Color(0xFFeceef0)),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xff3e53a0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4))),
                                    onPressed: () {
                                      reject();
                                    },
                                    child: Text(
                                      'Reject ',
                                      style:
                                          TextStyle(color: Color(0xFFeceef0)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
