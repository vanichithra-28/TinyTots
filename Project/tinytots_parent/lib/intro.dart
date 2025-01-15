import 'package:flutter/material.dart';
import 'package:tinytots_parent/login.dart';
import 'package:tinytots_parent/signup.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFedf2fb),
      
body: Form(
  child: Center(
    child: Column(mainAxisAlignment:MainAxisAlignment.end,
      children: [
        ElevatedButton(onPressed:() {
           Navigator.push(context,MaterialPageRoute(builder: (context) => Login()),);
        }, child:Text(" Login ")),
        ElevatedButton(onPressed:() {
           Navigator.push(context,MaterialPageRoute(builder: (context) => Signup()),);
        }, child:Text("Sign Up")),
          SizedBox(height: 30),
      ],
    ),
  ),
),
    );
  }
}