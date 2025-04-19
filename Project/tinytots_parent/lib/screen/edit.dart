import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tinytots_parent/main.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  Map<String, dynamic> staffData = {};
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      String? url = await uploadImage(); 
      await updateImage(url);
    }
  }

  Future<void> updateImage(String? url) async {
    try {
      String uid = supabase.auth.currentUser!.id;
      await supabase
          .from('tbl_parent')
          .update({'parent_photo': url}).eq("id", uid);
    } catch (e) {
      print("Image updation failed: $e");
    }
  }

  Future<void> display() async {
    try {
     
      if (staffData != null) {
        final response = await supabase
            .from('tbl_parent')
            .select()
            .eq('id', supabase.auth.currentUser!.id)
            .single();
        setState(() {
          staffData = response;
          nameController.text = response['parent_name'];
          contactController.text = response['parent_contact'];
          addressController.text = response['parent_address'];
        });
      } else {
        print("Error");
      }
    } catch (e) {
      print("ERROR FETCHING DATA:$e");
    }
  }

  Future<void> updateData() async {
    try {
      await supabase.from('tbl_parent').update({
        'parent_name': nameController.text,
        'parent_contact': contactController.text,
        'parent_address': addressController.text,
      }).eq('id', staffData['id']);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Profile Updated',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black45,
        ),
      );
      display();
    } catch (e) {
      print("ERROR UPDATING PROFILE:$e");
    }
  }

Future<String?> uploadImage() async {
  try {
    String uid = supabase.auth.currentUser!.id;

  
    final timestamp = DateTime.now().millisecondsSinceEpoch; 
    final fileName = '$uid-photo-$timestamp'; 

    // Upload the image to Supabase storage
    await supabase.storage.from('parent').upload(fileName, _image!);

    // Get the public URL of the uploaded image
    final imageUrl = supabase.storage.from('parent').getPublicUrl(fileName);
    return imageUrl;
  } catch (e) {
    print('Image upload failed: $e');
    return null;
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
      body: Padding(
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
                SizedBox(height: 30,),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white38,
                      backgroundImage:
                          _image != null ? FileImage(_image!) : NetworkImage(staffData['parent_photo'] ?? ""),
                      child: _image == null
                          ?  HugeIcon(
  icon: HugeIcons.strokeRoundedCameraAdd01,
  color: Colors.black12,
  size: 24.0,
)
                          : null,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: contactController,
                    decoration: InputDecoration(
                        labelText: 'Contact',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      updateData();
                    },
                     style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFbc6c25),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                    child: Text('Update ',style: TextStyle(
                            fontSize: 18,
                            color: Color(0xfff8f9fa),
                          ),)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
