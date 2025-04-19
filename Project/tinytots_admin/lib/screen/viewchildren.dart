import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinytots_admin/main.dart';
import 'package:url_launcher/url_launcher.dart';

class Viewchildren extends StatefulWidget {
  final String parentId;
  const Viewchildren({super.key, required this.parentId});

  @override
  State<Viewchildren> createState() => _ViewchildrenState();
}

class _ViewchildrenState extends State<Viewchildren> {
  List<Map<String, dynamic>> _childList = [];
  bool _isLoading = true;
  String? _errorMessage;

  Future<void> display() async {
    try {
      final response = await supabase
          .from('tbl_child')
          .select()
          .eq('status', 1)
          .eq('parent_id', widget.parentId);

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
                                    color: Color(0xff252422)))),
                        DataColumn(
                            label: Text('DOB',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff252422)))),
                        DataColumn(
                            label: Text('Documents',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff252422)))),
                      ],
                      rows: _childList.asMap().entries.map((entry) {
                        final docUrl = entry.value['documents'];
                        final isImage = docUrl != null &&
                            (docUrl.endsWith('.jpg') ||
                                docUrl.endsWith('.jpeg') ||
                                docUrl.endsWith('.png'));

                        return DataRow(cells: [
                          DataCell(Text(entry.value['name'] ?? 'N/A',
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xff252422)))),
                          DataCell(Text(formatDate(entry.value['dob']),
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xff252422)))),
                          DataCell(docUrl == null || docUrl.isEmpty
                              ? Text('No documents',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff252422)))
                              : isImage
                                  ? Image.network(
                                      docUrl,
                                      height: 50,
                                      width: 50,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Icon(Icons.broken_image,
                                              color: Colors.red),
                                    )
                                  : IconButton(
                                      icon: Icon(Icons.insert_drive_file,
                                          color: Color.fromARGB(255, 228, 6, 6)),
                                      onPressed: () async {
                                        if (await canLaunchUrl(Uri.parse(docUrl))) {
                                          await launchUrl(Uri.parse(docUrl),
                                              mode: LaunchMode.externalApplication);
                                        }
                                      },
                                    )),
                        ]);
                      }).toList(),
                    ),
                  ),
      ),
    );
  }
}
