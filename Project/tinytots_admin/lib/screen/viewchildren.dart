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
                : _childList.isEmpty
                    ? Text(
                        "No children found.",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      )
                    : Container(
                        padding: EdgeInsets.all(24),
                        margin: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Children List",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff3e53a0),
                              ),
                            ),
                            SizedBox(height: 18),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
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
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: Image.network(
                                                  docUrl,
                                                  height: 50,
                                                  width: 50,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) =>
                                                      Icon(Icons.broken_image,
                                                          color: Colors.red),
                                                ),
                                              )
                                            : ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red.shade100,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                                ),
                                                onPressed: () async {
                                                  if (await canLaunchUrl(Uri.parse(docUrl))) {
                                                    await launchUrl(Uri.parse(docUrl),
                                                        mode: LaunchMode.externalApplication);
                                                  }
                                                },
                                                icon: Icon(Icons.insert_drive_file, color: Colors.red),
                                                label: Text(
                                                  "Open File",
                                                  style: TextStyle(
                                                      color: Colors.red.shade800,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              )),
                                  ]);
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }
}
