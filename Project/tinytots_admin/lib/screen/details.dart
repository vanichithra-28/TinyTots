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
      return Row(
        children: [
          Text(
            "Documents:",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight. bold),
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

  // Helper for detail rows
  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeceef0),
      appBar: AppBar(
        backgroundColor: const Color(0xff3e53a0),
        title: const Text('Details', style: TextStyle(color: Color(0xffffffff))),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  margin: const EdgeInsets.all(32),
                  child: Container(
                    width: 800,
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 36),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile photo
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundImage: NetworkImage(studentData['photo'] ?? ""),
                              backgroundColor: Colors.grey.shade200,
                            ),
                            const SizedBox(height: 18),
                            Text(
                              studentData['name'] ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff3e53a0),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 40),
                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Student Details",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff3e53a0),
                                ),
                              ),
                              const Divider(thickness: 1.2),
                              const SizedBox(height: 10),
                              _detailRow("Age", "${studentData['age'] ?? 'N/A'} months"),
                              _detailRow("Gender", studentData['gender'] ?? 'N/A'),
                              _detailRow("DOB", studentData['dob'] ?? 'N/A'),
                              _detailRow("Date of Joining", studentData['doj'] != null
                                  ? formatDate(studentData['doj'].toString())
                                  : 'N/A'),
                              const SizedBox(height: 18),
                              buildDocumentDisplay(),
                              const SizedBox(height: 28),
                              if (studentData['status'] == 0)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green.shade700,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                      ),
                                      onPressed: approve,
                                      icon: const Icon(Icons.check, color: Colors.white),
                                      label: const Text('Approve', style: TextStyle(color: Colors.white)),
                                    ),
                                    const SizedBox(width: 24),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red.shade700,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                      ),
                                      onPressed: reject,
                                      icon: const Icon(Icons.close, color: Colors.white),
                                      label: const Text('Reject', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}