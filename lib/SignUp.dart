import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_course_app/Home.dart';
import 'package:flutter_course_app/services/AuthServices/auth_services.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool loader = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up Page"),
        actions: [Icon(Icons.account_box_sharp)],
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Sign up", style: TextStyle(fontSize: 30)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Email:"),
                TextField(controller: email),
                SizedBox(height: 16),
                Text("Senha:"),
                TextField(controller: password),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child:
                      loader
                          ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.orange,
                            ),
                          )
                          : TextButton(
                            onPressed: () async {
                              setState(() {
                                loader = true;
                              });
                              await AuthServices.handleSignUp(
                                email.text.toString(),
                                password.text.toString(),
                                context,
                              );
                              setState(() {
                                loader = false;
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            child: Text("Registar"),
                          ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
