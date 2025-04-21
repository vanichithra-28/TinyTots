import 'package:flutter/material.dart';
import 'package:tinytots_admin/main.dart';

class ManageMeals extends StatefulWidget {
  const ManageMeals({super.key});

  @override
  State<ManageMeals> createState() => _ManageMealsState();
}

class _ManageMealsState extends State<ManageMeals> {
  bool _isFormVisible = false;
  final TextEditingController mealController = TextEditingController();
  String? selectedDay;
  List<Map<String, dynamic>> _mealList = [];
  int? _editId;
  final List<String> weekDays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    
  ];

  Future<void> updateMeal() async {
    if (_editId != null) {
      try {
        await supabase.from('tbl_meal').update({
          'meal_name': mealController.text,
          'meal_day': selectedDay,
        }).eq('id', _editId!);
        resetForm();
        select();
        showSnackbar("Meal Updated", Colors.green);
      } catch (e) {
        print("ERROR UPDATING MEAL: $e");
      }
    }
  }

  Future<void> mealSubmit() async {
    if (mealController.text.isEmpty || selectedDay == null) return;
    try {
      await supabase.from('tbl_meal').insert({
        'meal_name': mealController.text,
        'meal_day': selectedDay,
      });
      resetForm();
      select();
      showSnackbar("Meal Inserted", Colors.green);
    } catch (e) {
      print("ERROR ADDING MEAL: $e");
    }
  }

  Future<void> select() async {
    try {
      final response = await supabase.from('tbl_meal').select();
      setState(() {
        _mealList = response.cast<Map<String, dynamic>>();
      });
    } catch (e) {
      print("ERROR DISPLAYING MEALS: $e");
    }
  }

  void delete(int mealId) async {
    try {
      await supabase.from('tbl_meal').delete().eq('id', mealId);
      select();
      showSnackbar("Meal Deleted", Colors.red);
    } catch (e) {
      print("ERROR DELETING MEAL: $e");
    }
  }

  void resetForm() {
    setState(() {
      mealController.clear();
      selectedDay = null;
      _editId = null;
      _isFormVisible = false;
    });
  }

  void showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  void initState() {
    super.initState();
    select();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff3e53a0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              ),
              onPressed: () => setState(() => _isFormVisible = !_isFormVisible),
              label: Text(_isFormVisible ? "Cancel" : "Add Meal",
                  style: TextStyle(color: Colors.white)),
              icon: Icon(_isFormVisible ? Icons.cancel : Icons.add,
                  color: Colors.white),
            ),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _isFormVisible
                ? Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: mealController,
                                decoration: InputDecoration(
                                  labelText: 'Meal Name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: weekDays.contains(selectedDay) ? selectedDay : null,
                                hint: Text("Select Day"),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: weekDays
                                    .map((day) => DropdownMenuItem(
                                        value: day, child: Text(day)))
                                    .toList(),
                                onChanged: (value) =>
                                    setState(() => selectedDay = value),
                              ),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff3e53a0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 16),
                              ),
                              onPressed: () =>
                                  _editId == null ? mealSubmit() : updateMeal(),
                              child: Text(_editId == null ? 'Submit' : 'Update',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ),
          SizedBox(height: 20),
          Text("MEAL DETAILS",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3e53a0))),
          Divider(thickness: 1.2),
          _mealList.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      "No meals found.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color(0xFFeceef0),
                        width: 2,
                      ),
                    ),
                    child: DataTable(
                      columns: [
                        DataColumn(
                            label: Text("Sl.No",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff252422)))),
                        DataColumn(
                            label: Text("Meal Name",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff252422)))),
                        DataColumn(
                            label: Text("Meal Day",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff252422)))),
                        DataColumn(
                            label: Text("Edit",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff252422)))),
                        DataColumn(
                            label: Text("Delete",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff252422)))),
                      ],
                      rows: _mealList.asMap().entries.map((entry) {
                        return DataRow(cells: [
                          DataCell(Text((entry.key + 1).toString(),
                              style: TextStyle(color: Color(0xff252422)))),
                          DataCell(Text(
                            entry.value['meal_name'],
                            style: TextStyle(
                                color: Color(0xff252422),
                                fontWeight: FontWeight.w600),
                          )),
                          DataCell(Text(
                            entry.value['meal_day'],
                            style: TextStyle(color: Color(0xff252422)),
                          )),
                          DataCell(IconButton(
                            icon: Icon(Icons.edit, color: Colors.green),
                            onPressed: () {
                              setState(() {
                                _editId = entry.value['id'];
                                mealController.text = entry.value['meal_name'];
                                selectedDay = entry.value['meal_day'];
                                _isFormVisible = true;
                              });
                            },
                          )),
                          DataCell(IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => delete(entry.value['id']),
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
