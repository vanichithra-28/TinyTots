// ignore_for_file: sort_child_properties_last

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
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
  List<Map<String, dynamic>> _eventList = [];

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

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> storeData() async {
    try {
      String name = _nameController.text;
      String date = _dateController.text;
      String details = _detailsController.text;

      String? url = await photoUpload(name);

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
      await display();
      _nameController.clear();
      _dateController.clear();
      _detailsController.clear();
    } catch (e) {
      print("Error inserting event details:$e");
    }
  }

  Future<String?> photoUpload(String name) async {
    try {
      if (pickedImage?.bytes == null) {
        print("No image selected");
        return null;
      }

      final bucketName = 'admin';
      final filePath =
          "${sanitizeFileName(name)}-${sanitizeFileName(pickedImage!.name)}";

      await supabase.storage.from(bucketName).uploadBinary(
            filePath,
            pickedImage!.bytes!,
          );
      final publicUrl =
          supabase.storage.from(bucketName).getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      print("Error photo upload: $e");
      return null;
    }
  }

  String sanitizeFileName(String fileName) {
    return fileName.replaceAll(RegExp(r'[^\w\-_\.]'), '_');
  }

  Future<void> display() async {
    try {
      final response = await supabase
          .from('tbl_event')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        _eventList = response;
      });
    } catch (e) {
      print("ERROR FETCHING TASKS $e");
    }
  }

  Future<void> delete(int delId) async {
    try {
      await supabase.from('tbl_event').delete().eq('id', delId);
      display();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          " Deleted",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      print('ERROR IN DELETING$e');
    }
  }

  @override
  void initState() {
    super.initState();
    display();
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
              height: 630,
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
                                color: Color(0xff3e53a0),
                                size: 50,
                              ),
                            )
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
                                        File(pickedImage!
                                            .path!), // For mobile/desktop
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          labelText: 'Event Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                          labelText: 'Event Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3),
                          )),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _detailsController,
                      decoration: InputDecoration(
                          labelText: 'Event Deatils',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          storeData();
                        },
                        child: Text('submit'))
                  ],
                ),
              ),
              width: 400,
              decoration: BoxDecoration(
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
            flex: 2,
            child: Container(
              height: 630,
              
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
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
                  SizedBox(
                      height: 600,
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20.0,
                          mainAxisSpacing: 25.0,
                          childAspectRatio: 1.3,
                        ),
                        itemCount: _eventList.length,
                        itemBuilder: (context, index) {
                          final event = _eventList[index];
                          return Card(
                            color: Color(0xff3e53a0),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 250,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2.5),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              event['event_photo']),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(child: Text(event['event_name'],style:TextStyle(color: Color(0xffffffff),),)),
                                    Expanded(child: Text(event['event_date'],style:TextStyle(color: Color(0xffffffff),),)),
                                    IconButton(
                                      onPressed: () {
                                       delete(event['id']);
                                      },
                                      icon: HugeIcon(
                                        icon: HugeIcons.strokeRoundedDelete02,
                                        color: Color(0xffffffff),
                                        size: 24.0,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
