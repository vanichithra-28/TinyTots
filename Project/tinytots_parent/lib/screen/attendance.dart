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
          .eq('child_id', childId).order('date', ascending: false);

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
        title: const Text(
          'Attendance',
          style: TextStyle(
            color: Color(0xFFbc6c25),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFFbc6c25)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFFbc6c25)),
            onPressed: fetchAttendance,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Color(0xFFbc6c25)),
            onPressed: exportToPdf,
            tooltip: 'Export to PDF',
          ),
        ],
      ),
      backgroundColor: const Color(0xFFf8f9fa),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFbc6c25).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Your child\'s daily attendance records are shown below.',
                style: TextStyle(
                  color: Color(0xFFbc6c25),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: attendanceRecords.isEmpty
                  ? const Center(
                      child: Text(
                        'No attendance records found',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: attendanceRecords.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final record = attendanceRecords[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.07),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFFbc6c25).withOpacity(0.15),
                              child: const Icon(Icons.event_available, color: Color(0xFFbc6c25)),
                            ),
                            title: Text(
                              record['date'] ?? 'Unknown Date',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFbc6c25),
                                fontSize: 17,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.login, size: 16, color: Colors.green),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Check in: ${record['check_in'] != null ? DateFormat('hh:mm a').format(DateTime.parse(record['check_in'])) : 'N/A'}',
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(Icons.logout, size: 16, color: Colors.red),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Check out: ${record['check_out'] != null ? DateFormat('hh:mm a').format(DateTime.parse(record['check_out'])) : 'N/A'}',
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
