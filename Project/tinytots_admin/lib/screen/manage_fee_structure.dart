import 'package:flutter/material.dart';
import 'package:tinytots_admin/main.dart';

class FeeStructure extends StatefulWidget {
  const FeeStructure({super.key});

  @override
  State<FeeStructure> createState() => _FeeStructureState();
}

class _FeeStructureState extends State<FeeStructure>
    with SingleTickerProviderStateMixin {
  bool _isFormVisible = false;
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Inserted"),
      ));
    } catch (e) {
      print("ERROR ADDING MEAL: $e");
    }
  }

  Future<void> fetchFees() async {
    try {
      final response = await supabase.from('tbl_fees').select();
      setState(() {
        _feesList = response;
      });
    } catch (e) {
      print("ERROR FETCHING FEES DATA:$e");
    }
  }

  void deleteFees(int feeId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Fee"),
        content: const Text("Are you sure you want to delete this fee entry?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    if (confirm != true) return;

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
      amountController.clear();
      detailsController.clear();
      _editId = 0;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Fee type Updated",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      print("ERROR UPDATING FILETYPE:$e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFees();
  }

  Widget _buildForm() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: amountController,
                    decoration: const InputDecoration(
                      labelText: 'Fee Amount',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: detailsController,
                    decoration: const InputDecoration(
                      labelText: 'Fee Details',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text("Fee Name: "),
                ...['Full', 'Half', 'Daily'].map((fee) => Row(
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
                )),
                const Spacer(),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3e53a0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {
                    if (_editId != 0) {
                      updateFees();
                    } else {
                      feeSubmit();
                    }
                    setState(() {
                      _isFormVisible = false;
                      _editId = 0;
                    });
                  },
                  icon: const Icon(Icons.save, color: Color(0xFFeceef0)),
                  label: Text(
                    _editId != 0 ? 'Update' : 'Submit',
                    style: const TextStyle(color: Color(0xFFeceef0)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeList() {
    if (_feesList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: Text("No fee entries found.")),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _feesList.length,
      itemBuilder: (context, index) {
        final fee = _feesList[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xff3e53a0),
              child: Text(
                "${index + 1}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              "₹${fee['fee_amount']} - ${fee['fee_name']}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(fee['fee_details']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.green),
                  onPressed: () {
                    setState(() {
                      _editId = fee['id'];
                      amountController.text = fee['fee_amount'];
                      detailsController.text = fee['fee_details'];
                      _selectedFeeName = fee['fee_name'];
                      _isFormVisible = true;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteFees(fee['id']),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header and Add Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3e53a0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _isFormVisible = !_isFormVisible;
                        if (!_isFormVisible) {
                          _editId = 0;
                          amountController.clear();
                          detailsController.clear();
                          _selectedFeeName = 'Full';
                        }
                      });
                    },
                    icon: Icon(
                      _isFormVisible ? Icons.cancel : Icons.add,
                      color: const Color(0xFFeceef0),
                    ),
                    label: Text(
                      _isFormVisible ? "Cancel" : "Add",
                      style: const TextStyle(color: Color(0xFFeceef0)),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedSize(
              duration: _animationDuration,
              curve: Curves.easeInOut,
              child: _isFormVisible ? _buildForm() : Container(),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Fee Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff252422),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildFeeList(),
          ],
        ),
      ),
    );
  }
}
