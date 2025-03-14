import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinytots_admin/main.dart';

class Viewchildren extends StatefulWidget {
  final String parentId;
  const Viewchildren({super.key, required this.parentId});

  @override
  State<Viewchildren> createState() => _ViewchildrenState();
}

class _ViewchildrenState extends State<Viewchildren> {
    List<Map<String, dynamic>> _childList = [];
    Future<void> display() async {
      try {
        final response = await supabase.from('tbl_child').select().eq('parent_id', widget.parentId);
        setState(() {
          _childList = response;
        });
        
      } catch (e) {
        print('ERROR DISPLAYING CHILD DATA:$e');
        
      }
    }
    String formatDate(String timestamp) {
  DateTime date = DateTime.parse(timestamp);
  return DateFormat('dd-MM-yyyy').format(date); // Formats to YYYY-MM-DD
}
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    display();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
       backgroundColor:Color(0xff3e53a0),
        title: Text('',style: TextStyle(color: Color(0xffffffff)),),
      ),
      backgroundColor: Color(0xFFeceef0),
      body: Center(
        child: Container(
          height: 500,
          width: 1000,
          color: Color(0xffffffff),
          child: DataTable(columns: [
            DataColumn(label: Text('Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff8b8c89)))),
            DataColumn(label: Text('DOJ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff8b8c89)))),
            DataColumn(label: Text('Documents', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff8b8c89)))),

          ], rows:_childList.asMap().entries.map((entry) {
            return DataRow(cells: [
              DataCell(Text(entry.value['name'], style: TextStyle(fontSize: 16, color: Color(0xff8b8c89)))),
              DataCell(Text(formatDate(entry.value['doj']), style: TextStyle(fontSize: 16, color: Color(0xff8b8c89)))),
              DataCell(Text(entry.value['documents'], style: TextStyle(fontSize: 16, color: Color(0xff8b8c89)))),

            ]);
          }).toList(),
          ),
        ),
      ),
    
    );

  }
}