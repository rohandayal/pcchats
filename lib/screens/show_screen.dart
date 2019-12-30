import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pcchatz/widgets/home_screen_chat.dart';
import 'package:pcchatz/screens/users_screen.dart';
import 'package:theme_provider/theme_provider.dart';

class ShowScreen extends StatefulWidget {
  final int screenid;
  final dynamic user;
  ShowScreen({Key key, this.screenid, this.user}) : super(key: key);

  @override
  _ShowScreenState createState() => _ShowScreenState();
}

class _ShowScreenState extends State<ShowScreen> {
  dynamic messages;
  Future<dynamic> messagesFuture;

  @override
  void initState() { 
    messagesFuture = Firestore.instance.collection('messages')
                    .where(
                      'receiver', isEqualTo: widget.user['uid'],
                    ).orderBy('time', descending: true)
                    .getDocuments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.screenid == 0) {
      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: FutureBuilder(
            future: messagesFuture,
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                ),);
              }
              if(!snapshot.hasData) {
                return Center(
                  child: Text(
                    'No chats :(',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                    ),
                  ),
                );
              }
              messages = snapshot.data.documents;
              return HomeScreenChat(messages: messages, user: widget.user,);
            }
          ),
        ),
      );
    } else if (widget.screenid == 1) {
      return UsersScreen(user: widget.user);
    } else {
      return Column(
        children: <Widget>[
          Text(
            'Theme',
            style: TextStyle(
              color: Colors.black,
              backgroundColor: Colors.red,
            ),
          ),
          IconButton(
            icon: Icon(Icons.palette),
            onPressed: () {
              showDialog(context: context,
                builder: (_) => ThemeConsumer(
                  child: ThemeDialog(),
                ) 
              );
            } 
          ),
        ],
      );
    }
  }
}