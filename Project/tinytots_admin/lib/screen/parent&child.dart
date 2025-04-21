import 'package:flutter/material.dart';
import 'package:tinytots_admin/main.dart';
import 'package:tinytots_admin/screen/viewchildren.dart';
import 'package:url_launcher/url_launcher.dart';

class Parent_child extends StatefulWidget {
  const Parent_child({super.key});

  @override
  State<Parent_child> createState() => _Parent_childState();
}

class _Parent_childState extends State<Parent_child> {
  List<Map<String, dynamic>> _parentList = [];

  Future<void> display() async {
    try {
      final response = await supabase.from('tbl_parent').select();
      setState(() {
        _parentList = response;
      });
    } catch (e) {
      print('ERROR DISPLAYING PARENT DATA:$e');
    }
  }

  @override
  void initState() {
    super.initState();
    display();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(28),
        margin: EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Color(0xFFeceef0),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.10),
              spreadRadius: 2,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Parent List",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xff3e53a0),
              ),
            ),
            SizedBox(height: 18),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(Color(0xFFf5f6fa)),
                headingTextStyle: TextStyle(
                  color: Color(0xFFeceef0),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                columns: [
                  DataColumn(label: Text("Sl.No", style: TextStyle(color: Color(0xff252422)))),
                  DataColumn(label: Text("Name", style: TextStyle(color: Color(0xff252422)))),
                  DataColumn(label: Text("Email", style: TextStyle(color: Color(0xff252422)))),
                  DataColumn(label: Text("Contact", style: TextStyle(color: Color(0xff252422)))),
                  DataColumn(label: Text("Proof", style: TextStyle(color: Color(0xff252422)))),
                  DataColumn(label: Text("Action", style: TextStyle(color: Color(0xff252422)))),
                ],
                rows: _parentList.asMap().entries.map((entry) {
                  final proofUrl = entry.value['parent_proof'];
                  final isImage = proofUrl.endsWith('.jpg') ||
                      proofUrl.endsWith('.jpeg') ||
                      proofUrl.endsWith('.png');

                  return DataRow(
                    cells: [
                      DataCell(Text(
                        (entry.key + 1).toString(),
                        style: TextStyle(color: Color(0xff252422)),
                      )),
                      DataCell(Text(entry.value['parent_name'],
                          style: TextStyle(
                              color: Color(0xff252422),
                              fontWeight: FontWeight.w600))),
                      DataCell(Text(entry.value['parent_email'],
                          style: TextStyle(color: Color(0xff252422)))),
                      DataCell(Text(entry.value['parent_contact'],
                          style: TextStyle(color: Color(0xff252422)))),
                      DataCell(
                        isImage
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  proofUrl,
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.broken_image, color: Colors.grey),
                                ),
                              )
                            : IconButton(
                                icon: Icon(Icons.picture_as_pdf, color: Colors.red),
                                onPressed: () async {
                                  if (await canLaunchUrl(Uri.parse(proofUrl))) {
                                    await launchUrl(Uri.parse(proofUrl),
                                        mode: LaunchMode.externalApplication);
                                  }
                                },
                              ),
                      ),
                      DataCell(
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff3e53a0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Viewchildren(
                                          parentId: entry.value['id'],
                                        )));
                          },
                          icon: Icon(Icons.visibility, color: Color(0xFFeceef0), size: 18),
                          label: Text("View Details",
                              style: TextStyle(color: Color(0xFFeceef0))),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
