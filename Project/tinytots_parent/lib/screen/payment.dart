import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tinytots_parent/screen/paymentwindow.dart';

class Payment extends StatefulWidget {
   final int childId;
  const Payment({super.key, required this.childId});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _accounts = [];

  @override
  void initState() {
    super.initState();
    display();
  }

  Future<void> display() async {
    try {
      final response = await supabase.from('tbl_payment').select().eq('child_id', widget.childId);
      setState(() {
        _accounts = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: Color(0xFFffffff),
      ),
      backgroundColor: Color(0xFFf8f9fa),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 680,
          width: 365,
          decoration: BoxDecoration(
            color: const Color(0xFFffffff),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  columns: [
                    DataColumn(
                      label: Text(
                        "Amount Due",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff8b8c89),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Due Date",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff8b8c89),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Status",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff8b8c89),
                        ),
                      ),
                    ),
                  ],
                  rows: _accounts.map((entry) {
                    return DataRow(
                      cells: [
                        DataCell(Text(entry['amount_due'].toString())),
                        DataCell(Text(entry['due_date'].toString())),
                        DataCell(
                          Text(
                            entry['status'] == 1 ? "Paid" : "Pending",
                            style: TextStyle(
                              color: entry['status'] == 1
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Paymentwindow(childId: widget.childId,)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFbc6c25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text(
                  'Proceed Payment',
                  style: TextStyle(color: Color(0xfff8f9fa)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
