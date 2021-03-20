import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:provider/provider.dart';
import 'package:solvequation/constants/constants.dart';
import 'package:solvequation/provider/google_sign_in.dart';
import 'package:solvequation/routes.dart';

class AppDrawer extends StatefulWidget {
  final Function onTap;

  AppDrawer({this.onTap});

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final user = FirebaseAuth.instance.currentUser;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FacebookLogin facebookLogin = FacebookLogin();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: buildDrawer(context),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 70,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.photoURL) ??
                        AssetImage('assets/images/placeholder.png'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  user.refreshToken ?? "User",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  user.email ?? "",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black45),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: kPrimaryColor,
                  height: 50,
                  onPressed: () async {
                    // Navigator.pushReplacementNamed(context, Routes.login);
                    // context.read<AuthenticationService>().signOut();
                    await logout();
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                      ),
                      Text(
                        'LOGOUT',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Icon(
                      //   Icons.logout,
                      //   color: Colors.white,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    var tokenFB = facebookLogin.currentAccessToken.then((token) {
      if (token != null) {
        _auth.signOut().then((onValue) {
          facebookLogin.logOut();
        });
      } else {
        final provider =
            Provider.of<GoogleSignInProvider>(context, listen: false);
        provider.logout();
        _auth.signOut().then((onValue) {
          facebookLogin.logOut();
        });
      }
    });
    Navigator.pushReplacementNamed(context, Routes.login);
  }
}
