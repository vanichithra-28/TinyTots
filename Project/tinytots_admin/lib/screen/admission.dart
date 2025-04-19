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
  @override
  List<Map<String, dynamic>> _admissionList = [];
  void display() async {
    try {
      setState(() {
        isLoading = true;
      });
      final reponse = await supabase.from('tbl_child').select();
      setState(() {
        _admissionList = reponse;
      });
    } catch (e) {
      print('ERROR');
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
            padding: EdgeInsets.all(16), // Padding inside the container
            margin: EdgeInsets.all(16), // Margin outside the container
            decoration: BoxDecoration(
              color: Color(0xffffffff), // Background color of the container
              // Rounded corners
              border: Border.all(
                color: Color(0xFFeceef0), // Border color
                width: 2, // Border width
              ),
            ),
            child: DataTable(
              columns: [
                DataColumn(
                    label: Text("Sl.No",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff252422)))),
                DataColumn(
                    label: Text("Name",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff252422)))),
                DataColumn(
                    label: Text("Application Date",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff252422)))),
                DataColumn(
                    label: Text("Admission Status",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff252422)))),
                DataColumn(
                    label: Text("View Details",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff252422)))),
              ],
              rows: _admissionList.asMap().entries.map((entry) {
                return DataRow(cells: [
                  DataCell(Text(
                    (entry.key + 1).toString(),
                    style: TextStyle(color: Color(0xff252422)),
                  )),
                  DataCell(
                    Text(
                      entry.value['name'],
                      style: TextStyle(color: Color(0xff252422)),
                    ),
                  ),
                  DataCell(Text(
                    formatDate(
                      entry.value['created_at'],
                    ),
                    style: TextStyle(color: Color(0xff252422)),
                  )),
                  DataCell(
                    entry.value['status'] == 1
                        ? Text(
                            'Approved',
                            style: TextStyle(color: Colors.green),
                          )
                        : entry.value['status'] == 2
                            ? Text(
                                'Rejected',
                                style: TextStyle(color: Colors.red),
                              )
                            : Text(
                                'Pending',
                                style: TextStyle(color: Colors.orange),
                              ),
                  ),
                  DataCell(ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff3e53a0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4))),
                    onPressed: () {
                      final studentId =
                          entry.value['id']; // Get the ID from the entry
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Details(studentId: studentId),
                        ),
                      );
                    },
                    child: Text(
                      'View',
                      style: TextStyle(color: Color(0xFFeceef0)),
                    ),
                  )),
                ]);
              }).toList(),
            )));
  }
}
