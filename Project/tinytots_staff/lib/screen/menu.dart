import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:tinytots_staff/screen/login.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f9fa),
      body: Column(
        children: [
          
          SizedBox(height: 30,),
          
          Row(
            children: [
              Text(' Logout  '),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => Login()));
                },
                child: HugeIcon(
                 
                  icon: HugeIcons.strokeRoundedLogout03,
                  color: Colors.black,
                  
                  size: 24.0,
                  
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}