import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daniel_test/screens/auto/authenticate.dart';
import 'package:daniel_test/screens/wrapper.dart';
import 'package:daniel_test/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_launch/flutter_launch.dart';

class EditDryer extends StatefulWidget {
  const EditDryer({
    Key? key,
    required this.doc,
    required this.name,
    required this.app,
    required this.phoneNumber,
    required this.uid,
  }) : super(key: key);
  final Map<String, dynamic> doc;
  final String name;
  final String app;
  final String phoneNumber;
  final String uid;

  @override
  EditDryerState createState() => EditDryerState();
  /*State<StatefulWidget> createState() {
    return EditWashingState();
  }*/
}

class EditDryerState extends State<EditDryer> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _appartment = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  late int? _progLength;
  List<String> programs = [
    "בחר תוכנית",
    "סינטטית 40",
    "כותנה 30",
    "יומיומית מהירה"
  ];
  String? program;
  bool taken = true;
  Map<String, int> time = {
    "סינטטית 40": 115,
    "כותנה 30": 120,
    "יומיומית מהירה": 30
  };
  @override
  void initState() {
    program = programs[0];
    taken = widget.doc["taken"];
    super.initState();
    _name = TextEditingController(text: widget.name);
    //print(name);
    _appartment = TextEditingController(text: widget.app);
    _phoneNumber = TextEditingController(text: widget.phoneNumber);
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
              title: Text(widget.doc["Name"]),
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
                        "Name",
                        style: TextStyle(fontSize: 23),
                      ),
                      TextFormField(
                          enabled: false,
                          controller: _name,
                          validator: (val) => val!.isEmpty
                              ? "Please enter a valid name"
                              : null),
                      const SizedBox(
                        height: 20,
                      ),
                      Text("Apartment", style: TextStyle(fontSize: 23)),
                      TextFormField(
                        enabled: false,
                        controller: _appartment,
                        validator: (val) =>
                            val!.isEmpty ? "Please enter a valid App" : null,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text("Phone Number", style: TextStyle(fontSize: 23)),
                      TextFormField(
                        enabled: false,
                        controller: _phoneNumber,
                        validator: (val) => val!.isEmpty
                            ? "Please enter a valid Phone number"
                            : null,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text("Program", style: TextStyle(fontSize: 23)),
                      DropdownButton<String>(
                          value: program,
                          items: programs.map(buildMenu).toList(),
                          onChanged: (value) => setState(() {
                                program = value;
                                _progLength = time[program];
                                print(_progLength);
                                FirebaseFirestore.instance
                                    .collection("Counters")
                                    .doc(widget.doc["Name"])
                                    .update({"Time": _progLength});
                              })),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(children: [
                        Text("Send message"),
                        SizedBox(
                          width: 20,
                        ),
                        IconButton(
                            onPressed: () async {
                              String message =
                                  "Hi, can you clear the washing machine";
                              String phone = _phoneNumber.text;
                              String url =
                                  "whatsapp://sed?phone=$phone&text=$message";
                              await canLaunch(url)
                                  ? launch(url)
                                  : print("error");
                            },
                            icon: Icon(Icons.message))
                      ]),
                      MaterialButton(
                        child: taken
                            ? Text("Free",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold))
                            : Text(
                                'Save',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                        onPressed: () async {
                          if (!taken) {
                            saveAnotherUser(user!.uid);
                            await Future.delayed(Duration(seconds: 2));
                            FirebaseFirestore.instance
                                .collection("Dryers")
                                .doc(widget.doc["Name"])
                                .update({"User": user.uid, "taken": true});
                          } else if (user!.uid == widget.doc["User"]) {
                            await Future.delayed(Duration(seconds: 2));
                            saveAnotherUser("Default");
                            FirebaseFirestore.instance
                                .collection("Dryers")
                                .doc(widget.doc["Name"])
                                .update({"User": "Default", "taken": false});
                          }

                          Navigator.pop(context);
                        },
                        height: 70,
                        minWidth: double.infinity,
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  DropdownMenuItem<String> buildMenu(String item) => DropdownMenuItem(
        child: Text(item),
        value: item,
      );

  Future<void> saveAnotherUser(String uid) async {
    var res =
        await FirebaseFirestore.instance.collection("Users").doc(uid).get();

    _name.text = res.get("Name");
    _appartment.text = res.get("Apartment");
    _phoneNumber.text = res.get("PhoneNumber");
    taken = !taken;
  }
}
