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
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          border: Border.all(
            color: Color(0xFFeceef0),
            width: 2,
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
                label: Text("Email",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff252422)))),
            DataColumn(
                label: Text("Contact",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff252422)))),
            DataColumn(
                label: Text("Proof",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff252422)))),
            DataColumn(
                label: Text("Action",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff252422)))),
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
                    style: TextStyle(color: Color(0xff252422)))),
                DataCell(Text(entry.value['parent_email'],
                    style: TextStyle(color: Color(0xff252422)))),
                DataCell(Text(entry.value['parent_contact'],
                    style: TextStyle(color: Color(0xff252422)))),
                DataCell(
                  isImage
                      ? Image.network(
                          proofUrl,
                          height: 50,
                          width: 50,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.broken_image, color: Colors.grey),
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
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff3e53a0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Viewchildren(
                                      parentId: entry.value['id'],
                                    )));
                      },
                      child: Text("View Details",
                          style: TextStyle(color: Color(0xFFeceef0)))),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
