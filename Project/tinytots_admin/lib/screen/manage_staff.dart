import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tinytots_admin/main.dart';
import 'package:tinytots_admin/screen/task.dart';

class Staff extends StatefulWidget {
  const Staff({super.key});

  @override
  State<Staff> createState() => _StaffState();
}

class _StaffState extends State<Staff> with SingleTickerProviderStateMixin {
  bool _isFormVisible = false;
  @override
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController startdateController = TextEditingController();

  final TextEditingController statusController = TextEditingController();
  List<Map<String, dynamic>> _staffList = [];
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

  Future<void> register() async {
    try {
      final auth = await supabase.auth
          .signUp(password: passController.text, email: emailController.text);
      final uid = auth.user!.id;
      if (uid.isNotEmpty || uid != "") {
        insert(uid);
      }
    } catch (e) {
      print('ERROR REGISTERING STAFF:$e');
    }
  }

  void insert(final id) async {
    try {
      String Name = nameController.text;
      String Email = emailController.text;
      String Contact = contactController.text;
      String pwd = passController.text;
      
      String? url = await photoUpload(id);
      if(url!.isNotEmpty){
      await supabase.from('tbl_staff').insert({
        'id': id,
        'staff_name': Name,
        'staff_email': Email,
        'staff_contact': Contact,
        'staff_pwd': pwd,
        
        'staff_photo': url,
      });
      }
      display();
      nameController.clear();
      emailController.clear();
      contactController.clear();
      startdateController.clear();
      passController.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Inserted"),
      ));
    } catch (e) {
      print('ERROR:$e');
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

  //DISPLAY
  void display() async {
    try {
      final reponse = await supabase.from('tbl_staff').select();
      setState(() {
        _staffList = reponse;
      });
    } catch (e) {
      print('ERROR: $e');
    }
  }

  //delete
  Future<void> delete(int delId) async {
    try {
      await supabase.from('tbl_staff').delete().eq('id', delId);
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
String formatDate(String timestamp) {
  DateTime date = DateTime.parse(timestamp);
  return DateFormat('dd-MM-yyyy').format(date); // Formats to YYYY-MM-DD
}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    display();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 1100, top: 10),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff3e53a0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4))),
                onPressed: () {
                  setState(() {
                    _isFormVisible = !_isFormVisible; // Toggle form visibility
                  });
                },
                label: Text(
                  _isFormVisible ? "Cancel" : "Add Staff",
                  style: TextStyle(color: Color(0xFFeceef0)),
                ),
                icon: Icon(
                  _isFormVisible ? Icons.cancel : Icons.add,
                  color: Color(0xFFeceef0),
                ),
              ),
            ),
            SizedBox(
              height: 5.00,
            )
          ],
        ),
        AnimatedSize(
          duration: _animationDuration,
          curve: Curves.easeInOut,
          child: _isFormVisible
              ? Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.all(
                        Radius.zero,
                      ),
                    ),
                    child: Form(
                        child: Padding(
                      padding: const EdgeInsets.only(
                        left: 300.0,
                        right: 300,
                      ),
                      child: Center(
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
                            SizedBox(
                              height: 10,
                            ),
                            
                            
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                  labelText: 'Name',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.zero)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.zero)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: contactController,
                              decoration: InputDecoration(
                                  labelText: 'Contact',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.zero)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: passController,
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.zero)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                           
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff3e53a0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4))),
                                onPressed: () {
                                  register();
                                },
                                child: Text("Insert",style: TextStyle(color: Color(0xFFeceef0)),))
                          ],
                        ),
                      ),
                    )),
                  ),
                )
              : Container(),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'STAFF DETAILS',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff8b8c89)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: EdgeInsets.all(16), // Padding inside the container
            margin: EdgeInsets.all(16), // Margin outside the container
            decoration: BoxDecoration(
              color: Color(0xffffffff), // Background color of the container
              borderRadius: BorderRadius.zero, // Rounded corners
              border: Border.all(
                color: Color(0xFFeceef0), // Border color
                width: 2, // Border width
              ),
            ),
            child: DataTable(
              columns: [
                DataColumn(
                    label: Text('Sl.No',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff8b8c89)))),
                            DataColumn(
                    label: Text('Photo',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff8b8c89)))),
                DataColumn(
                    label: Text('Name',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff8b8c89)))),
                DataColumn(
                    label: Text('Email',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff8b8c89)))),
                DataColumn(
                    label: Text('Contact',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff8b8c89)))),
                DataColumn(
                    label: Text('Start Date',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff8b8c89)))),
                DataColumn(
                    label: Text('',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold))),
                             DataColumn(
                    label: Text('Action',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold,
                            color: Color(0xff8b8c89)))),
              ],
              rows: _staffList.asMap().entries.map((entry) {
                return DataRow(cells: [
                  DataCell(Text(
                    (entry.key + 1).toString(),
                    style: TextStyle(color: Color(0xff8b8c89)),
                  )),
                  DataCell(
                    CircleAvatar(
                      backgroundImage: NetworkImage(entry.value['staff_photo']),
                    )
                  ),
                  DataCell(
                    Text(
                      entry.value['staff_name'],
                      style: TextStyle(color: Color(0xff8b8c89)),
                    ),
                  ),
                  DataCell(Text(
                    entry.value['staff_email'],
                    style: TextStyle(color: Color(0xff8b8c89)),
                  )),
                  DataCell(Text(
                    entry.value['staff_contact'],
                    style: TextStyle(color: Color(0xff8b8c89)),
                  )),
                  DataCell(Text(formatDate(entry.value['created_at'],),
                    style: TextStyle(color: Color(0xff8b8c89)),
                  )),
                  DataCell(IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      delete(entry.value['id']);
                    },
                  )),
                  DataCell(ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff3e53a0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4))),
                    onPressed: () {
                      Navigator.push(
                      context,
                         MaterialPageRoute(
                        builder: (context) =>Task(staffId: entry.value['id'],)));
                    },
                    child: Text('Assign',style: TextStyle(color: Color(0xFFeceef0)),),
                  ))
                ]);
              }).toList(),
            ),
          ),
        )
      ],
    );
  }
}
