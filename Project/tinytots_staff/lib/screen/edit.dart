import 'package:flutter/material.dart';
import 'package:tinytots_staff/main.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String staffData = '';
   Future<void> display() async {
    try {
      staffData = supabase.auth.currentUser!.id;
      if (staffData!= null) {
        final response = await supabase
            .from('tbl_staff')
            .select()
            .eq('id', staffData)
            .single();
        setState(() {
         
          nameController.text = response['staff_name'];
          contactController.text = response['staff_contact'];
           addressController.text = response['staff_address'];
        });
      } else {
        print("Error");
      }
    } catch (e) {
      print("ERROR FETCHING DATA:$e");
    }
  }

  Future<void> UpdateData() async {
    try {
      await supabase.from('tbl_staff').update({
        'staff_name': nameController.text,
        'staff_contact':contactController.text,
        'staff_address':addressController.text,
      }).eq('id', staffData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Profile Updated',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      display();
      

    } catch (e) {
      print("ERROR UPDATING PROFILE:$e");
    }
  }
  @override
  void initState() {
    super.initState();
    display();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff8f9fa),
      appBar: AppBar(
         backgroundColor: Color(0xffffffff),
        title: Text('Edit Profile'),
        
      ),
      body:Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
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
                child: Column(
                  children: [
                    SizedBox(height: 80,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                        ),
                      ),
                    ),SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: contactController,
                        decoration: InputDecoration(
                          labelText: 'Contact',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                        ),
                      ),
                    ),
                    ElevatedButton(onPressed: () {
                      UpdateData();
                    }, child: Text('Update ')),
                
                  ],
                ),
          ),
        ),
      ),
    );
  }
}