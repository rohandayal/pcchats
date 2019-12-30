import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pcchatz/screens/home_screen.dart';
import 'package:pcchatz/widgets/google_sign_in_widget.dart';
import 'package:theme_provider/theme_provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  @override
  void initState() { 
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if(!regex.hasMatch(value)) {
      return 'Email format is not valid';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            GoogleSignInButton(),
            SizedBox(
              height: 40.0,
            ),
            Text("-- OR --",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            SingleChildScrollView(
              child: Form(
                key: _loginFormKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email*',
                      ),
                      controller: emailInputController,
                      keyboardType: TextInputType.emailAddress,
                      validator: emailValidator,
                    ),
                    TextFormField(
                       decoration: InputDecoration(
                         labelText: 'Password*',
                         hintText: '************',
                       ),
                       controller: pwdInputController,
                       obscureText: true,
                     ),
                     RaisedButton(
                       child: Text('Login'),
                       color: Theme.of(context).primaryColor,
                       textColor: Colors.white,
                       onPressed: () {
                         if(_loginFormKey.currentState.validate()) {
                           FirebaseAuth.instance.signInWithEmailAndPassword(
                             email: emailInputController.text,
                             password: pwdInputController.text,
                           ).then((currentUser) => 
                            Firestore.instance.collection('users')
                              .document(currentUser.user.uid)
                                .get()
                                  .then((DocumentSnapshot result) =>
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ThemeConsumer(child: HomeScreen(user: currentUser.user))
                                      )
                                    )
                                  ).catchError((err) => print(err))
                           ).catchError((err) => print(err));
                         }
                       },
                     ),
                     Text("Don't have an account yet?"),
                     FlatButton(
                       child: Text('Register'),
                       onPressed: () {
                         Navigator.pushNamed(context, '/register');
                       },
                     )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}