import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pcchatz/screens/home_screen.dart';
import 'package:pcchatz/widgets/google_sign_in_widget.dart';
import 'package:theme_provider/theme_provider.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController emailNameInputController;
  TextEditingController pwdNameInputController;
  TextEditingController confirmPwdNameInputController;
  String uid = '';
  
  @override
  void initState() {
    firstNameInputController = new TextEditingController();
    emailNameInputController = new TextEditingController();
    pwdNameInputController = new TextEditingController();
    confirmPwdNameInputController = new TextEditingController();
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

  String pwdValidator(String value) {
    if(value.length < 5) {
      return 'Password must be at least 5 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text('Register'),
       ),
       body: Container(
         padding: EdgeInsets.all(20.0),
         child: SingleChildScrollView(
           child: Form(
             key: _registerFormKey,
             child: Column(
               children: <Widget>[
                GoogleSignInButton(),
                SizedBox(
                  height: 20.0,
                ),
                 TextFormField(
                   decoration: InputDecoration(
                     labelText: 'Name*',
                   ),
                   controller: firstNameInputController,
                   validator: (value) {
                     if(value.length < 2) {
                       return "At least 2 letters for a valid first name";
                     } else {
                       return null;
                     }
                   },
                   textCapitalization: TextCapitalization.words,
                 ),
                 TextFormField(
                   decoration: InputDecoration(
                     labelText: 'Email*',
                     hintText: 'a@b.com',
                   ),
                   controller: emailNameInputController,
                   keyboardType: TextInputType.emailAddress,
                   validator: emailValidator,
                 ),
                 TextFormField(
                   decoration: InputDecoration(
                     labelText: 'Password*',
                   ),
                   controller: pwdNameInputController,
                   obscureText: true,
                   validator: pwdValidator,
                 ),
                 TextFormField(
                   decoration: InputDecoration(
                     labelText: 'Confirm Password*',
                   ),
                   controller: confirmPwdNameInputController,
                   obscureText: true,
                   validator: pwdValidator,
                 ),
                 RaisedButton(
                   child: Text('Register'),
                   color: Theme.of(context).primaryColor,
                   textColor: Colors.white,
                   onPressed: () {
                     if(_registerFormKey.currentState.validate()) {
                       if(pwdNameInputController.text == confirmPwdNameInputController.text) {
                         FirebaseAuth.instance.createUserWithEmailAndPassword(
                           email: emailNameInputController.text,
                           password: pwdNameInputController.text,
                         ).then((currentUser) => Firestore.instance.collection('users')
                          .document(currentUser.user.uid)
                            .setData({
                              "uid": currentUser.user.uid,
                              "fname": firstNameInputController.text,
                              "email": emailNameInputController.text,
                              "imageURL": "",
                            }).then((result) => {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ThemeConsumer(child: HomeScreen(user: currentUser.user,)),
                                ),
                                (_) => false
                              ),
                              firstNameInputController.clear(),
                              emailNameInputController.clear(),
                              pwdNameInputController.clear(),
                              confirmPwdNameInputController.clear(),
                            }).catchError((err) => print(err))
                         ).catchError((err) => print(err));
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('Passwords do not match'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          }
                        );
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text('Already have an account?'),
                FlatButton(
                  child: Text('Login'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
               ],
             ),
           ),
         ),
       ),
    );
  }
}