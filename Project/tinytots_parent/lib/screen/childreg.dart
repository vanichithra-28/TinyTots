import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tinytots_parent/main.dart';
import 'package:tinytots_parent/screen/account.dart';
import 'package:file_picker/file_picker.dart';

class ChildRegistration extends StatefulWidget {
  const ChildRegistration({super.key});

  @override
  State<ChildRegistration> createState() => _ChildRegistrationState();
}

class _ChildRegistrationState extends State<ChildRegistration> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  String _selectedFeeName = 'Full';

  File? _image;
  File? _document;
  final ImagePicker _picker = ImagePicker();

  String? selGender;
  final List<String> genderOp = ['Male', 'Female'];

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'doc', 'docx'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _document = File(result.files.single.path!);
      });
    }
  }

  Future<String?> uploadImage() async {
    print("Image: $_image");
    if (_image == null) return null;
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'child-photo-$timestamp';
      await supabase.storage.from('child').upload(fileName, _image!);
      return supabase.storage.from('child').getPublicUrl(fileName);
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  Future<String?> uploadDocument() async {
    print("Document: $_document");
    if (_document == null) return null;
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'child-document-$timestamp.${_document!.path.split('.').last}';
      await supabase.storage.from('document').upload(fileName, _document!);
      return supabase.storage.from('document').getPublicUrl(fileName);
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
    if (!_formKey.currentState!.validate()) return;
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a photo of the child.')),
      );
      return;
    }
    if (_document == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a document.')),
      );
      return;
    }
    if (selGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select gender.')),
      );
      return;
    }
    try {
      int ageInMonths = calculateAgeInMonths(dobController.text.trim());
      await supabase.from('tbl_child').insert({
        'name': nameController.text.trim(),
        'age': ageInMonths,
        'gender': selGender,
        'dob': dobController.text.trim(),
        'parent_id': supabase.auth.currentUser!.id,
        'photo': await uploadImage(),
        'documents': await uploadDocument(),
        'fee_type': _selectedFeeName,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Child registered successfully!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Account()),
      );
    } catch (e) {
      print('ERROR REGISTERING CHILD $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Child Registration',
            style: TextStyle(
              color: Color(0xFFbc6c25),
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: const Color(0xFFffffff),
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFFbc6c25)),
      ),
      backgroundColor: const Color(0xFFf8f9fa),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.97),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.10),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color.fromARGB(255, 232, 236, 236),
                        backgroundImage: _image != null ? FileImage(_image!) : null,
                        child: _image == null
                            ? const Icon(Icons.camera_alt, color: Color(0xFFbc6c25), size: 50)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Child Name',
                      prefixIcon: const Icon(Icons.person, color: Color(0xFFbc6c25)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 233, 235, 235).withOpacity(0.13),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selGender,
                    hint: const Text('Gender'),
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
                      prefixIcon: const Icon(Icons.wc, color: Color(0xFFbc6c25)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 237, 238, 238).withOpacity(0.13),
                    ),
                    validator: (value) =>
                        value == null ? 'Please select gender' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: dobController,
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      prefixIcon: const Icon(Icons.cake, color: Color(0xFFbc6c25)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 230, 233, 233).withOpacity(0.13),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'DOB is required' : null,
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _pickDocument,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFf9fbe7),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _document == null
                                  ? 'Select Document (pdf, jpg, png, doc, docx)'
                                  : 'Document: ${_document!.path.split('/').last}',
                              style: TextStyle(
                                color: _document == null ? Colors.grey : Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const Icon(Icons.attach_file, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Admission Fee Type",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFbc6c25),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (var fee in ['Full', 'Half', 'Daily'])
                        Row(
                          children: [
                            Radio(
                              value: fee,
                              groupValue: _selectedFeeName,
                              activeColor: const Color(0xFFbc6c25),
                              onChanged: (value) {
                                setState(() => _selectedFeeName = value.toString());
                              },
                            ),
                            Text(fee),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFbc6c25),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: insert,
                      child: const Text(
                        'Register Child',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xfff8f9fa),
                          fontWeight: FontWeight.bold,
                        ),
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
}