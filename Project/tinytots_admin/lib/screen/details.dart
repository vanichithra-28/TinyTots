import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinytots_admin/main.dart';
import 'package:url_launcher/url_launcher.dart'; // Added for opening files

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

  // New method to build the document display widget
  Widget buildDocumentDisplay() {
    final String? documentUrl = studentData['documents'];

    if (documentUrl == null || documentUrl == 'N/A') {
      return Text(
        "Documents: N/A",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      );
    }

    final String extension = documentUrl.split('.').last.toLowerCase();
    final bool isImage = ['jpg', 'jpeg', 'png', 'gif'].contains(extension);
    final bool isPdf = extension == 'pdf';

    if (isImage) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Documents:",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 5),
          Image.network(
            documentUrl,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Text(
                "Error loading image",
                style: TextStyle(fontSize: 15, color: Colors.red),
              );
            },
          ),
        ],
      );
    } else if (isPdf) {
      return Padding(
        padding: const EdgeInsets.only(left: 200.0),
        child: Row(
          children: [
            Text(
              "Documents:",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 5),
            GestureDetector(
              onTap: () async {
                final Uri uri = Uri.parse(documentUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Cannot open document")),
                  );
                }
              },
              child: Row(
                children: [
                  Icon(Icons.picture_as_pdf, color: Colors.red, size: 20),
                  SizedBox(width: 5),
                  Text(
                    "View PDF",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 200.0),
        child: Row(
          children: [
            Text(
              "Documents:",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 5),
            GestureDetector(
              onTap: () async {
                final Uri uri = Uri.parse(documentUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Cannot open document")),
                  );
                }
              },
              child: Text(
                "Open File",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      );
    }
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
              color: Color(0xffffffff),
              border: Border.all(
                color: Color(0xFFeceef0),
                width: 2,
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
                        backgroundColor: Colors.grey,
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
                      buildDocumentDisplay(), // Replaced the original Text widget
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