import 'package:flutter/material.dart';
import 'package:tinytots_parent/sceen/login.dart';
import 'package:tinytots_parent/sceen/signup.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      
body: Form(
  child: Center(
    child: Column(mainAxisAlignment:MainAxisAlignment.center,
      children: [
        // Align(
        //               alignment: Alignment.topCenter,
        //               child: AspectRatio(
        //                 aspectRatio: 9/16,
        //                 child: Image.asset(
        //                   'assets/p3.jpg',
                          
        //               fit: BoxFit.cover,
                          
        //                 ),
        //               ),
        //             ),
        ElevatedButton(onPressed:() {
           Navigator.push(context,MaterialPageRoute(builder: (context) => Login()),);
        }, child:Text(" Login "),style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 251, 251, 253),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4))),
        ),
        ElevatedButton(onPressed:() {
           Navigator.push(context,MaterialPageRoute(builder: (context) => Signup()),);
        }, child:Text("Sign Up"),style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 244, 244, 249),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4))),),
          SizedBox(height: 30),
      ],
    ),
  ),
),
    );
  }
}