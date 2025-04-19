import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> attendanceRecords = [];

  @override
  void initState() {
    super.initState();
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    int? childId = prefs.getInt('child');
    final user = supabase.auth.currentUser;
    if (user != null && childId != null) {
      final response = await supabase
          .from('tbl_attendance')
          .select()
          .eq('child_id', childId);

      setState(() {
        attendanceRecords = List<Map<String, dynamic>>.from(response);
      });
    }
  }

  Future<void> exportToPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Attendance Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Table.fromTextArray(
                headers: ['Date', 'Check In', 'Check Out'],
                data: attendanceRecords.map((record) => [
                  record['date'] ?? 'Unknown Date',
                  record['check_in'] != null
                      ? DateFormat('hh:mm a').format(DateTime.parse(record['check_in']))
                      : 'N/A',
                  record['check_out'] != null
                      ? DateFormat('hh:mm a').format(DateTime.parse(record['check_out']))
                      : 'N/A',
                ]).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
        backgroundColor: Color(0xFFffffff),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf, color: Colors.black),
            onPressed: exportToPdf,
            tooltip: 'Export to PDF',
          ),
        ],
      ),
      backgroundColor: Color(0xFFf8f9fa),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: attendanceRecords.isEmpty
                  ? Center(child: Text('No attendance records found'))
                  : ListView.builder(
                      itemCount: attendanceRecords.length,
                      itemBuilder: (context, index) {
                        final record = attendanceRecords[index];
                        return Card(
                          child: ListTile(
                            title: Text(record['date'] ?? 'Unknown Date'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Check in: ${record['check_in'] != null ? DateFormat('hh:mm a').format(DateTime.parse(record['check_in'])) : 'N/A'}',
                                ),
                                Text(
                                  'Check out: ${record['check_out'] != null ? DateFormat('hh:mm a').format(DateTime.parse(record['check_out'])) : 'N/A'}',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
