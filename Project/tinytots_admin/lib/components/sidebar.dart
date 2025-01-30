import 'package:flutter/material.dart';
import 'package:tinytots_admin/screen/Login.dart';

class SideBar extends StatefulWidget {
  final Function(int) onItemSelected;
  final int selectedIndex;  // Add selectedIndex to highlight the selected item

  const SideBar({super.key, required this.onItemSelected, required this.selectedIndex});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final List<String> pages = [
    "Home",
    "Staff",
    "Admission",
    "Parent",
    "Events",
    "Task",
    "Attendance",
    "Fee",
  ];

  final List<IconData> icons = [
    Icons.home, 
    Icons.person, 
    Icons.menu_book_sharp, 
    Icons.person_2_rounded, 
    Icons.event_rounded, 
    Icons.task, 
    Icons.check_box,
    Icons.payment,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
        color: Color(0xff3e53a0),
      ),
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
              SizedBox(height: 10),
              ListView.builder( 
                shrinkWrap: true,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                    onTap: () {
                      widget.onItemSelected(index);
                    
                    },
                    leading: Icon(icons[index], size: 25.0, color: Color(0xffFFFFFF)),
                    title: Text(
                      pages[index],
                      style: TextStyle(color: Color(0xffFFFFFF)),
                    ),
                    selected: widget.selectedIndex == index,  // Use selected property
                    selectedTileColor: Colors.blueAccent,  // Set color for selected item
                  );
                },
              ),
            ],
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 80.0),
            leading: Icon(Icons.logout_outlined, size: 30.0, color: Color(0xffFFFFFF)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
        ],
      ),
    );
  }
}
