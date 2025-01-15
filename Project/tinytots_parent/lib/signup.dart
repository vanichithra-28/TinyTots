import 'package:flutter/material.dart';
import 'package:tinytots_parent/login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(backgroundColor: Color(0xFFa53860),),
    body: Form(child: Padding(padding: EdgeInsets.all(10.0),
    child: Column(children: [
      Text('USER NAME'),
      TextFormField(decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),),
      Text('EMAIL'),
      TextFormField(decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),),
      Text('PASSWORD'),
      TextFormField(decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),),
      ElevatedButton(onPressed: () { Navigator.push(context,MaterialPageRoute(builder: (context) => Login()),);
        
      }, child: Text('SIGNUP'))
    ],),)),  
    );
  }
}