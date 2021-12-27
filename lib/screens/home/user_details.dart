import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daniel_test/screens/auto/authenticate.dart';
import 'package:daniel_test/screens/wrapper.dart';
import 'package:daniel_test/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UserDetailsState();
  }
}

class UserDetailsState extends State<UserDetails> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _appartment = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  @override
  void initState() {
    _name = TextEditingController();
    _appartment = TextEditingController();
    _phoneNumber = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _appartment.dispose();
    _phoneNumber.dispose();
    super.dispose();
  }

  void showSimpleDialog(BuildContext context, String title, String content) =>
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close))
              ],
            );
          });

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);
    final Stream<QuerySnapshot> _stream =
        FirebaseFirestore.instance.collection('Users').snapshots();
    final user = Provider.of<User?>(context);
    String _error = "";
    return MaterialApp(
        theme: Theme.of(context),
        home: Scaffold(
            appBar: AppBar(
              title: Text('User Details'),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back)),
                IconButton(
                    onPressed: () async {
                      await loginProvider.logout();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Wrapper()));
                    },
                    icon: Icon(Icons.exit_to_app))
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Text(
                        "Enter your name",
                        style: TextStyle(fontSize: 23),
                      ),
                      TextFormField(
                          controller: _name,
                          validator: (val) => val!.isEmpty
                              ? "Please enter a valid name"
                              : null),
                      const SizedBox(
                        height: 20,
                      ),
                      Text("Enter your Apartment number",
                          style: TextStyle(fontSize: 23)),
                      TextFormField(
                        controller: _appartment,
                        validator: (val) =>
                            val!.isEmpty ? "Please enter a valid name" : null,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text("Enter your Phone number",
                          style: TextStyle(fontSize: 23)),
                      TextFormField(
                        controller: _phoneNumber,
                        validator: (val) =>
                            val!.isEmpty ? "Please enter a valid name" : null,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      MaterialButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            String uid = user!.uid;
                            DocumentSnapshot ds = await FirebaseFirestore
                                .instance
                                .collection("Users")
                                .doc(uid)
                                .get();
                            if (ds.exists) {
                              showSimpleDialog(
                                  context, "Error", "You already have a user");
                              print(_error);
                            } else {
                              FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(uid)
                                  .set({
                                "Name": _name.text,
                                "Apartment": _appartment.text,
                                "PhoneNumber": _phoneNumber.text
                              });
                              showSimpleDialog(context, "Success",
                                  "User added successfully");
                            }
                          }
                        },
                        height: 70,
                        minWidth: double.infinity,
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
