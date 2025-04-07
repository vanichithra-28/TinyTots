import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tinytots_parent/main.dart';
import 'package:tinytots_parent/screen/account.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cherry_toast/cherry_toast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> signin() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response= await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await Future.delayed(Duration(seconds: 1));
       final user = response.user;
    if (user != null) {
      final parentData = await supabase
          .from('tbl_parent')
          .select()
          .eq('parent_email', emailController.text.trim())
          .single();

      if (parentData != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Account()),
        );
      } else {
        CherryToast.error(
          description: Text("Access denied. Only parents can log in."),
          animationType: AnimationType.fromRight,
          autoDismiss: true,
        ).show(context);
      }
    }
    } catch (e) {
      CherryToast.error(
        description: Text("No user found for that email."),
        animationType: AnimationType.fromRight,
        autoDismiss: true,
      ).show(context);
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
   return Scaffold(
  backgroundColor: Color(0xFFeceef0),
  body: Center(
    child: isLoading
        ? Lottie.asset('assets/Loading.json', width: 200, height: 200,)
        : Form(
            child: Padding(
              padding: EdgeInsets.only(top: 110, left: 20, right: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color(0xFFffffff),
                ),
                height: 500,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      Text("Welcome Back",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            prefixIcon: Icon(Icons.lock),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFbc6c25),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          signin();
                        },
                        child: Text(
                          'LOGIN',
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
          ),
  ),
);


  }
}
