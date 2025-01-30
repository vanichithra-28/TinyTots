import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tinytots_admin/main.dart';
import 'package:file_picker/file_picker.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
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

  
  Future<void> storeData(String uid) async {
    try {
      String name = _nameController.text;
      String date = _dateController.text;
      String details = _detailsController.text;
     
      String? url = await photoUpload(uid);

      if (url!.isNotEmpty) {
        await supabase.from('tbl_event').insert({
          'event_name': name,
          'event_date': date,
          'event_details': details,
          
          
          'event_photo': url,
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Event details added",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ));
      } else {
        print("Event not given");
      }
    } catch (e) {
      print("Error inserting teacher details:$e");
    }
  }
    Future<String?> photoUpload(String uid) async {
    try {
      final bucketName = 'admin'; // Replace with your bucket name
      final filePath = "$uid-${pickedImage!.name}";
      await supabase.storage.from(bucketName).uploadBinary(
            filePath,
            pickedImage!.bytes!, // Use file.bytes for Flutter Web
          );
      final publicUrl =
          supabase.storage.from(bucketName).getPublicUrl(filePath);
      // await updateImage(uid, publicUrl);
      return publicUrl;
    } catch (e) {
      print("Error photo upload: $e");
      return null;
    }
  }
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Container(
              height: 500,
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  children: [
                    SizedBox(
                              height: 120,
                              width: 120,
                              child: pickedImage == null
                                  ? GestureDetector(
                                      onTap: handleImagePick,
                                      child: Icon(
                                        Icons.add_a_photo,
                                        color: Color(0xFF0277BD),
                                        size: 50,
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: handleImagePick,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: pickedImage!.bytes != null
                                            ? Image.memory(
                                                Uint8List.fromList(pickedImage!
                                                    .bytes!), // For web
                                                fit: BoxFit.cover,
                                              )
                                            : Image.file(
                                                File(pickedImage!
                                                    .path!), // For mobile/desktop
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                            ),
                    SizedBox(height: 30,),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        
                       labelText: 'Event Name',
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                      )),
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                       labelText: 'Event Date',
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                      )),
                    ),SizedBox(height: 10,),
                    TextFormField(
                      controller: _detailsController,
                      decoration: InputDecoration(
                        
                        labelText: 'Event Deatils',
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                      )),
                    ),SizedBox(height: 10,),
                    ElevatedButton(onPressed: () {
                      storeData('id');
                    }, child: Text('submit'))
                  ],
                  
                ),
              ),
              width: 400,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: const Color(0xffffffff),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    )
                  ]),
                  
            ),
            
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 500,
              child: Text(
                'event ',
                style: TextStyle(color: Color.fromARGB(255, 219, 214, 214)),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: const Color(0xffffffff),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    )
                  ]),
              width: 400,
            ),
          ),
          SizedBox(
            width: 20,
            
          ),
           
        ],
      ),
    );
  }
}
