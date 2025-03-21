import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tinytots_parent/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinytots_parent/sceen/dashboard.dart';
class ChildRegistration extends StatefulWidget {
  const ChildRegistration({super.key});

  @override
  State<ChildRegistration> createState() => _ChildRegistrationState();
}

class _ChildRegistrationState extends State<ChildRegistration> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController docController = TextEditingController();
   File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
 Future<String?> uploadImage() async {
    if (_image == null) return null;
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '-photo-$timestamp';

      await supabase.storage
          .from('child')
          .upload(fileName, _image!);

      return supabase.storage
          .from('child')
          .getPublicUrl(fileName);
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }
  Future<void> insert () async {
    try {
      final prefs = await SharedPreferences.getInstance();
    final parentId = prefs.getString('parentId');

    if (parentId == null) throw Exception('Parent ID not found');

    await supabase.from('tbl_child').insert({
      'name': nameController.text.trim(),
      'age': ageController.text.trim(),
      'gender': genderController.text.trim(),
      'dob': dobController.text.trim(),
      'documents': docController.text.trim(),
      'parent_id': parentId, // Ensure parent_id is set
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Child registered successfully!')),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Dashboard()),
    );
    } catch (e) {
      print('ERROR REGISTERING CHILD$e');
    }
    

  
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Child Registration'),
        backgroundColor: Color(0xFFffffff),
      ),
      backgroundColor: Color(0xFFf8f9fa),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Container(
            height: 680,
            width: 365,
            decoration: BoxDecoration(
              color: const Color(0xFFffffff),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: Column(
              children: [
                 Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white38,
                        backgroundImage: _image != null ? FileImage(_image!) : null,
                        child: _image == null
                            ? const Icon(Icons.camera_alt, color: Colors.black, size: 50)
                            : null,
                      ),
                    ),
                  ),
                TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 10,
                    ),TextFormField(
                      controller: ageController,
                      decoration: InputDecoration(
                          labelText: 'Age',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 10,
                    ),TextFormField(
                      controller: genderController,
                      decoration: InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 10,
                    ),TextFormField(
                      controller: dobController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          labelText: 'DOB',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    
                    TextFormField(
                      controller: docController,
                      decoration: InputDecoration(
                          labelText: 'Document',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                ElevatedButton(
                  onPressed: () {
                   
                   insert();
                  },
                  child: Text('Register Child'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}