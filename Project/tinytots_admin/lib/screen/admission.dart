import 'package:flutter/material.dart';
import 'package:tinytots_admin/main.dart';

class Admission extends StatefulWidget {
  const Admission({super.key});

  @override
  State<Admission> createState() => _AdmissionState();
}

class _AdmissionState extends State<Admission> {
  @override
  List<Map<String,dynamic>>_admissionList=[];
  void display()async{
    try{
     final reponse = await supabase.from('tbl_child').select();
       setState(() {
        _admissionList = reponse;
      });
    }
    catch(e){
      print('ERROR');
    }
  }
  Widget build(BuildContext context) {
   return Form(child: 
    Container(
       padding: EdgeInsets.all(16), // Padding inside the container
                margin: EdgeInsets.all(16), // Margin outside the container
                decoration: BoxDecoration(
                  color: Color(0xffffffff), // Background color of the container
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  border: Border.all(
                    color: Color(0xFFeceef0), // Border color
                    width: 2, // Border width
                  ),
                  
                ),
      child: DataTable(columns: 
      [
        DataColumn(label: Text("Sl.No",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,color: Color(0xffB4B4B6)))),
                              DataColumn(label: Text("Name",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,color: Color(0xffB4B4B6)))),
                               DataColumn(label: Text("Application Date",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,color: Color(0xffB4B4B6)))),
                              DataColumn(label: Text("Admission Status",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,color: Color(0xffB4B4B6)))),
                              DataColumn(label: Text("View Details",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,color: Color(0xffB4B4B6)))),
      ], rows:  _admissionList.asMap().entries.map((entry){
        return DataRow(cells: [
          DataCell(Text((entry.key+1).toString())),
          DataCell(Text(entry.value['name']),),
            DataCell(Text(entry.value['created_at'])),
           DataCell(Text(entry.value['status'])),
            DataCell(Text("View")),
        ]);
      }).toList(),
    )));
  }}
