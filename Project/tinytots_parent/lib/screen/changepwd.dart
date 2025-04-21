import 'package:flutter/material.dart';
import 'package:tinytots_parent/main.dart';

class Changepwd extends StatefulWidget {
  const Changepwd({super.key});

  @override
  State<Changepwd> createState() => _ChangepwdpwdState();
}

class _ChangepwdpwdState extends State<Changepwd> {
  final TextEditingController currentpwdController = TextEditingController();
  final TextEditingController newpwdController = TextEditingController();
  final TextEditingController confirmpwdController = TextEditingController();

  bool _showCurrentPwd = false;
  bool _showNewPwd = false;
  bool _showConfirmPwd = false;

  Future<void> updatepwd() async {
    final String currentPwd = currentpwdController.text.trim();
    final String newPwd = newpwdController.text.trim();
    final String confirmPwd = confirmpwdController.text.trim();

    final passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~^%()_+\-=\[\]{};:"\\|,.<>\/?]).{8,}$',
    );

    if (currentPwd.isEmpty || newPwd.isEmpty || confirmPwd.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }
    if (newPwd.contains(' ')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password should not contain spaces')),
      );
      return;
    }
    if (!passwordRegExp.hasMatch(newPwd)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password must be at least 8 characters and include uppercase, lowercase, number, and special character',
          ),
        ),
      );
      return;
    }
    if (newPwd == currentPwd) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New password must be different from current password')),
      );
      return;
    }
    if (newPwd != confirmPwd) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New password and confirm password do not match')),
      );
      return;
    }
    try {
      String? parentData = supabase.auth.currentUser!.id;
      await supabase.from('tbl_parent').update({
        'parent_pwd': newPwd,
      }).eq('id', parentData);
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating password: $e')),
      );
    }
  }

  Future<void> fetchpass() async {
    try {
      String? parentData = supabase.auth.currentUser!.id;
      // ignore: unnecessary_null_comparison
      if (parentData != null) {
        final response = await supabase
            .from('tbl_parent')
            .select()
            .eq('id', parentData)
            .single();
        setState(() {
          currentpwdController.text = response['parent_pwd'];
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
    // TODO: implement initState
    super.initState();
    fetchpass();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f9fa),
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
        title: Text('Edit Profile'),
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
            child: Column(
              children: [
                SizedBox(height: 80),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: currentpwdController,
                    obscureText: !_showCurrentPwd,
                    decoration: InputDecoration(
                      labelText: 'current password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showCurrentPwd ? Icons.visibility : Icons.visibility_off,
                          color: Color(0xFFbc6c25),
                        ),
                        onPressed: () {
                          setState(() {
                            _showCurrentPwd = !_showCurrentPwd;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: newpwdController,
                    obscureText: !_showNewPwd,
                    decoration: InputDecoration(
                      labelText: 'New password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showNewPwd ? Icons.visibility : Icons.visibility_off,
                          color: Color(0xFFbc6c25),
                        ),
                        onPressed: () {
                          setState(() {
                            _showNewPwd = !_showNewPwd;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: confirmpwdController,
                    obscureText: !_showConfirmPwd,
                    decoration: InputDecoration(
                      labelText: 'Confirm password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showConfirmPwd ? Icons.visibility : Icons.visibility_off,
                          color: Color(0xFFbc6c25),
                        ),
                        onPressed: () {
                          setState(() {
                            _showConfirmPwd = !_showConfirmPwd;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    updatepwd();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFbc6c25),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Update ',
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
