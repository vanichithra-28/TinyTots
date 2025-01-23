import 'package:flutter/material.dart';
import 'package:tinytots_admin/screen/Login.dart';

class SideBar extends StatefulWidget {
  final Function(int) onItemSelected;
  const SideBar({super.key, required this.onItemSelected});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final List<String> pages = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    
  ];
  final List<IconData> icons = [
    Icons.home, 
    Icons.person, // Icon for "Manage Events"
    Icons.menu_book_sharp, // Icon for "Manage Faculty"
    Icons.person_2_rounded, // Icon for "Manage Departments"
    Icons.event_rounded, // Icon for "Manage Clubs"
    Icons.task, 
    Icons.check_box,// Icon for "Newsletter"
    Icons.payment,
    
     // Icon for "Manage Faculty"
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(                        
                           Radius.circular(10)),
            gradient: LinearGradient(colors: [
          const Color(0xffFF6EC7),
          Color(0xff87CEEB),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Image.asset(
                          'assets/logo3.png',
                          height: 50,
                          width: 150,
                        ),
                SizedBox(height: 10,),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: pages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 70.0,vertical: 5),
                        onTap: () {
                          widget.onItemSelected(index);
                        },
                        leading: Icon(icons[index],size: 30.0, color:Color(0xff03045e)),
                        title: Text(pages[index],
                            style: TextStyle(color:Color(0xff03045e))),
                          
                      );
                    }),
              ],
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 70.0,),
              leading: Icon(Icons.logout_outlined,size: 30.0, color:Color(0xff03045e)),
              
              onTap: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => Login()),);
              },
            ),
          ],
        ),
      ),
    );
  }
}