import 'package:flutter/material.dart';

class SpacesButton extends StatelessWidget {
  const SpacesButton(
      {Key? key,
      required this.title,
      //required this.onPressed,
      required this.id,
      required this.taken,
      required this.doc,
      required this.collection})
      : super(key: key);
  final String title;
  //final Function onPressed;
  final String id;
  final bool taken;
  final Map<String, dynamic> doc;
  final String collection;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          color: taken ? Colors.red : Colors.green,
          child: Text(
            title,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
  }
}
