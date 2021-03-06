import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'login_screen.dart';

class SplashPage extends StatefulWidget {
  static const String routeName = "/splash";
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 3,
      navigateAfterSeconds: new LoginScreen(),
      title: new Text(
        'Equation Solver',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      image: Image.asset(
        "assets/icons/math.png",
        width: 400,
        height: 400,
      ),
      backgroundColor: Colors.white,
      loaderColor: Colors.red,
    );
  }
}
