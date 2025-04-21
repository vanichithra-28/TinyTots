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
      setState(() {
        pickedImage = null; // Remove the picked image after submit
      });
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
      // Delete participants referencing this event
      await supabase.from('tbl_participant').delete().eq('event_id', delId);

      // Now delete the event
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
          SizedBox(width: 20),
          // Event Form Card
          Expanded(
            child: Container(
              height: 630,
              decoration: BoxDecoration(
                color: const Color(0xfff4f6fa),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.12),
                    spreadRadius: 4,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  children: [
                    // Image Picker
                    SizedBox(
                      height: 110,
                      width: 110,
                      child: pickedImage == null
                          ? GestureDetector(
                              onTap: handleImagePick,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xffeceef0),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Color(0xff3e53a0),
                                  size: 44,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: handleImagePick,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: pickedImage!.bytes != null
                                    ? Image.memory(
                                        Uint8List.fromList(pickedImage!.bytes!),
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(pickedImage!.path!),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                    ),
                    SizedBox(height: 24),
                    // Event Name
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Event Name',
                        prefixIcon: Icon(Icons.event, color: Color(0xff3e53a0)),
                        filled: true,
                        fillColor: Color(0xffeceef0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    // Event Date
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Event Date',
                        prefixIcon: Icon(Icons.calendar_today,
                            color: Color(0xff3e53a0)),
                        filled: true,
                        fillColor: Color(0xffeceef0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),
                    SizedBox(height: 12),
                    // Event Details
                    TextFormField(
                      controller: _detailsController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Event Details',
                        prefixIcon:
                            Icon(Icons.description, color: Color(0xff3e53a0)),
                        filled: true,
                        fillColor: Color(0xffeceef0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff3e53a0),
                          foregroundColor: Color(0xffeceef0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: storeData,
                        icon: Icon(Icons.send,
                            color: Color(0xffeceef0), size: 20),
                        label: Text('Submit', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 18),
          // Event Grid Card
          Expanded(
            flex: 2,
            child: Container(
              height: 630,
              decoration: BoxDecoration(
                color: const Color(0xfff4f6fa),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.12),
                    spreadRadius: 4,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "All Events",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff3e53a0),
                      ),
                    ),
                    SizedBox(height: 12),
                    Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 18.0,
                          mainAxisSpacing: 18.0,
                          childAspectRatio: 1.25,
                        ),
                        itemCount: _eventList.length,
                        itemBuilder: (context, index) {
                          final event = _eventList[index];
                          return Card(
                            color: Color(0xff3e53a0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Event Image
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(14)),
                                  child: Container(
                                    height: 120,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color(0xffeceef0),
                                    ),
                                    child: event['event_photo'] != null
                                        ? Image.network(
                                            event['event_photo'],
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(Icons.event,
                                            size: 60, color: Color(0xff3e53a0)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        event['event_name'] ?? '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_today,
                                              size: 16,
                                              color: Color(0xffeceef0)),
                                          SizedBox(width: 4),
                                          Text(
                                            event['event_date'] ?? '',
                                            style: TextStyle(
                                              color: Color(0xffeceef0),
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        event['event_details'] ?? '',
                                        style: TextStyle(
                                          color: Color(0xffeceef0),
                                          fontSize: 13,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        // Edit event
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            final TextEditingController
                                                editNameController =
                                                TextEditingController(
                                                    text: event['event_name']);
                                            final TextEditingController
                                                editDateController =
                                                TextEditingController(
                                                    text: event['event_date']);
                                            final TextEditingController
                                                editDetailsController =
                                                TextEditingController(
                                                    text:
                                                        event['event_details']);
                                            return AlertDialog(
                                              title: Text('Edit Event'),
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    TextFormField(
                                                      controller:
                                                          editNameController,
                                                      decoration:
                                                          InputDecoration(
                                                              labelText:
                                                                  'Event Name'),
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          editDateController,
                                                      decoration:
                                                          InputDecoration(
                                                              labelText:
                                                                  'Event Date'),
                                                      onTap: () async {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                FocusNode());
                                                        DateTime? picked =
                                                            await showDatePicker(
                                                          context: context,
                                                          initialDate: DateTime
                                                                  .tryParse(
                                                                      editDateController
                                                                          .text) ??
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime(2000),
                                                          lastDate:
                                                              DateTime(2100),
                                                        );
                                                        if (picked != null) {
                                                          editDateController
                                                                  .text =
                                                              "${picked.toLocal()}"
                                                                  .split(
                                                                      ' ')[0];
                                                        }
                                                      },
                                                      readOnly: true,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          editDetailsController,
                                                      decoration: InputDecoration(
                                                          labelText:
                                                              'Event Details'),
                                                      maxLines: 2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text('Cancel'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    await supabase
                                                        .from('tbl_event')
                                                        .update({
                                                      'event_name':
                                                          editNameController
                                                              .text,
                                                      'event_date':
                                                          editDateController
                                                              .text,
                                                      'event_details':
                                                          editDetailsController
                                                              .text,
                                                    }).eq('id', event['id']);
                                                    Navigator.pop(context);
                                                    display();
                                                  },
                                                  child: Text('Save'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.edit,
                                          color: Color(0xffeceef0)),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        delete(event['id']);
                                      },
                                      icon: HugeIcon(
                                        icon: HugeIcons.strokeRoundedDelete02,
                                        color: Color(0xffeceef0),
                                        size: 22.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
