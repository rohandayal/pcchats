import 'package:flutter/material.dart';

class UserRow extends StatefulWidget {
  final user;
  UserRow({Key key, this.user}) : super(key: key);

  @override
  _UserRowState createState() => _UserRowState();
}

class _UserRowState extends State<UserRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text(
          widget.user["fname"],
          style: TextStyle(
            color: Colors.black,
            backgroundColor: Colors.yellow,
         ),
       ),
    );
  }
}