import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:tinytots_staff/main.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final TextEditingController titleController = TextEditingController();
  PlatformFile? pickedImage;
  Future<void> handleImagePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false, // Only single file upload
    );
    if (result != null) {
      setState(() {
        pickedImage = result.files.first;
      });
    }
  }

  Future<String?> photoUpload(String staffId) async {
    try {
      final bucketName = 'post';
      // Include staffId in the file path to ensure uniqueness
      final filePath = "$staffId-${pickedImage!.name}";
      await supabase.storage.from(bucketName).uploadBinary(
            filePath,
            pickedImage!.bytes!,
          );
      final publicUrl =
          supabase.storage.from(bucketName).getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      print("Error photo upload: $e");
    }
    return null;
  }

  Future<void> storeData() async {
    try {
      String staffId = supabase.auth.currentUser!.id;
      String title = titleController.text;
      String? url = await photoUpload(staffId);

      if (url != null && url.isNotEmpty) {
        await supabase.from('tbl_post').insert({
          'post_file': url,
          'post_title': title,
          'staff_id': staffId, // Add staffId to the database
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Post details added",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ));
        titleController.clear();
      } else {
        print("post not given");
      }
    } catch (e) {
      print("Error inserting post details:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: pickedImage == null
                  ? GestureDetector(
                      onTap: handleImagePick,
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedImageAdd02,
                        color: Colors.black,
                        size: 50.0,
                      ))
                  : GestureDetector(
                      onTap: handleImagePick,
                      child: ClipRRect(
                        borderRadius: BorderRadius.zero,
                        child: pickedImage!.bytes != null
                            ? Image.memory(
                                Uint8List.fromList(
                                    pickedImage!.bytes!), // For web
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(pickedImage!.path!), // For mobile/desktop
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                    )),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffffffff),
                    ),
              onPressed: () {
                storeData();
              },
              
              child: Text('Upload'),
            )
          ],
        ),
      ),
    );
  }
}
