import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_course_app/LoginAndRegister/Home.dart';
import 'firebase_options.dart';

void main() {
  runApp(MaterialApp(home: Home()));

  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
