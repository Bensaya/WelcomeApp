import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daniel_test/custom/parking_button.dart';
import 'package:daniel_test/screens/auto/authenticate.dart';
import 'package:daniel_test/screens/wrapper.dart';
import 'package:daniel_test/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  void onClick(Map<String, dynamic> doc, String id, String collection) {
    bool res = !doc["taken"];
    FirebaseFirestore.instance
        .collection(collection)
        .doc(id)
        .update({"taken": res});
  }

  _callNumber() async {
    const number = '0509374353'; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);
    final user = Provider.of<User?>(context);
    final Stream<QuerySnapshot> _stream =
        FirebaseFirestore.instance.collection('Parking').snapshots();
    final Stream<QuerySnapshot> _stream2 =
        FirebaseFirestore.instance.collection('Parking2').snapshots();
    return MaterialApp(
        theme: Theme.of(context),
        home: Scaffold(
            appBar: AppBar(
              title: Text('Parking '),
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
                              return ParkingButton(
                                title: document["Name"],
                                onPressed: onClick,
                                id: snapshot.data!.docs[index].id,
                                taken: document["taken"],
                                doc: document,
                                collection: "Parking",
                              );
                            });
                      },
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 475,
                      ),
                      Container(
                          width: 100,
                          height: 100,
                          child: ButtonTheme(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(32),
                                  ),
                                  onPressed: () => _callNumber(),
                                  child: Text("Gate"))))
                    ],
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _stream2,
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
                              return ParkingButton(
                                  title: document["Name"],
                                  onPressed: onClick,
                                  id: snapshot.data!.docs[index].id,
                                  taken: document["taken"],
                                  doc: document,
                                  collection: "Parking2");
                            });
                      },
                    ),
                  ),
                ],
              ),
            )));
  }
}
