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
    } catch (e) {
      print("ERROR ADDING MEAL: $e");
    }
  }
  Future<void> select() async {
    try {
      
      await supabase
          .from('tbl_meal')
          .select();
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("selected"),
      ));
    } catch (e) {
      print("ERROR ADDING MEAL: $e");
    }
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
                  onPressed: () {
                    setState(() {
                      _isFormVisible =
                          !_isFormVisible; // Toggle form visibility
                    });
                  },
                  label: Text(_isFormVisible ? "Cancel" : "Add Meals"),
                  icon: Icon(_isFormVisible ? Icons.cancel : Icons.add),
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
                                onPressed: () {
                                  mealSubmit();
                                },
                                child: Text('Submit'))
                                                    ],
                                                  ),
                          )),
                    ],
                  ))
                : Container(),
          ),
         
        ],
      ),
    );
  }
}
