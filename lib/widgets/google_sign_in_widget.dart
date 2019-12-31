import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pcchatz/screens/home_screen.dart';
import 'package:theme_provider/theme_provider.dart';

class GoogleSignInButton extends StatefulWidget {
  GoogleSignInButton({Key key}) : super(key: key);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  dynamic user;
  
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken
    );
    final AuthResult authResult = await FirebaseAuth.instance.signInWithCredential(credential);
    FirebaseUser fbuser = authResult.user;
    var userToken = fbuser.getIdToken();
    
    assert(!fbuser.isAnonymous);
    assert(await userToken != null);
    
    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    assert(fbuser.uid == currentUser.uid);

    user = currentUser;
    Firestore.instance.collection('users').document(currentUser.uid).setData({
      "uid": currentUser.uid,
      "fname": currentUser.displayName,
      "email": currentUser.email,
      "imageURL": currentUser.photoUrl,
      "tokenID": userToken.toString(),
    });
    return currentUser.uid;
  }
  
  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().whenComplete(() {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ThemeConsumer(child: HomeScreen(user: user)),
            ),
            (_) => false
          );
        });
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      highlightElevation: 0,
      borderSide: BorderSide(
        color: Colors.grey,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 0.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image(
              image: AssetImage("assets/google_logo.png"),
              height: 35.0,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 10.0
              ),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}