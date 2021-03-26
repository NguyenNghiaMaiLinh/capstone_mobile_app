import 'package:flutter/widgets.dart';
import 'package:solvequation/ui/camera/camera.dart';
import 'package:solvequation/ui/home/detail_history.dart';
import 'package:solvequation/ui/home/history_screen.dart';
import 'package:solvequation/ui/home/home.dart';
import 'package:solvequation/ui/home/login_gmail.dart';
import 'package:solvequation/ui/home/splashscreen.dart';

class Routes {
  static const String math = CameraPage.routeName;
  static const String home = HomeScreen.routeName;
  static const String splash = SplashPage.routeName;
  static const String login = LoginScreen.routeName;
  static const String history = HistoryScreen.routeName;
  static const String detail_history = DetailHistory.routeName;

  static getRoutes(BuildContext context) {
    return {
      math: (context) => CameraPage(null, false),
      home: (context) => HomeScreen(),
      splash: (context) => SplashPage(),
      login: (context) => LoginScreen(),
      history: (context) => HistoryScreen(),
      detail_history: (context) => DetailHistory(null),
    };
  }
}
