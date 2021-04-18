import 'package:custom_switch/custom_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:solvequation/constants/constants.dart';
import 'package:solvequation/routes.dart';

class AppDrawer extends StatefulWidget {
  final Function onTap;

  AppDrawer({this.onTap});

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final user = FirebaseAuth.instance.currentUser;
  bool auto;
  @override
  void initState() {
    super.initState();
    final storage = new FlutterSecureStorage();
    storage.read(key: "auto").then((value) {
      if (value == "true") {
        if (user == null) {
          Navigator.pushReplacementNamed(context, Routes.login);
        }
        setState(() {
          auto = true;
        });
      } else {
        setState(() {
          auto = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: buildDrawer(context),
    );
  }

  _logout() async {
    await FirebaseAuth.instance.signOut();
    final facebookLogin = FacebookLogin();
    final GoogleSignIn googleSignIn = new GoogleSignIn();
    googleSignIn.isSignedIn().then((s) {
      googleSignIn.signOut();
    });
    facebookLogin.isLoggedIn.then((b) {
      facebookLogin.logOut();
    });
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    width: 40,
                    height: 40,
                    color: Colors.white10,
                    child: CircleAvatar(
                        backgroundImage: AssetImage('assets/icons/math.png'),
                        backgroundColor: Colors.white10),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: Text(
                        "Solve equation",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      )),
                ]),
          ),
          Divider(
            color: Colors.black,
            height: 1,
          ),
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 70,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user?.photoURL ??
                            'https://www.edmundsgovtech.com/wp-content/uploads/2020/01/default-picture_0_0.png') ??
                        AssetImage('assets/images/placeholder.png'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  user?.displayName ?? "User",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    "Email",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.12,
                        child: Icon(
                          Icons.email_outlined,
                          color: Colors.black54,
                        )),
                    Text(
                      user?.email ?? "...",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black45),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      children: [
                        Text(
                          "Auto save",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black45),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        (auto)
                            ? CustomSwitch(
                                activeColor: kPrimaryColor,
                                value: true,
                                onChanged: (value) {
                                  final storage = new FlutterSecureStorage();
                                  setState(() {
                                    auto = value;
                                  });
                                  storage.delete(key: "auto");
                                  storage.write(
                                      key: "auto", value: value.toString());
                                },
                              )
                            : CustomSwitch(
                                activeColor: kPrimaryColor,
                                value: false,
                                onChanged: (value) {
                                  final storage = new FlutterSecureStorage();
                                  setState(() {
                                    auto = value;
                                  });
                                  storage.delete(key: "auto");
                                  storage.write(
                                      key: "auto", value: value.toString());
                                },
                              ),
                      ],
                    )),
              ]),
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
                    _logout();
                    Navigator.pushReplacementNamed(context, Routes.login);
                    // context.read<AuthenticationService>().signOut();
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

  // Future<void> logout() async {
  //   var tokenFB = facebookLogin.currentAccessToken.then((token) {
  //     if (token != null) {
  //       _auth.signOut().then((onValue) {
  //         facebookLogin.logOut();
  //       });
  //     } else {
  //       final provider =
  //           Provider.of<GoogleSignInProvider>(context, listen: false);
  //       provider.logout();
  //       _auth.signOut().then((onValue) {
  //         facebookLogin.logOut();
  //       });
  //     }
  //   });
  //   Navigator.pushReplacementNamed(context, Routes.login);
  // }
}
