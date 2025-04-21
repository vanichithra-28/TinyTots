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
        title: const Text(
          'Payment',
          style: TextStyle(
            color: Color(0xFFbc6c25),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFFbc6c25)),
      ),
      backgroundColor: const Color(0xFFf8f9fa),
      body: Center(
        child: Container(
          height: 500,
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: const Color(0xFFffffff),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.13),
                spreadRadius: 5,
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                "Fee Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFbc6c25),
                ),
              ),
              const SizedBox(height: 18),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 24,
                  headingRowColor: MaterialStateProperty.all(const Color(0xFFf6f6f6)),
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
                  rows: _accounts.isEmpty
                      ? [
                          DataRow(
                            cells: [
                              DataCell(Text('-')),
                              DataCell(Text('-')),
                              DataCell(Text('-')),
                            ],
                          ),
                        ]
                      : _accounts.map((entry) {
                          return DataRow(
                            cells: [
                              DataCell(Text(
                                '₹${entry['amount_due']}',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataCell(Text(
                                entry['due_date'].toString(),
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              )),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: entry['status'] == 1
                                        ? Colors.green.withOpacity(0.12)
                                        : Colors.red.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    entry['status'] == 1 ? "Paid" : "Pending",
                                    style: TextStyle(
                                      color: entry['status'] == 1
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Paymentwindow(childId: widget.childId),
                      ),
                    );
                  },
                  icon: const Icon(Icons.payment, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFbc6c25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 2,
                  ),
                  label: const Text(
                    'Proceed to Payment',
                    style: TextStyle(
                      color: Color(0xfff8f9fa),
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
