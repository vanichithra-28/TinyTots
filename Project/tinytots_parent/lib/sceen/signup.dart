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
  final TextEditingController nameControllor = TextEditingController();
  final TextEditingController emailControllor = TextEditingController();
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
      final  auth = await supabase.auth.signUp(
          password: passwordController.text, email: emailControllor.text);
      print("Error:$auth");
      final  uid = auth.user!.id;
      print(uid);
      if (uid.isEmpty || uid != "") {
        storeData(uid);
      }
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    } catch (e) {
      print("Error auth: $e");
    }
  }

  Future<void> storeData(uid) async {
    try {
      String name = nameControllor.text;
      String email = emailControllor.text;
      String password = passwordController.text;
      String contact = contactController.text;
      String address = addressController.text;
      String proof = proofController.text;
      await supabase.from('tbl_parent').insert({
        'id': uid,
        'parent_name': name,
        'parent_email': email,
        'parent_pwd': password,
        'parent_contact': contact,
        'parent_address': address,
        'parent_proof': proof,
      });

      print("Data inserted");

      final imageUrl = await uploadImage(uid);
      await updateData(uid, imageUrl);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          " added",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      print("Error inserting parents data:$e");
    }
  }

  Future<void> updateData(final uid, final url) async {
    try {
      await supabase
          .from('tbl_parent')
          .update({'parent_photo': url}).eq("id", uid);
    } catch (e) {
      print("Image updation failed: $e");
    }
  }

  Future<String?> uploadImage(String uid) async {
    try {
      final fileName = '$uid';

      await supabase.storage.from('parent').upload(fileName, _image!);

      // Get public URL of the uploaded image
      final imageUrl = supabase.storage.from('parent').getPublicUrl(fileName);
      return imageUrl;
    } catch (e) {
      print('Image upload failed: $e');
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
                    controller: nameControllor,
                    decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: emailControllor,
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
