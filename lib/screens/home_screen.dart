import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pcchatz/widgets/category_selector.dart';
import 'package:pcchatz/screens/show_screen.dart';

class HomeScreen extends StatefulWidget {
  // this is a firebase_auth user - it gets converted to a firestore document _user for further use
  final dynamic user;
  HomeScreen({Key key, this.user}) : super(key: key);

  @override 
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _name = ' ';
  int _screen = 0;
  dynamic _user;

  goToScreen(int screenid) {
    setState(() {
      _screen = screenid;
    });
  }
  
  Future getUser(String uid) async {
    DocumentReference docRef = Firestore.instance.collection('users').document(uid);
    docRef.get().then((datasnapshot) {
      if(datasnapshot.exists) {
        setState(() {
          _name = datasnapshot.data['fname'];
          _user = datasnapshot.data;
        });
      }
    }).catchError((err) => print(err));
  }
  
  @override
  void initState() { 
    if(_name == ' ') {
      getUser(widget.user.uid);
    }
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    String name = 'PC Chats';
    if(_name != ' ') {
      name += (' - ' + _name);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          name,
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          CategorySelector(notifyParent: goToScreen,),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  _user == null ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                  ) : ShowScreen(screenid: _screen, user: _user)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}