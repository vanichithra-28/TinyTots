import 'package:flutter/material.dart';
import 'package:tinytots_admin/screen/dashboard.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.grey[100],
      
      body: Row(
      children: [
        
        //left side
Expanded(
  child: Center(
    child: Padding(
      padding: EdgeInsets.only(left: 155),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft:Radius.circular(15),bottomLeft: Radius.circular(15)),color: Color(0xffb7efc5),
        ),
        height: 550,
         child: Stack(
                children:[ 
                  Align(alignment:Alignment.bottomLeft,
                  child: Image.asset('assets/baloon.png',height: 300,width: 150,), 
                  ),
                 
               Align(alignment:Alignment.bottomRight,
                  child: Image.asset('assets/watercolor.png',height: 250,width: 300,), 
                  ),
                  Align(alignment:Alignment.topCenter,
                  child: Image.asset('assets/logo1.png',height: 200,width: 250,), 
                  ),
                  
                 

                ]
              ),
        
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
        decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight:Radius.circular(10),bottomRight: Radius.circular(10)),
         color: Colors.white,),
       
        height: 550,
        
        
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 120),
            child: Text('Welcome Back',style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold ,color: Color(0xff10451d), ),),
            
          ),
          
            SizedBox(height: 20),
            Padding(
              padding:EdgeInsets.only(left: 60,right: 90),
              child: TextFormField(decoration: InputDecoration( labelText: 'Username',border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              prefixIcon: Icon(Icons.person),),),
            ),
                  SizedBox(height: 30),
            Padding(
              padding:EdgeInsets.only(left: 60,right: 90),
              child: TextFormField(decoration: InputDecoration( labelText: 'Password',border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              prefixIcon: Icon(Icons.lock)),),
            ),
                  SizedBox(height: 30),
                  ElevatedButton(onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => Dashboard()),);
                  }, child: Text('LOGIN',style: TextStyle(
                          fontSize: 18,color: Colors.white),),style:ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff10451d)
                          ),),
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