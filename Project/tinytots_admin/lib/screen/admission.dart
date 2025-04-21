import 'package:flutter/material.dart';
import 'package:tinytots_admin/main.dart';
import 'package:tinytots_admin/screen/details.dart';
import 'package:intl/intl.dart';

class Admission extends StatefulWidget {
  const Admission({super.key});

  @override
  State<Admission> createState() => _AdmissionState();
}

class _AdmissionState extends State<Admission> {
  bool isLoading = true;
  List<Map<String, dynamic>> _admissionList = [];
  void display() async {
    try {
      setState(() {
        isLoading = true;
      });
      final reponse = await supabase.from('tbl_child').select();
      setState(() {
        _admissionList = reponse;
        isLoading = false;
      });
    } catch (e) {
      print('ERROR');
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDate(String timestamp) {
    DateTime date = DateTime.parse(timestamp);
    return DateFormat('dd-MM-yyyy').format(date); // Formats to YYYY-MM-DD
  }

  @override
  void initState() {
    display();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          border: Border.all(
            color: Color(0xFFeceef0),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : _admissionList.isEmpty
                ? Center(
                    child: Text(
                      "No admissions found.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 32,
                      headingRowColor: MaterialStateProperty.all(Color(0xFFf5f6fa)),
                      columns: [
                        DataColumn(
                          label: Text("Sl.No",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff252422))),
                        ),
                        DataColumn(
                          label: Text("Name",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff252422))),
                        ),
                        DataColumn(
                          label: Text("Application Date",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff252422))),
                        ),
                        DataColumn(
                          label: Text("Admission Status",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff252422))),
                        ),
                        DataColumn(
                          label: Text("View Details",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff252422))),
                        ),
                      ],
                      rows: _admissionList.asMap().entries.map((entry) {
                        Widget statusChip;
                        if (entry.value['status'] == 1) {
                          statusChip = Chip(
                            label: Text('Approved'),
                            backgroundColor: Colors.green.shade100,
                            labelStyle: TextStyle(color: Colors.green.shade800),
                          );
                        } else if (entry.value['status'] == 2) {
                          statusChip = Chip(
                            label: Text('Rejected'),
                            backgroundColor: Colors.red.shade100,
                            labelStyle: TextStyle(color: Colors.red.shade800),
                          );
                        } else {
                          statusChip = Chip(
                            label: Text('Pending'),
                            backgroundColor: Colors.orange.shade100,
                            labelStyle: TextStyle(color: Colors.orange.shade800),
                          );
                        }
                        return DataRow(
                          cells: [
                            DataCell(Text(
                              (entry.key + 1).toString(),
                              style: TextStyle(color: Color(0xff252422), fontSize: 15),
                            )),
                            DataCell(Text(
                              entry.value['name'],
                              style: TextStyle(color: Color(0xff252422), fontSize: 15),
                            )),
                            DataCell(Text(
                              formatDate(entry.value['created_at']),
                              style: TextStyle(color: Color(0xff252422), fontSize: 15),
                            )),
                            DataCell(statusChip),
                            DataCell(
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff3e53a0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                onPressed: () {
                                  final studentId = entry.value['id'];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Details(studentId: studentId),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.visibility, color: Color(0xFFeceef0), size: 18),
                                label: Text(
                                  'View',
                                  style: TextStyle(color: Color(0xFFeceef0)),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
      ),
    );
  }
}
