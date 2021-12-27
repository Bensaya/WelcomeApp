import 'package:daniel_test/screens/auto/login.dart';
import 'package:daniel_test/screens/auto/register.dart';
import 'package:flutter/material.dart';

class Authentication extends StatefulWidget {
  @override
  Authentication_State createState() => Authentication_State();
}

class Authentication_State extends State<Authentication> {
  bool isToggle = false;
  void toggleScreen() {
    setState(() {
      isToggle = !isToggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isToggle) {
      return Register(
        toggleScreen: toggleScreen,
      );
    } else
      return Login(toggleScreen: toggleScreen);
  }
}
