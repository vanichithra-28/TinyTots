import 'package:flutter/material.dart';
import 'package:tinytots_staff/main.dart';

class Change extends StatefulWidget {
  const Change({super.key});

  @override
  State<Change> createState() => _ChangepwdState();
}

class _ChangepwdState extends State<Change> {
  final TextEditingController currentpwdController = TextEditingController();
  final TextEditingController newpwdController = TextEditingController();
  final TextEditingController confirmpwdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  Future<void> updatepwd() async {
    if (!_formKey.currentState!.validate()) return;
    final String currentPwd = currentpwdController.text.trim();
    final String newPwd = newpwdController.text.trim();
    final String confirmPwd = confirmpwdController.text.trim();

    if (newPwd != confirmPwd) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New password and confirm password do not match')),
      );
      return;
    }
    try {
      String? staffData = supabase.auth.currentUser!.id;
      await supabase.from('tbl_staff').update({
        'staff_pwd': newPwd,
      }).eq('id', staffData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password Updated',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      await fetchpass();
      newpwdController.clear();
      confirmpwdController.clear();
    } catch (e) {
      print('ERROR UPDATING PASSWORD:$e');
    }
  }

  Future<void> fetchpass() async {
    try {
      String? staffData = supabase.auth.currentUser!.id;
      if (staffData != null) {
        final response = await supabase
            .from('tbl_staff')
            .select()
            .eq('id', staffData)
            .single();
        setState(() {
          currentpwdController.text = response['staff_pwd'];
        });
      } else {
        print('Error');
      }
    } catch (e) {
      print('ERROR FETCHING PASSWORD:$e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchpass();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff8f9fa),
        appBar: AppBar(
          backgroundColor: Color(0xffffffff),
          title: Text('Change Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: 700,
            width: 500,
            decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  )
                ]),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 80),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: currentpwdController,
                        obscureText: _obscureCurrent,
                        decoration: InputDecoration(
                          labelText: 'Current password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureCurrent
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureCurrent = !_obscureCurrent;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your current password';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: newpwdController,
                        obscureText: _obscureNew,
                        decoration: InputDecoration(
                          labelText: 'New password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureNew
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureNew = !_obscureNew;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a new password';
                          }
                          final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~^%()_+\-=\[\]{};:"\\|,.<>\/?]).{8,}$');
                          if (!passwordRegex.hasMatch(value)) {
                            return 'Password must be at least 8 characters,\ninclude upper, lower, number, and special character';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: confirmpwdController,
                        obscureText: _obscureConfirm,
                        decoration: InputDecoration(
                          labelText: 'Confirm password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirm
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureConfirm = !_obscureConfirm;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your new password';
                          }
                          final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~^%()_+\-=\[\]{};:"\\|,.<>\/?]).{8,}$');
                          if (!passwordRegex.hasMatch(value)) {
                            return 'Password must be at least 8 characters,\ninclude upper, lower, number, and special character';
                          }
                          if (value != newpwdController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        updatepwd();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFbc6c25),
                        padding: EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Update',
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
        ));
  }
}
