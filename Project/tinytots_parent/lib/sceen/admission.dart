import 'package:flutter/material.dart';

class Admission extends StatefulWidget {
  const Admission({super.key});

  @override
  State<Admission> createState() => _AdmissionState();
}

class _AdmissionState extends State<Admission> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

     body: Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Name',
            
          ),   
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Age',
            
          ),   
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'hdhd',
          ),),
          TextFormField(
          decoration: InputDecoration(
            labelText: 'hdhd',
          ),),
          TextFormField(
          decoration: InputDecoration(
            labelText: 'hdhd',
          ),),
      ],
     ), 
    );

  }
}