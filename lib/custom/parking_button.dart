import 'package:flutter/material.dart';

class ParkingButton extends StatelessWidget {
  const ParkingButton(
      {Key? key,
      required this.title,
      required this.onPressed,
      required this.id,
      required this.taken,
      required this.doc,
      required this.collection})
      : super(key: key);
  final String title;
  final Function onPressed;
  final String id;
  final bool taken;
  final Map<String, dynamic> doc;
  final String collection;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        child: Text(title),
        onPressed: () => onPressed(doc, id, collection),
        style: ElevatedButton.styleFrom(
            primary: taken ? Colors.red : Colors.green),
      ),
    );
  }
}
