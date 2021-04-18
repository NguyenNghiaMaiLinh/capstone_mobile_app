import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:solvequation/routes.dart';
import 'package:solvequation/ui/home/splash_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Solve Equation',
      color: Colors.white,
      initialRoute: SplashPage.routeName,
      routes: Routes.getRoutes(context),
    );
  }
}
