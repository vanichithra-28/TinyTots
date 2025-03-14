import 'package:flutter/material.dart';
import 'package:tinytots_admin/main.dart';
import 'package:tinytots_admin/screen/viewchildren.dart';

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
    // TODO: implement initState
    super.initState();
    display();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
                        color: Color(0xff8b8c89)))),
            DataColumn(
                label: Text("Name",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff8b8c89)))),
            DataColumn(
                label: Text("Email",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff8b8c89)))),
            DataColumn(
                label: Text("Contact",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff8b8c89)))),
            DataColumn(
                label: Text("Proof",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff8b8c89)))),
            DataColumn(
                label: Text("Action",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff8b8c89)))),
          ],
          rows: _parentList.asMap().entries.map((entry) {
            return DataRow(
              cells: [
                DataCell(Text(
                  (entry.key + 1).toString(),
                  style: TextStyle(color: Color(0xff8b8c89)),
                )),
                DataCell(Text(entry.value['parent_name'],
                    style: TextStyle(color: Color(0xff8b8c89)))),
                DataCell(Text(entry.value['parent_email'],
                    style: TextStyle(color: Color(0xff8b8c89)))),
                DataCell(Text(entry.value['parent_contact'],
                    style: TextStyle(color: Color(0xff8b8c89)))),
                DataCell(Text(entry.value['parent_proof'],
                    style: TextStyle(color: Color(0xff8b8c89)))),
                DataCell(
                  ElevatedButton(
                     style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff3e53a0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4))),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>Viewchildren(parentId: entry.value['id'],)));
                    
                  }, child: Text("View Details",style: TextStyle(color: Color(0xFFeceef0)))
                )  ),  
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
