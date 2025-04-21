import 'package:flutter/material.dart';
import 'package:tinytots_admin/main.dart';
import 'package:tinytots_admin/screen/Login.dart';
import 'package:hugeicons/hugeicons.dart';

class SideBar extends StatefulWidget {
  final Function(int) onItemSelected;
  final int selectedIndex;

  const SideBar(
      {super.key, required this.onItemSelected, required this.selectedIndex});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final List<String> pages = [
    "Home",
    "Staff",
    "Admission",
    "Parent",
    "Classrooms",
    "Events",
    "Attendance",
    "Fee",
    "Meal",
    "Staff Attendance",
    'Feedback'
  ];

  final List<IconData> iconList = [
    HugeIcons.strokeRoundedHome01,
    HugeIcons.strokeRoundedUserGroup,
   HugeIcons.strokeRoundedFiles01,
    HugeIcons.strokeRoundedUser,
    HugeIcons.strokeRoundedMentor,
HugeIcons.strokeRoundedCalendar03,
    HugeIcons.strokeRoundedNotebook,
    HugeIcons.strokeRoundedCreditCard,
    HugeIcons.strokeRoundedCupcake01,
    HugeIcons.strokeRoundedUserGroup,
   HugeIcons.strokeRoundedCommentAdd01,];
 

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
        color: Color(0xff3e53a0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: pages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(100),
                              bottomLeft: Radius.circular(100)),
                          child: Container(
                            color: widget.selectedIndex == index
                                ? Color(0xFFeceef0)
                                : Colors.transparent,
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              onTap: () {
                                widget.onItemSelected(index);
                              },
                              leading: Icon(
                                iconList[index],
                                size: 22,
                                color: widget.selectedIndex == index
                                    ? Colors.black
                                    : Color(0xffFFFFFF),
                              ),
                              title: Text(
                                pages[index],
                                style: TextStyle(
                                  color: widget.selectedIndex == index
                                      ? Colors.black
                                      : Color(0xffFFFFFF),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 30, bottom: 5.0),
            leading: Icon(Icons.logout_outlined,
                size: 20.0, color: Color(0xffFFFFFF)),
            title: Text(
              "Logout",
              style: TextStyle(
                color: Color(0xffFFFFFF),
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Color(0xfff4f6fa),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  title: Row(
                    children: [
                      Icon(Icons.logout, color: Color(0xff3e53a0)),
                      SizedBox(width: 8),
                      Text('Logout',
                          style: TextStyle(color: Color(0xff3e53a0))),
                    ],
                  ),
                  content: Text(
                    'Are you sure you want to logout?',
                    style: TextStyle(color: Color(0xff3e53a0)),
                  ),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xff3e53a0),
                        backgroundColor: Color(0xffeceef0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xff3e53a0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Logout'),
                    ),
                  ],
                ),
              );
              if (shouldLogout == true) {
                supabase.auth.signOut().then((value) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                    (route) => false,
                  );
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
