import 'package:flutter/material.dart';
import 'package:tinytots_parent/screen/login.dart';
import 'package:tinytots_parent/screen/signup.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f9fa),
      body: Form(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xfff8f9fa),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4))),
                child: Text("Login ",style: TextStyle(color: Color(0xFFbc6c25))),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Signup()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFbc6c25),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4))),
                child: Text("Sign Up", style: TextStyle(color: Color(0xfff8f9fa))),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
