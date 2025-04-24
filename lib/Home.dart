import 'package:flutter/material.dart';
import 'package:flutter_course_app/ForgetPasswordScreen.dart';
import 'package:flutter_course_app/SignUp.dart';
import 'package:flutter_course_app/services/AuthServices/auth_services.dart';
import 'package:page_transition/page_transition.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool loader = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
        actions: [Icon(Icons.account_box_sharp)],
      ),
      body: SingleChildScrollView(
        child: Container(
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
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child:
                        loader
                            ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.orange,
                              ),
                            )
                            : TextButton(
                              onPressed: () async {
                                setState(() {
                                  loader = true;
                                });
                                await AuthServices.handleSignIn(
                                  email.text.toString(),
                                  password.text.toString(),
                                  context,
                                );
                                setState(() {
                                  loader = false;
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.amber.shade100,
                              ),
                              child: Text("Logar"),
                            ),
                  ),
                  SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,

                    child: TextButton(
                      onPressed: () async {
                        AuthServices.signInWithGoogle();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.amber.shade100,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "images/google.png",
                            height: 30,
                            width: 30,
                          ),
                          Text("Login google"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Não possui conta? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signup()),
                      );
                    },
                    child: Text(
                      "Registre-se",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Esqueceu a senha?"),
                    GestureDetector(
                      onTap:
                          () => {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: Forgetpasswordscreen(),
                                type: PageTransitionType.fade,
                              ),
                            ),
                          },
                      child: Text(
                        " Clique aqui!!",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
