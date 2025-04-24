import 'package:flutter/material.dart';
import 'package:flutter_course_app/services/AuthServices/auth_services.dart';

class Forgetpasswordscreen extends StatefulWidget {
  const Forgetpasswordscreen({super.key});

  @override
  State<Forgetpasswordscreen> createState() => _ForgetpasswordscreenState();
}

class _ForgetpasswordscreenState extends State<Forgetpasswordscreen> {
  TextEditingController email = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(32),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Recuperar senha"),
            SizedBox(height: 20),
            TextField(
              controller: email,
              decoration: InputDecoration(hintText: "Digite o seu email"),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                if (email.text.isEmpty) {
                  AuthServices.showSnackBar("PLEASE ADD EMAIL", context);
                } else if (!isValidEmail(email.text)) {
                  AuthServices.showSnackBar(
                    "PLEASE ADD A CORRECT EMAIL",
                    context,
                  );
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  AuthServices.resetPasswordSendWmail(email.text, context);
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              style: TextButton.styleFrom(backgroundColor: Colors.orangeAccent),
              child: Text(
                "Send password to email",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}
