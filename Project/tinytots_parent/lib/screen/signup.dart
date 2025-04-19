import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:tinytots_parent/main.dart';
import 'package:tinytots_parent/screen/intro.dart';
import 'package:file_picker/file_picker.dart'; // Added for file picking

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
  File? _image;
  File? _proof; // Added for proof file
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Pick file for proof
  Future<void> _pickProof() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'], // Adjust allowed file types as needed
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _proof = File(result.files.single.path!);
      });
    }
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

      String? proofUrl;
      if (_proof != null) {
        proofUrl = await uploadProof();
      }

      await supabase.from('tbl_parent').insert({
        'id': uid,
        'parent_name': nameController.text.trim(),
        'parent_contact': contactController.text.trim(),
        'parent_address': addressController.text.trim(),
        'parent_proof': proofUrl, // Use uploaded proof URL instead of text
        'parent_photo': imageUrl,
        'parent_email': emailController.text.trim(),
        'parent_pwd': passwordController.text.trim(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Intro()),
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
      final uid = supabase.auth.currentUser?.id ?? 'unknown';
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$uid-photo-$timestamp';

      await supabase.storage.from('parent').upload(fileName, _image!);

      return supabase.storage.from('parent').getPublicUrl(fileName);
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  // Upload proof to Supabase storage (proof bucket)
  Future<String?> uploadProof() async {
    if (_proof == null) return null;
    try {
      final uid = supabase.auth.currentUser?.id ?? 'unknown';
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$uid-proof-$timestamp.${_proof!.path.split('.').last}';

      await supabase.storage.from('proof').upload(fileName, _proof!);

      return supabase.storage.from('proof').getPublicUrl(fileName);
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
          padding: const EdgeInsets.only(top: 10.0),
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
                            ? const Icon(Icons.camera_alt, color: Color(0xFFbc6c25), size: 50)
                            : null,
                      ),
                    ),
                  ),
                  ..._buildTextFields(),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: register,
                    child: const Text(
                      'SIGNUP',
                      style: TextStyle(color: Color(0xfff8f9fa)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFbc6c25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
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
    ];

    return [
      ...fields.map((field) {
        return Padding(
          padding: const EdgeInsets.only(top: 10.0),
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
      }).toList(),
      // Add the proof file picker widget separately
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: GestureDetector(
          onTap: _pickProof,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _proof == null
                        ? 'Select Proof'
                        : 'Proof: ${_proof!.path.split('/').last}',
                    style: TextStyle(
                      color: _proof == null ? Colors.grey : Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Icon(Icons.attach_file, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    ];
  }
}