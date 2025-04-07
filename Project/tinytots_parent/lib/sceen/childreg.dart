import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tinytots_parent/main.dart';
import 'package:tinytots_parent/sceen/account.dart';
import 'package:file_picker/file_picker.dart'; // Add this import

class ChildRegistration extends StatefulWidget {
  const ChildRegistration({super.key});

  @override
  State<ChildRegistration> createState() => _ChildRegistrationState();
}

class _ChildRegistrationState extends State<ChildRegistration> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  String _selectedFeeName = 'Full';

  File? _image; // For the photo
  File? _document; // For the document
  final ImagePicker _picker = ImagePicker();

  String? selGender;
  final List<String> genderOp = ['Male', 'Female'];

  // Pick image for the photo
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Pick file for the document
  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'], // Adjust allowed file types
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _document = File(result.files.single.path!);
      });
    }
  }

  // Upload image to Supabase storage
  Future<String?> uploadImage() async {
    print("Image: $_image");
    if (_image == null) return null;
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'child-photo-$timestamp';
      final filePath = '$fileName';
      await supabase.storage.from('child').upload(fileName, _image!);
      return supabase.storage.from('child').getPublicUrl(fileName);
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  // Upload document to Supabase storage
  Future<String?> uploadDocument() async {
    print("Document: $_document");
    if (_document == null) return null;
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'child-document-$timestamp.${_document!.path.split('.').last}';
      final filePath = '$fileName';
      await supabase.storage.from('child').upload(fileName, _document!);
      return supabase.storage.from('child').getPublicUrl(fileName);
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        dobController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  int calculateAgeInMonths(String dob) {
    try {
      DateTime birthDate = DateFormat("yyyy-MM-dd").parse(dob);
      DateTime today = DateTime.now();

      int years = today.year - birthDate.year;
      int months = today.month - birthDate.month;

      if (today.day < birthDate.day) {
        months -= 1;
      }

      return (years * 12) + months;
    } catch (e) {
      print("Error parsing date: $e");
      return 0;
    }
  }

  Future<void> insert() async {
    try {
      int ageInMonths = calculateAgeInMonths(dobController.text.trim());
      await supabase.from('tbl_child').insert({
        'name': nameController.text.trim(),
        'age': ageInMonths,
        'gender': selGender,
        'dob': dobController.text.trim(),
        'documents': await uploadDocument(), // Use uploaded document URL
        'parent_id': supabase.auth.currentUser!.id,
        'photo': await uploadImage(),
        'fee_type': _selectedFeeName,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Child registered successfully!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Account()),
      );
    } catch (e) {
      print('ERROR REGISTERING CHILD $e');
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
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? const Icon(Icons.camera_alt,
                              color: Colors.black, size: 50)
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selGender,
                  hint: Text('Gender'),
                  items: genderOp.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selGender = newValue;
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: dobController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      labelText: 'DOB',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
                SizedBox(height: 10),
                // Document picker button
                GestureDetector(
                  onTap: _pickDocument,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _document == null
                              ? 'Select Document'
                              : 'Document: ${_document!.path.split('/').last}',
                          style: TextStyle(
                              color: _document == null
                                  ? Colors.grey
                                  : Colors.black),
                        ),
                        Icon(Icons.attach_file, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                const Text("Admission Fee Type"),
                Row(
                  children: [
                    for (var fee in ['Full', 'Half', 'Daily'])
                      Row(
                        children: [
                          Radio(
                            value: fee,
                            groupValue: _selectedFeeName,
                            onChanged: (value) {
                              setState(() => _selectedFeeName = value.toString());
                            },
                          ),
                          Text(fee),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFbc6c25),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    insert();
                  },
                  child: Text(
                    'Register Child',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xfff8f9fa),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}