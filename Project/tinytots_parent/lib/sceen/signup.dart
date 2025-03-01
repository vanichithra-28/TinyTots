import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:tinytots_parent/main.dart';
import 'package:tinytots_parent/sceen/dashboard.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController proofController = TextEditingController();
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

  Future<void> register() async {
  try {
    // Sign up user
    final authResponse = await supabase.auth.signUp(
      password: passwordController.text,
      email: emailController.text,
    );
    final user = authResponse.user;
    if (user == null) throw Exception('Sign up failed');

    final uid = user.id;

    // Upload image
    String? imageUrl;
    if (_image != null) {
      imageUrl = await uploadImage();
    }

    // Insert parent data
    await supabase.from('tbl_parent').insert({
      'id': uid,
      'parent_name': nameController.text,
      'parent_contact': contactController.text,
      'parent_address': addressController.text,
      'parent_proof': proofController.text,
      'parent_photo': imageUrl,
      'parent_email': emailController.text,
      'parent_pwd': passwordController.text,
    });

    // Navigate only after success
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Dashboard()),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

   Future<void> updateData() async {
  try {
    final uid = supabase.auth.currentUser!.id;
    
    await supabase.from('tbl_parent').update({
      'parent_name': nameController.text,
      'parent_contact': contactController.text,
      'parent_address': addressController.text,
      'parent_proof': proofController.text,
    }).eq('id', uid); // Use UID from auth
  } catch (e) {
    print("Update error: $e");
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

  Future<String?> uploadImage() async {
  if (_image == null) return null;
  
  try {
    final uid = supabase.auth.currentUser!.id;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '$uid-photo-$timestamp';

    await supabase.storage
        .from('parent')
        .upload(fileName, _image!);

    return supabase.storage
        .from('parent')
        .getPublicUrl(fileName);
  } catch (e) {
    print('Upload error: $e');
    return null;
  }
}

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f9fa),
      appBar: AppBar(
        backgroundColor: Color(0xFFffffff),
      ),
      body: Form(
          child: Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: SingleChildScrollView(
          child: Container(
            height: 600,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white38,
                        backgroundImage:
                            _image != null ? FileImage(_image!) : null,
                        child: _image == null
                            ? const Icon(Icons.camera_alt,
                                color: Colors.black, size: 50)
                            : null,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: contactController,
                    decoration: InputDecoration(
                        labelText: 'Contact',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: proofController,
                    decoration: InputDecoration(
                        labelText: 'Proof',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        register();
                      },
                      child: Text('SIGNUP'))
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
