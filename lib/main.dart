import 'package:daniel_test/screens/auto/sign_in.dart';
import 'package:daniel_test/screens/home/home.dart';
import 'package:daniel_test/screens/wrapper.dart';
import 'package:flutter/material.dart';

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignIn(),
    );
  }
}
