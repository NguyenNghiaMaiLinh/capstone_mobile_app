import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solvequation/blocs/customer_service.dart';
import 'package:solvequation/constants/constants.dart';
import 'package:solvequation/routes.dart';
import 'package:solvequation/widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Confirm exit'),
            content: new Text('Do you want to exit?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        appBar: new AppBar(backgroundColor: kPrimaryColor, actions: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
            width: 40,
            height: 40,
            child: CircleAvatar(
              backgroundImage: NetworkImage(user?.photoURL) ??
                  AssetImage('assets/images/placeholder.png'),
            ),
          ),
        ]),
        drawer: AppDrawer(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Stack(children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Text(
                //   "Home",
                //   style: GoogleFonts.openSans(
                //       textStyle: TextStyle(
                //           color: Colors.black87,
                //           fontSize: 28,
                //           fontWeight: FontWeight.bold)),
                // ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Welcome",
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  user.displayName,
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    "https://play-lh.googleusercontent.com/KeTk1l3wwLJiOuosWO3UYcmLLBS20sr7GA28jkVKwr02ARIjRwNg0V3whRtzVWXIqC8",
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 140,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Text(
                  "Tools",
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          height: MediaQuery.of(context).size.width * 0.42,
                          width: MediaQuery.of(context).size.width * 0.42,
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                "assets/icons/fplash_icon.png",
                                width: 56,
                                height: 56,
                              ),
                              Text(
                                "Solver",
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Text(
                                  "Solve equation in image",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  )),
                                ),
                              ),
                              SizedBox(
                                height: 14,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed(Routes.math);
                        },
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      InkWell(
                        child: Container(
                          height: MediaQuery.of(context).size.width * 0.42,
                          width: MediaQuery.of(context).size.width * 0.42,
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                "assets/icons/exam.png",
                                width: 56,
                                height: 56,
                              ),
                              Text(
                                "History",
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Text(
                                  "Images you saved",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  )),
                                ),
                              ),
                              SizedBox(
                                height: 14,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed(Routes.history);
                        },
                      ),
                    ]),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ]))));
  }

  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? kPrimaryColor : kPrimaryColor,
        ),
      );
    },
  );
}
