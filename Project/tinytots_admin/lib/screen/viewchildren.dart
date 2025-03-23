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
  bool _isLoading = true; // Show loading indicator
  String? _errorMessage; // Handle errors

  Future<void> display() async {
    try {
      final response = await supabase
          .from('tbl_child')
          .select().eq('status', 1)
          .eq('parent_id', widget.parentId,);

      setState(() {
        _childList = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load child data';
        _isLoading = false;
      });
      print('ERROR DISPLAYING CHILD DATA: $e');
    }
  }

  String formatDate(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) return 'N/A';
    try {
      DateTime date = DateTime.parse(timestamp);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return 'Invalid Date';
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
      appBar: AppBar(
        backgroundColor: Color(0xff3e53a0),
        title: Text('View Children', style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Color(0xFFeceef0),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _errorMessage != null
                ? Text(_errorMessage!, style: TextStyle(color: Colors.red))
                : Container(
                    height: 500,
                    width: 1000,
                    color: Color(0xffffffff),
                    child: DataTable(
                      columns: [
                        DataColumn(
                            label: Text('Name',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff8b8c89)))),
                        DataColumn(
                            label: Text('DOB',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff8b8c89)))),
                        DataColumn(
                            label: Text('Documents',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff8b8c89)))),
                      ],
                      rows: _childList.asMap().entries.map((entry) {
                        return DataRow(cells: [
                          DataCell(Text(entry.value['name'] ?? 'N/A',
                              style:
                                  TextStyle(fontSize: 16, color: Color(0xff8b8c89)))),
                          DataCell(Text(formatDate(entry.value['dob']),
                              style:
                                  TextStyle(fontSize: 16, color: Color(0xff8b8c89)))),
                          DataCell(Text(entry.value['documents'] ?? 'No documents',
                              style:
                                  TextStyle(fontSize: 16, color: Color(0xff8b8c89)))),
                        ]);
                      }).toList(),
                    ),
                  ),
      ),
    );
  }
}
