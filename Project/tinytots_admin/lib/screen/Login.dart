import 'package:flutter/material.dart';
import 'package:tinytots_admin/main.dart';
import 'package:tinytots_admin/screen/dashboard.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cherry_toast/cherry_toast.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  
   Future<void> signin() async {
    try {
      await supabase.auth.signInWithPassword(
  email: emailController.text.trim(),
  password:passwordController.text.trim(),
);
   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard())); 
  
    } catch (e) {
       
      print('ERROR: $e');
      CherryToast.error(
              description: Text("No user found for that email.",
                  style: TextStyle(color: Colors.black)),
              animationType: AnimationType.fromRight,
              animationDuration: Duration(milliseconds: 1000),
              autoDismiss: true)
          .show(context);
      print('No user found for that email.');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Row(
        children: [
          //left side
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: 155),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15)),
                    color: Color(0xffFFC1CC),
                  ),
                  height: 550,
                  child: Stack(children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Image.asset(
                        'assets/baloon.png',
                        height: 300,
                        width: 150,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        'assets/watercolor.png',
                        height: 250,
                        width: 300,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        'assets/logo3.png',
                        height: 250,
                        width: 250,
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),

//right side
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(right: 190),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: Colors.white,
                  ),
                  height: 550,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 120),
                        child: Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff03045e),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(left: 60, right: 90),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.only(left: 60, right: 90),
                        child: TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              prefixIcon: Icon(Icons.lock)),
                        ),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          signin();
                        },
                        child: Text(
                          'LOGIN',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff03045e)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
