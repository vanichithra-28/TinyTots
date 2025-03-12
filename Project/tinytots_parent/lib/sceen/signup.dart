import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:tinytots_parent/main.dart';
import 'package:tinytots_parent/sceen/childreg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
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

  Future<void> saveParentId(String parentId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('parentId', parentId);
  }

  Future<void> register() async {
    try {
      final authResponse = await supabase.auth.signUp(
        password: passwordController.text,
        email: emailController.text,
      );
      final user = authResponse.user;
      if (user == null) throw Exception('Sign up failed');

      final uid = user.id;

      String? imageUrl;
      if (_image != null) {
        imageUrl = await uploadImage();
      }

      await supabase.from('tbl_parent').insert({
        'id': uid,
        'parent_name': nameController.text.trim(),
        'parent_contact': contactController.text.trim(),
        'parent_address': addressController.text.trim(),
        'parent_proof': proofController.text.trim(),
        'parent_photo': imageUrl,
        'parent_email': emailController.text.trim(),
        'parent_pwd': passwordController.text.trim(),
      });

      await saveParentId(uid);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChildRegistration()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      appBar: AppBar(
        backgroundColor: const Color(0xFFffffff),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: SingleChildScrollView(
            child: Container(
              height: 650,
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Text('Parent Registration'),
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
                  ..._buildTextFields(),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: register,
                    child: const Text('SIGNUP'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTextFields() {
    final fields = [
      {'controller': nameController, 'label': 'Username'},
      {'controller': emailController, 'label': 'Email'},
      {'controller': passwordController, 'label': 'Password'},
      {'controller': contactController, 'label': 'Contact'},
      {'controller': addressController, 'label': 'Address'},
      {'controller': proofController, 'label': 'Proof'},
    ];

    return fields.map((field) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: TextFormField(
          controller: field['controller'] as TextEditingController,
          decoration: InputDecoration(
            labelText: field['label'] as String,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }).toList();
  }
}
