import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthServices with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = "";
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late String _user;

  Future register(String email, String password) async {
    try {
      final UserCredential authRes = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = authRes.user;
      print(user!.email);
      setLoading(false);
      _user = user.uid;
      return user;
    } on SocketException {
      setLoading(false);
      setMessage("No internet");
    } catch (e) {
      setLoading(false);
      setMessage("Error occuerd");
    }
    notifyListeners();
  }

  Future login(String email, String password) async {
    try {
      final UserCredential authRes = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = authRes.user;
      print(user!.email);
      setLoading(false);
      _user = user.uid;
      return user;
    } on SocketException {
      setLoading(false);
      setMessage("No internet");
    } catch (e) {
      setLoading(false);
      print(e);
      setMessage("Error occuerd");
    }
    notifyListeners();
  }

  Future logout() async {
    await firebaseAuth.signOut();
  }

  void setLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  void setMessage(message) {
    _errorMessage = message;
    notifyListeners();
  }

  Stream<User?> get user =>
      firebaseAuth.authStateChanges().map((event) => event);
}
