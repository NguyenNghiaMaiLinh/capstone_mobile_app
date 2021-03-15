import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:solvequation/ui/home/home.dart';
import 'package:solvequation/ui/home/login_facebook.dart';

class FacebookSignupButtonWidget extends StatefulWidget {
  @override
  _LoginWithFacebookState createState() => _LoginWithFacebookState();
}

class _LoginWithFacebookState extends State<FacebookSignupButtonWidget> {
  bool isSignIn = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FacebookLogin facebookLogin = FacebookLogin();
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(4),
        width: MediaQuery.of(context).size.width * 0.7,
        child: OutlineButton.icon(
          label: Text(
            'Sign In With Facebook',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          highlightedBorderColor: Colors.black,
          borderSide: BorderSide(color: Colors.black),
          textColor: Colors.black,
          icon: FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
          onPressed: () async {
            handleLogin();
          },
        ),
      );

  Future<void> handleLogin() async {
    final FacebookLoginResult result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        print(result.errorMessage);
        break;
      case FacebookLoginStatus.loggedIn:
        try {
          await loginWithfacebook(result);
        } catch (e) {
          print(e);
        }
        break;
    }
  }

  Future loginWithfacebook(FacebookLoginResult result) async {
    final FacebookAccessToken accessToken = result.accessToken;
    if (accessToken != null) {
      AuthCredential credential =
          FacebookAuthProvider.credential(accessToken.token);
      var a = await _auth.signInWithCredential(credential);
      if (a.user != null) {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      }
    }
  }
}
