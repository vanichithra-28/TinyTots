import 'package:flutter/material.dart';
import 'package:tinytots_parent/main.dart';
import 'package:tinytots_parent/sceen/changepwd.dart';
import 'package:tinytots_parent/sceen/edit.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  
 bool isLoading = true;
    Map<String, dynamic> parentData = {};

  Future<void> display() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await supabase
          .from('tbl_parent')
          .select()
          .eq('id', supabase.auth.currentUser!.id)
          .single();
      setState(() {
        parentData = response;
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
      print('ERROR DISPLAYING PROFILE DATA:$e');
    }
  }

  @override
  void initState() {
    super.initState();
    display();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 700,
        width: 500,
        decoration: BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              )
            ]),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(parentData['parent_photo'] ?? ""),
                ),              SizedBox(height: 20),
            
                Text(" ${parentData['parent_name'] ?? 'N/A'}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 10),
                Text(" ${parentData['parent_email'] ?? 'N/A'}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                SizedBox(height: 10),
                Text(" ${parentData['parent_contact'] ?? 'N/A'}",  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                SizedBox(height: 10),
                Text(" ${parentData['parent_address'] ?? 'N/A'}",  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                SizedBox(height: 10),
                ElevatedButton(onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfile()));                
                }, 
                style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFbc6c25),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                child: Text('Edit Profile',style: TextStyle(
                            fontSize: 18,
                            color: Color(0xfff8f9fa),
                          ),),
                
                ),
                SizedBox(height: 10,),
                 ElevatedButton(onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Changepwd()));                
                },
                style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFbc6c25),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                 child: Text('Change Password',style: TextStyle(
                            fontSize: 18,
                            color: Color(0xfff8f9fa),
                          ),),
                
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}