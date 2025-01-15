import 'package:flutter/material.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(child: Padding(padding: EdgeInsets.all(10.0),
    
        
        child: Container(
          child: Column(
            children: [
              Text("Welcome Back",style: TextStyle(
                      fontSize: 20,)),
              
                  SizedBox(height: 20),
                 
              
              TextFormField(decoration: InputDecoration( labelText: 'Username',border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),prefixIcon: Icon(Icons.person),),),
              SizedBox(height: 30),
              TextFormField(decoration: InputDecoration( labelText: 'Password',border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),prefixIcon: Icon(Icons.lock)),),
              SizedBox(height: 30),
              ElevatedButton(onPressed: () {
                
              }, child: Text('LOGIN',style: TextStyle(
                      fontSize: 18,),)),
              
            ],
          ),
        ),
      ),),);
  }
}