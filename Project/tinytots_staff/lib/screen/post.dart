import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tinytots_staff/main.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final TextEditingController titleController = TextEditingController();
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

  Future<String?> uploadImage(String staffId) async {
    try {
      final fileName =
          '$staffId-${DateTime.now().millisecondsSinceEpoch}.jpg'; // Unique file name
      await supabase.storage.from('post').upload(fileName, _image!);

      // Get public URL of the uploaded image
      final imageUrl = supabase.storage.from('post').getPublicUrl(fileName);
      return imageUrl;
    } catch (e) {
      print('Image upload failed: $e');
      return null;
    }
  }

  Future<void> storeData() async {
    try {
      final staffId = supabase.auth.currentUser?.id;
      if (staffId == null) {
        print("User is not authenticated");
        return;
      }

      final title = titleController.text;
      if (title.isEmpty) {
        print("Title is empty");
        return;
      }

      if (_image == null) {
        print("No image selected");
        return;
      }

      // Upload image and get URL
      final imageUrl = await uploadImage(staffId);
      if (imageUrl == null) {
        print("Image upload failed");
        return;
      }

      // Insert data into the database
      await supabase.from('tbl_post').insert({
        'staff_id': staffId,
        'post_file': imageUrl,
        'post_title': title,
      });

      print("Data inserted successfully");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Post added successfully",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );

      titleController.clear();
      setState(() {
        _image = null;
      });
    } catch (e) {
      print("Error inserting post data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Failed to add post",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            decoration:BoxDecoration( 
            color: Color(0xffffffff),),
            child: Column(
              
              children: [
                
                GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 450,
                      width: 500,
                      decoration: BoxDecoration(
                        image: _image != null
                            ? DecorationImage(
                                image: FileImage(_image!),
                                fit: BoxFit.cover,
                              )
                            : null,
                            color: Color(0xffffffff)
                      ),
                      child: _image == null
                          ? const HugeIcon(
                              icon: HugeIcons.strokeRoundedPlayListAdd,
                              color: Colors.black,
                              size: 70.0,
                            )
                          : null,
                    )
                    
                    ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: storeData,
                  child: const Text(
                    'Upload',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 10,)
              ],
            ),
          ),
        ),
      );
    
  }
}
