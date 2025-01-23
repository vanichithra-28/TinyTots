import 'package:flutter/material.dart';
import 'package:tinytots_admin/main.dart';

class Staff extends StatefulWidget {
  const Staff({super.key});

  @override
  State<Staff> createState() => _StaffState();
}

class _StaffState extends State<Staff> with SingleTickerProviderStateMixin {
  bool _isFormVisible = false;
  @override
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController startdateController = TextEditingController();
  
  final TextEditingController statusController = TextEditingController();
  List<Map<String,dynamic>>_staffList = [];
  void insert()async{
    try{
    String Name=nameController.text;  
    String Email=emailController.text;
    String Contact=contactController.text;
    
    String StartDate=startdateController.text;
    await supabase.from('tbl_staff').insert({
    'staff_name':Name,
    'staff_email':Email,
    'staff_contact':Contact,
    
    'start_date':StartDate,
    });
    display();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Inserted"),
      ));
    }
    catch(e)
    {
      print('ERROR');
    }
  }
  void display()async{
    try{
     final reponse = await supabase.from('tbl_staff').select();
       setState(() {
        _staffList = reponse;
      });
    }
    catch(e){
      print('ERROR');
    }
  }
  @override
   void initState() {
    // TODO: implement initState
    super.initState();
    display();
  }
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 1100, top: 10),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff03045e),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4))),
                onPressed: () {
                  setState(() {
                    _isFormVisible = !_isFormVisible; // Toggle form visibility
                  });
                },
                label: Text(_isFormVisible ? "Cancel" : "Add "),
                icon: Icon(
                  _isFormVisible ? Icons.cancel : Icons.add,
                  color: Colors.blueAccent,
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
              ? Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      color: Color.fromARGB(15, 240, 239, 239),
                    ),
                    child: Form(
                        child: Padding(
                      padding: const EdgeInsets.only(
                        left: 200.0,
                        right: 300,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Name',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.zero)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.zero)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Contact',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.zero)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Start Date',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.zero)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(onPressed: () {
                              insert();
                            }, child: Text("Insert"))
                          ],
                        ),
                      ),
                    )),
                  ),
                )
              : Container(),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'STAFF DETAILS',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: EdgeInsets.all(16), // Padding inside the container
                margin: EdgeInsets.all(16), // Margin outside the container
                decoration: BoxDecoration(
                  color: Color(0xfff8f7ff), // Background color of the container
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  border: Border.all(
                    color: Color(0xffffffff), // Border color
                    width: 2, // Border width
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff616898).withOpacity(0.5), // Shadow color
                      spreadRadius: 2, // How much the shadow spreads
                      blurRadius: 5, // How blurry the shadow is
                      offset: Offset(0, 3), // Offset of the shadow (x, y)
                    ),
                  ],
                ),
            child: DataTable(columns: [
              DataColumn(
                  label: Text('Sl.No',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Name',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Email',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Contact',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Start Date',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              // DataColumn(
              //     label: Text('Status',
              //         style:
              //             TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            ],
            rows: _staffList.asMap().entries.map((entry) {
                    return DataRow(cells: [
                      DataCell(Text((entry.key + 1).toString())),
                      DataCell(Text(entry.value['staff_name'])),
                      DataCell(Text(entry.value['staff_email'])),
                      DataCell(Text(entry.value['staff_contact'])),
                      DataCell(Text(entry.value['start_date'])),
                     
                    ]);
                  }).toList(), 
            ),
          ),
        )
      ],
    );
    ;
  }
}
