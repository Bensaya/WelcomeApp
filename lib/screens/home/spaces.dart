import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daniel_test/custom/laundry_button.dart';
import 'package:daniel_test/custom/parking_button.dart';
import 'package:daniel_test/custom/space_button.dart';
import 'package:daniel_test/screens/auto/authenticate.dart';
import 'package:daniel_test/screens/home/edit_drayr.dart';
import 'package:daniel_test/screens/home/edit_spaces.dart';
import 'package:daniel_test/screens/home/edit_washing.dart';
import 'package:daniel_test/screens/wrapper.dart';
import 'package:daniel_test/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class SpacesRoom extends StatefulWidget {
  const SpacesRoom({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SpacesRoomState();
  }
}

class SpacesRoomState extends State<SpacesRoom> {
  late DocumentSnapshot<Map<String, dynamic>>? washinguser;
  String _name = "";
  String _app = "";
  String _phoneNumber = "";
  List<String> _programs = [];

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);
    final user = Provider.of<User?>(context);
    final Stream<QuerySnapshot> _stream =
        FirebaseFirestore.instance.collection('Spaces').snapshots();
    DocumentSnapshot washinguser;
    final Stream<QuerySnapshot> _stream2 =
        FirebaseFirestore.instance.collection('Dryers').snapshots();
    return MaterialApp(
        theme: Theme.of(context),
        home: Scaffold(
            appBar: AppBar(
              title: Text('Spaces'),
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
            body: SingleChildScrollView(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> document =
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;
                              print(user!.uid);
                              return InkWell(
                                  onTap: () async {
                                    getUser(document["User"]);
                                    await Future.delayed(Duration(seconds: 1));
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) => EditSpaces(
                                                  doc: document,
                                                  app: _app,
                                                  name: _name,
                                                  phoneNumber: _phoneNumber,
                                                  uid: document["User"],
                                                )));
                                  },
                                  child: SpacesButton(
                                    title: document["Name"],
                                    id: snapshot.data!.docs[index].id,
                                    taken: document["taken"],
                                    doc: document,
                                    collection: "Spaces",
                                  ));
                            });
                      },
                    ),
                  ),
                ],
              ),
            )));
  }

  Future<void> getUser(String user) async {
    var res =
        await FirebaseFirestore.instance.collection("Users").doc(user).get();
    _name = res.get("Name");
    print(res.id);
    _app = res.get("Apartment");
    _phoneNumber = res.get("PhoneNumber");
    var result = await FirebaseFirestore.instance.collection('Program').get();
    var documents = result.docs;
  }
}
