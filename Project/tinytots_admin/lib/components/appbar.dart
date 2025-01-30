import 'package:flutter/material.dart';

class Appbar extends StatefulWidget {
  const Appbar({super.key});

  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 55,
        width: 2500,
        decoration: BoxDecoration(color: const Color(0xFFeceef0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            
            Icon(
              Icons.person_2_sharp,
              color:Color(0xff10451d),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Admin",
              style: TextStyle(color:Color(0xff10451d)),
            ),
            SizedBox(
              width: 40,
            )
          ],
        ));
  }
}