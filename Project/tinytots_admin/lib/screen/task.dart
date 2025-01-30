import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule>
    with SingleTickerProviderStateMixin {
 
  @override
  
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
       children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(child: Text('task',style:TextStyle(
                              color: Color(0xffffffff)) ,),width: 1000,height: 500,color: Color(0xFFeceef0),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(child: Text('adn',style:TextStyle(
                              color: Color(0xffffffff)) ,),width: 200,height: 500,color: Color(0xFFeceef0),),
            )
          ],
        ),
      ),SizedBox(height: 5,),
      Container(child: Text('ffbbn',style:TextStyle(
                              color: Color(0xffffffff)) ,),color: Color(0xFFeceef0),width: 500,)
       ],
      ),
    );
  }
}
