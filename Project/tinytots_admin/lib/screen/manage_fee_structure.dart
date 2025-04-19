import 'package:flutter/material.dart';
import 'package:tinytots_admin/main.dart';

class Fee_structure extends StatefulWidget {
  const Fee_structure({super.key});

  @override
  State<Fee_structure> createState() => _Fee_structureState();
}

class _Fee_structureState extends State<Fee_structure>
    with SingleTickerProviderStateMixin {
  bool _isFormVisible = false;
  @override
  // ignore: override_on_non_overriding_member
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final TextEditingController amountController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  String _selectedFeeName = 'Full';
  List<Map<String, dynamic>> _feesList = [];
  int _editId = 0;
  Future<void> feeSubmit() async {
    if (_feesList.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Maximum of 3 fee entries allowed."),
        backgroundColor: Colors.red,
      ));
      return;
    }
    try {
      String amount = amountController.text;
      String details = detailsController.text;
      String feename = _selectedFeeName;
      await supabase.from('tbl_fees').insert(
          {'fee_amount': amount, 'fee_details': details, 'fee_name': feename});
      fetchFees();
      amountController.clear();
      detailsController.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Inserted"),
      ));
    } catch (e) {
      print("ERROR ADDING MEAL: $e");
    }
  }

  Future<void> fetchFees() async {
    try {
      final reponse = await supabase.from('tbl_fees').select();
      setState(() {
        _feesList = reponse;
      });
    } catch (e) {
      print("ERROR FETCHING FEES DATA:$e");
    }
  }

  void deleteFees(int feeId) async {
    try {
      await supabase.from('tbl_fees').delete().eq('id', feeId);
      fetchFees();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Fees type Deleted",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
    
    } catch (e) {
      print("ERROR DELETING FEES DATA:$e");
    }
  }

  Future<void> updateFees() async {
    try {
      await supabase.from('tbl_fees').update({
        'fee_amount': amountController.text,
        'fee_details': detailsController.text,
        'fee_name': _selectedFeeName,
      }).eq('id', _editId);
      fetchFees();
      amountController.clear;
      detailsController.clear;
      
      _editId = 0;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "File type Updated",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
      fetchFees();
    } catch (e) {
      print("ERROR UPDATING FILETYPE:$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFees();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
            Padding(
              padding: const EdgeInsets.only(left: 1100,top: 20),
              
              child: ElevatedButton.icon(
                 style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff3e53a0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4))),
                onPressed: () {
                  setState(() {
                    _isFormVisible = !_isFormVisible; // Toggle form visibility
                  });
                },
                label: Text(_isFormVisible ? "Cancel" : "Add ",style: TextStyle(color: Color(0xFFeceef0)),),
                icon: Icon(
                  _isFormVisible ? Icons.cancel : Icons.add,
                  color: Color(0xFFeceef0),
                ),
              ),
            ),
            SizedBox(
              height: 5.00,
            )
          ],
        ),
        AnimatedSize(
          duration: _animationDuration,
          curve: Curves.easeInOut,
          child: _isFormVisible
              ? Form(
                  child: Column(
                  children: [
                    Form(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
                                child: TextFormField(
                              controller: amountController,
                              decoration: InputDecoration(
                                labelText: 'Fee Amount',
                                border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.zero),
                              ),
                            )),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: TextFormField(
                              controller: detailsController,
                              decoration: InputDecoration(
                                labelText: 'Fee Details',
                                border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.zero),
                              ),
                            )),
                            SizedBox(
                              width: 10,
                            ),
                            Row(
                  children: [
                    const Text("Fee Name: "),
                    for (var fee in ['Full', 'Half', 'Daily'])
                      Row(
                        children: [
                          Radio(
                            value: fee,
                            groupValue: _selectedFeeName,
                            onChanged: (value) {
                              setState(() => _selectedFeeName = value.toString());
                            },
                          ),
                          Text(fee),
                        ],
                      ),
                  ],
                ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                               style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff3e53a0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4))),
                                onPressed: () {
                                  if (_editId != 0) {
                                    updateFees();
                                    _isFormVisible = false;
                                  } else {
                                    feeSubmit();
                                    _isFormVisible = false;
                                  }
                                },
                                child: Text('submit',style: TextStyle(color: Color(0xFFeceef0)),)),
                          ],
                        ),
                      ),
                    )),
                  ],
                ))
              : Container(),
        ),
        SizedBox(
          height: 20,
        ),
        Text("FEE DETAILS",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color(0xff252422))),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: EdgeInsets.all(16), // Padding inside the container
              margin: EdgeInsets.all(16), // Margin outside the container
              decoration: BoxDecoration(
                color: Color(0xffffffff), // Background color of the container
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
                              fontSize: 16, fontWeight: FontWeight.bold,color: Color(0xff252422)))),
                  DataColumn(
                      label: Text("Fees amount",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,color: Color(0xff252422)))),
                  DataColumn(
                      label: Text("Fees details",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,color: Color(0xff252422)))),
                  DataColumn(
                      label: Text("Fees name",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,color: Color(0xff252422)))),
                  DataColumn(
                      label: Text("Delete",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,color: Color(0xff252422)))),
                  DataColumn(
                      label: Text("Edit",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,color: Color(0xff252422)))),
                ],
                rows: _feesList.asMap().entries.map((entry) {
                  return DataRow(cells: [
                    DataCell(Text((entry.key + 1).toString(),style:TextStyle(
                              color: Color(0xff252422)) ,)),
                    DataCell(Text(entry.value['fee_amount'],style:TextStyle(
                              color: Color(0xff252422)) ,),),
                    DataCell(Text(entry.value['fee_details'],style:TextStyle(
                              color: Color(0xff252422)) ,)),
                    DataCell(Text(entry.value['fee_name'],style:TextStyle(
                              color: Color(0xff252422)) ,)),
                    DataCell(
                      IconButton(
                        onPressed: () {
                          deleteFees(entry.value['id']);
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                    DataCell(IconButton(
                        onPressed: () {
                          setState(() {
                            _editId = entry.value['id'];
                            amountController.text = entry.value['fee_amount'];
                            detailsController.text = entry.value['fee_details'];
                            _isFormVisible = true;
                          });
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.green,
                        ))),
                  ]);
                }).toList(),
              ),
            ))
      ],
    );
  }
}
