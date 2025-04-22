import 'package:flutter/material.dart';
import 'package:flutter_course_app/SignUp.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
        actions: [Icon(Icons.account_box_sharp)],
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("LOGIN", style: TextStyle(fontSize: 30)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Email:"),
                TextField(controller: email),
                SizedBox(height: 16),
                Text("Senha:"),
                TextField(controller: password),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.amber.shade100,
                  ),
                  child: Text("Logar"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Não possui conta? "),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Signup()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Text(
                    "Registre-se",
                    style: TextStyle(color: Colors.blue),
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
