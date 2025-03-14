import 'package:flutter/material.dart';

import 'package:tinytots_admin/main.dart';

class ManageMeals extends StatefulWidget {
  const ManageMeals({super.key});

  @override
  State<ManageMeals> createState() => _ManageMealsState();
}

class _ManageMealsState extends State<ManageMeals>
    with SingleTickerProviderStateMixin {
  bool _isFormVisible = false; // To manage form visibility
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final TextEditingController mealController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  List<Map<String, dynamic>> _mealList = [];
  int _editId = 0;

  Future<void> updateMeal() async {
    try {
      await supabase.from('tbl_meal').update({
        'meal_name': mealController.text,
        'meal_day': dayController.text,
      }).eq('id', _editId);
      select();
      mealController.clear();
      dayController.clear();
      _editId = 0;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Meal type Updated",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      print("ERROR UPDATING MEAL TYPE:$e");
    }
  }

  Future<void> mealSubmit() async {
    try {
      String meal = mealController.text;
      String day = dayController.text;
      await supabase
          .from('tbl_meal')
          .insert({'meal_name': meal, 'meal_day': day});
      mealController.clear();
      dayController.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Inserted"),
      ));
      select();
    } catch (e) {
      print("ERROR ADDING MEAL: $e");
    }
  }

  Future<void> select() async {
    try {
      final response = await supabase.from('tbl_meal').select();
      setState(() {
        _mealList = response;
      });

      
      
    } catch (e) {
      print("ERROR DISPLAYING MEAL: $e");
    }
  }

  void delete(int mealId) async {
    try {
      await supabase.from('tbl_meal').delete().eq('id', mealId);
      select();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Meal Deleted",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      print("ERROR DELETING MEAL DATA:$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    select();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 1100),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff3e53a0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4))),
                  onPressed: () {
                    setState(() {
                      _isFormVisible =
                          !_isFormVisible; // Toggle form visibility
                    });
                  },
                  label: Text(
                    _isFormVisible ? "Cancel" : "Add Meals",
                    style: TextStyle(color: Color(0xFFeceef0)),
                  ),
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
                      //F,orms
                      Form(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                  controller: mealController,
                                  decoration: InputDecoration(
                                    labelText: 'Meal Name',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.zero),
                                  )),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: TextFormField(
                                  controller: dayController,
                                  decoration: InputDecoration(
                                    labelText: 'Meal Day',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.zero),
                                  )),
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff3e53a0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4))),
                                onPressed: () {
                                  mealSubmit();
                                },
                                child: Text(
                                  'Submit',
                                  style: TextStyle(color: Color(0xFFeceef0)),
                                ))
                          ],
                        ),
                      )),
                    ],
                  ))
                : Container(),
          ),
          SizedBox(
            height: 20,
          ),
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
                        label: Text("Delete",
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
                  ],
                  rows: _mealList.asMap().entries.map((entry) {
                    return DataRow(cells: [
                      DataCell(Text(
                        (entry.key + 1).toString(),
                        style: TextStyle(color: Color(0xff8b8c89)),
                      )),
                      DataCell(
                        Text(
                          entry.value['meal_name'],
                          style: TextStyle(color: Color(0xff8b8c89)),
                        ),
                      ),
                      DataCell(Text(
                        entry.value['meal_day'],
                        style: TextStyle(color: Color(0xff8b8c89)),
                      )),
                      DataCell(
                        IconButton(
                          onPressed: () {
                            delete(entry.value['id']);
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ),
                      DataCell(IconButton(
                          onPressed: () {
                            setState(() {
                              _editId = entry.value['id'];
                              mealController.text = entry.value['meal_name'];
                              dayController.text = entry.value['meal_day'];
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
      ),
    );
  }
}
