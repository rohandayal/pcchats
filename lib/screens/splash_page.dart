import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:loading/loading.dart';
import 'package:pcchatz/screens/home_screen.dart';
import 'package:theme_provider/theme_provider.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    FirebaseAuth.instance
      .currentUser()
        .then((currentUser) => {
          if(currentUser == null) {
            Navigator.pushReplacementNamed(context, '/login')
          } else {
            Firestore.instance
              .collection("users")
              .document(currentUser.uid)
              .get()
              .then((DocumentSnapshot result) =>
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => ThemeConsumer(child: HomeScreen(user: currentUser)),
                  )
                )
              ).catchError((err) => print(err))
          }
        }).catchError((err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Container(
          alignment: Alignment(0.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Loading(
                indicator: LineScalePulseOutIndicator(),
                size: 100.0,
                color: Theme.of(context).accentColor,
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                'PC Chats',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 21.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}