import 'package:daniel_test/screens/auto/authenticate.dart';
import 'package:daniel_test/screens/auto/auto.dart';
import 'package:daniel_test/screens/auto/sign_in.dart';
import 'package:daniel_test/screens/home/home.dart';
import 'package:daniel_test/screens/home/menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return either the Home or Authenticate widget
    final user = Provider.of<User?>(context);
    if (user != null) {
      return const Menu();
    } else {
      return Authentication();
    }
  }
}
