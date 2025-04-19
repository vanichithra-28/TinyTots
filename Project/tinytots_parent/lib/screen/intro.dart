import 'package:flutter/material.dart';
import 'package:tinytots_parent/screen/login.dart';
import 'package:tinytots_parent/screen/signup.dart';
import 'package:lottie/lottie.dart';

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
      body: Stack(
        children: [
          // Lottie animation as background
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 550, // Adjust this height as needed
            child: Lottie.asset(
              'assets/log.json',
              fit: BoxFit.contain,
              repeat: true,
            ),
          ),
          // Your content on top
          Center(
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                       backgroundColor: Color(0xFF000000),
                      minimumSize: Size(300, 40), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 8, // Add elevation for better visibility
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(color: Color(0xFFbc6c25)),
                    ),
                  ),
                  SizedBox(height: 20), // Add some spacing between buttons
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signup()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(300, 40), 
                      backgroundColor: Color(0xFFbc6c25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 8, // Add elevation for better visibility
                    ),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Color(0xfff8f9fa)),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}