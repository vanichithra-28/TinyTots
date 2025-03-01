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
            
                Text(parentData['parent_name'] ?? 'No Name', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 10),
                Text(parentData['parent_email'] ?? 'No Email', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                SizedBox(height: 10),
                Text(parentData['parent_contact'] ?? 'No Phone',  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                SizedBox(height: 10),
                Text(parentData['parent_address'] ?? 'No Address',  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                SizedBox(height: 10),
                ElevatedButton(onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfile()));                
                }, child: Text('Edit Profile'),
                
                ),
                SizedBox(height: 10,),
                 ElevatedButton(onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Changepwd()));                
                }, child: Text('Change Password'),
                
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}