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
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff3e53a0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
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
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: mealController,
                            decoration: InputDecoration(
                              labelText: 'Meal Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedDay,
                            hint: Text("Select Day"),
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
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
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          onPressed: () =>
                              _editId == null ? mealSubmit() : updateMeal(),
                          child: Text(_editId == null ? 'Submit' : 'Update',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
          ),
          SizedBox(height: 20),
          Text("MEAL DETAILS",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff8b8c89))),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: EdgeInsets.all(16), // Padding inside the container
              margin: EdgeInsets.all(16), // Margin outside the container
              decoration: BoxDecoration(
                color: Color(0xffffffff), // Background color of the container
                borderRadius: BorderRadius.zero, // Rounded corners
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff8b8c89)))),
                  DataColumn(
                      label: Text("Meal Name",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff8b8c89)))),
                  DataColumn(
                      label: Text("Meal Day",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff8b8c89)))),
                  DataColumn(
                      label: Text("Edit",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff8b8c89)))),
                  DataColumn(
                      label: Text("Delete",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff8b8c89)))),
                ],
                rows: _mealList.asMap().entries.map((entry) {
                  return DataRow(cells: [
                    DataCell(Text((entry.key + 1).toString())),
                    DataCell(Text(
                      entry.value['meal_name'],
                      style: TextStyle(color: Color(0xff8b8c89)),
                    )),
                    DataCell(Text(
                      entry.value['meal_day'],
                      style: TextStyle(color: Color(0xff8b8c89)),
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
