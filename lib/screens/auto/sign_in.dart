import 'package:daniel_test/screens/auto/authenticate.dart';
import 'package:daniel_test/screens/auto/login.dart';
import 'package:daniel_test/screens/home/home.dart';
import 'package:daniel_test/screens/wrapper.dart';
import 'package:daniel_test/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatelessWidget {
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    final _init = Firebase.initializeApp();
    return FutureBuilder(
      future: _init,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorWidget();
        } else if (snapshot.hasData) {
          return MultiProvider(
              providers: [
                ChangeNotifierProvider<AuthServices>.value(
                    value: AuthServices()),
                StreamProvider<User?>.value(
                    value: AuthServices().user, initialData: null)
              ],
              child: MaterialApp(
                theme: ThemeData(primarySwatch: Colors.blue),
                home: Wrapper(),
              ));
        } else
          return Loading();
      },
    );
  }
}

class ErrorWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [Icon(Icons.error), Text('Somthing get wrong!')],
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
