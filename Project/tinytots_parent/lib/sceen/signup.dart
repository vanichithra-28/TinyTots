import 'package:flutter/material.dart';
import 'package:tinytots_parent/sceen/login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Color(0xFFffffff),
      ),
      body: Form(
          child: Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: Container(
          color: Color(0xFFffffff),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                
                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Username',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',  
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),SizedBox(height: 50,),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    child: Text('SIGNUP'))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
