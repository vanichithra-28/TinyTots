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
  Future<void> updatepwd() async {
    final String currentPwd = currentpwdController.text.trim();
    final String newPwd = newpwdController.text.trim();
    final String confirmPwd = confirmpwdController.text.trim();
    
    if (currentPwd.isEmpty || newPwd.isEmpty || confirmPwd.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }
    if (newPwd != confirmPwd) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('New password and confirm password do not match')),
      );
      return;
    }
    try {
       String? staffData 
    = supabase.auth.currentUser!.id;
      await supabase.from('tbl_parent').update({
        'parent_pwd': newPwd,
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
    String? staffData 
    = supabase.auth.currentUser!.id;
    if (staffData != null) {
      final response =await  supabase
          .from('tbl_parent')
          .select()
          .eq('id', staffData)
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
                  SizedBox(
                    height: 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: currentpwdController,
                      decoration: InputDecoration(
                          labelText: 'current password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: newpwdController,
                      decoration: InputDecoration(
                          labelText: 'New password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: confirmpwdController,
                      decoration: InputDecoration(
                          labelText: 'Confirm password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        updatepwd();
                      },
                      child: Text('Update ')),
                ],
              ),
            ),
          ),
        ));
  }
}
