import 'package:flutter/material.dart';
import 'package:tinytots_parent/main.dart';
import 'package:tinytots_parent/sceen/dashboard.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Color(0xFFeceef0),
      
      body: Form(
        
        child: Padding(
          padding: EdgeInsets.only(top: 110, left: 20, right: 20),
        
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)
                 ),
              color: Color(0xFFffffff),
            ),
            height: 500,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Text("Welcome Back",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon: Icon(Icons.lock)),
                    ),
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                      onPressed: () {
                       signin();
                      },
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
        //img
     
      ),
    );
  }
}
